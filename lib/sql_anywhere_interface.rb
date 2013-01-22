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
    size = SQLAnywhere::ERROR_SIZE
    buffer = FFI::MemoryPointer.new(:char, size, false)
    code = sqlany_error_ connection, buffer, size
    return code, buffer.read_string
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-error-met.html
  attach_function :sqlany_error_, :sqlany_error, [:pointer, :pointer, SQLAnywhere::SIZE_T], :int

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

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-prepare-met.html
  attach_function :sqlany_prepare, [:pointer, :string], :pointer

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-num-cols-met.html
  attach_function :sqlany_num_cols, [:pointer], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-commit-met.html
  attach_function :sqlany_commit, [:pointer], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-execute-met.html
  attach_function :sqlany_execute, [:pointer], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-rollback-met.html
  attach_function :sqlany_rollback, [:pointer], :int

  def sqlany_describe_bind_param(statement, index)
    bind_parameter = SQLAnywhere::BindParam.new
    result = sqlany_describe_bind_param_(statement, index, bind_parameter)
    [result, bind_parameter]
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-describe-bind-param-met.html
  attach_function :sqlany_describe_bind_param_, :sqlany_describe_bind_param, [:pointer, :uint32, :pointer], :int

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-bind-param-met.html
  attach_function :sqlany_bind_param, [:pointer, :uint, :pointer], :int

  def sqlany_get_column_info(statement, column_number)

    info = SQLAnywhere::ColumnInfo.new
    
    result = sqlany_get_column_info_(statement, column_number, info)
    [result, column_number, info[:name], info[:type], info[:native_type], info[:precision], info[:scale], info[:max_size], info[:nullable].read]
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-get-column-info-met.html
  attach_function :sqlany_get_column_info_, :sqlany_get_column_info, [:pointer, :uint, :pointer], :int

  def sqlany_sqlstate(connection)
    size = 255
    buffer = FFI::MemoryPointer.new(:char, size, false)
    used = sqlany_sqlstate_(connection, buffer, size)
    buffer.read_string(used)
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-sqlstate-met.html
  attach_function :sqlany_sqlstate_, :sqlany_sqlstate, [:pointer, :pointer, SQLAnywhere::SIZE_T], SQLAnywhere::SIZE_T

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-clear-error-met.html
  attach_function :sqlany_clear_error, [:pointer], :void

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-num-params-met.html
  attach_function :sqlany_num_params, [:pointer], :int
end
