require 'ffi'

class SQLAnywhere::SQLAnywhereInterface

  extend FFI::Library
  ffi_lib 'dbcapi'

  def sqlany_init(app_name = "RUBY", api_version = SQLAnywhere::API_VERSION_2, version_available = FFI::MemoryPointer.new(:int, 1, false))
    sqlany_init_ app_name, api_version, version_available
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-init-met.html
  attach_function :sqlany_init_, :sqlany_init, [:string, :uint, :pointer], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-new-connection-met.html
  attach_function :sqlany_new_connection, [], :pointer

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-connect-met.html
  attach_function :sqlany_connect, [:pointer, :string], :int

  def sqlany_error(connection)
    size = 255
    buffer = FFI::MemoryPointer.new(:char, size, false)
    code = sqlany_error_ connection, buffer, size
    return code, buffer.read_string
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-error-met.html
  attach_function :sqlany_error_, :sqlany_error, [:pointer, :pointer, :size_t], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-execute-direct-met.html
  attach_function :sqlany_execute_direct, [:pointer, :string], :pointer

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-fetch-next-met.html
  attach_function :sqlany_fetch_next, [:pointer], :int

  def sqlany_get_column(statement, column_number)
    buffer = SQLAnywhere::DataValue.new
    result = sqlany_get_column_(statement, column_number, buffer)
    return [0, nil] if result == 0
    [result, buffer.value]
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-get-column-met.html
  attach_function :sqlany_get_column_, :sqlany_get_column, [:pointer, :uint32, :pointer], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-free-stmt-met.html
  attach_function :sqlany_free_stmt, [:pointer], :void

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-execute-immediate-met.html
  attach_function :sqlany_execute_immediate, [:pointer, :string], :int

  def sqlany_disconnect(connection)
    sqlany_disconnect_(connection)
    return nil
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-disconnect-met.html
  attach_function :sqlany_disconnect_, :sqlany_disconnect, [:pointer], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-free-connection-met.html
  attach_function :sqlany_free_connection, [:pointer], :void

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-fini-met.html
  attach_function :sqlany_fini, [], :void
end
