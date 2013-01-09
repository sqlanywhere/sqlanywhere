require 'ffi'

class SQLAnywhere < FFI::Struct
  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sqlanywhereinterface-str.html
  # The structure has lots of members, are they all required?
  layout(
    :dll_handle, :pointer,
    :initialized, :int,
  )
end


require File.dirname(__FILE__) + '/sql_anywhere_interface.rb'
require File.dirname(__FILE__) + '/api.rb'
