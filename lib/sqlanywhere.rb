require 'ffi'


class SQLAnywhere
  API_VERSION_1 = 1
  API_VERSION_2 = 2

  extend FFI::Library

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-a-sqlany-data-direction-enu.html
  DataDirection = enum [
    :invalid, 0,
    :input,
    :output,
    :input_output,
  ]

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-a-sqlany-data-type-enu.html
  DataType = enum [
    :invalid_type,
    :binary,
    :string,
    :double,
    :val64, # 64 bit integer
    :unsigned_val64, # 64 bit unsigned integer
    :val32,
    :unsigned_val32,
    :val16,
    :unsigned_val16,
    :val8,
    :unsigned_val8,
  ]

  # http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-sacapi-h-fil-a-sqlany-native-type-enu.html
  NativeType = enum [
    :no_type,
    :date,
    :time,
    :timestamp,
    :var_char,
    :fix_char,
    :long_var_char,
    :string,
    :double,
    :float,
    :decimal,
    :int,
    :small_int,
    :binary,
    :long_binary,
    :tiny_int,
    :big_int,
    :unsigned_int,
    :unsigned_small_int,
    :unsigned_big_int,
    :bit,
    :long_n_varchar,
  ]

end

require File.dirname(__FILE__) + '/libc.rb'
require File.dirname(__FILE__) + '/sql_anywhere_interface.rb'
require File.dirname(__FILE__) + '/api.rb'
require File.dirname(__FILE__) + '/data_value.rb'
require File.dirname(__FILE__) + '/bind_param.rb'
