require 'ffi'

class SQLAnywhere::SQLAnywhereInterface < FFI::Struct
  # 
  # The structure has lots of members, are they all required?
  layout(
    :dll_handle, :pointer,
    :initialized, :int,
  )

  extend FFI::Library
  ffi_lib 'dbcapi'

  def sqlany_init(app_name = "RUBY", api_version = SQLAnywhere::API_VERSION_2, version_available = FFI::MemoryPointer.new(:int, 1, false))
    sqlany_init_ app_name, api_version, version_available
  end
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-sqlany-init-met.html
  attach_function :sqlany_init_, :sqlany_init, [:string, :uint, :pointer], :int

  attach_function :sqlany_new_connection, [], :pointer


end
