require 'ffi'


class SQLAnywhere
  API_VERSION_1 = 1
  API_VERSION_2 = 2

  extend FFI::Library

  DataType = enum [
    :invalid_type,
    :binary,
    :string,
    :double,
    :val64, # 64 bit integer
    :uval64, # 64 bit unsigned integer
    :val32,
    :uval32,
    :val16,
    :uval16,
    :val8,
    :uval8,
  ]

  DataDirection = enum [
    :invalid, 0,
    :input,
    :output,
    :input_output,
  ]

end

require File.dirname(__FILE__) + '/libc.rb'
require File.dirname(__FILE__) + '/sql_anywhere_interface.rb'
require File.dirname(__FILE__) + '/api.rb'
require File.dirname(__FILE__) + '/data_value.rb'
require File.dirname(__FILE__) + '/bind_param.rb'
