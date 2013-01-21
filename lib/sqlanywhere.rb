require 'ffi'


class SQLAnywhere
  API_VERSION_1 = 1
  API_VERSION_2 = 2

  ERROR_SIZE = 256

  extend FFI::Library

  if FFI.type_size(:size_t) == 4
    SIZE_T = :uint
    def self.write_size_t(location, value)
      location.write_uint(value)
    end
  else
    SIZE_T = :ulong_long
    def self.write_size_t(location, value)
      location.write_ulong_long(value)
    end
  end

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
  # http://dcx.sybase.com/index.html#1201/en/dbprogramming/esqlvar.html
  NativeType = enum [
    # No data type.
    :no_type,
    # Null-terminated character string that is a valid date. 
    :date,
    # Null-terminated character string that is a valid time. 
    :time,
    # Null-terminated character string that is a valid timestamp.
    :timestamp,
    # Varying length character string, in the CHAR character set, with a two-byte length field.
    # The maximum length is 32765 bytes. When sending data, you must set the length field.
    # When fetching data, the database server sets the length field.
    # The data is not null-terminated or blank-padded.
    :var_char,
    # Fixed-length blank-padded character string, in the CHAR character set.
    # The maximum length, specified in bytes, is 32767.
    # The data is not null-terminated. 
    :fix_char,
    # Long varying length character string, in the CHAR character set.
    :long_var_char,
    # Null-terminated character string, in the CHAR character set.
    # The string is blank-padded if the database is initialized with blank-padded strings.
    :string,
    # 8-byte floating-point number. 
    :double,
    # 4-byte floating-point number.
    :float,
    # Packed decimal number (proprietary format). 
    :decimal,
    # 32-bit signed integer.
    :int,
    # 16-bit signed integer.
    :small_int,
    # Varying length binary data with a two-byte length field.
    # The maximum length is 32765 bytes.
    # When supplying information to the database server, you must set the length field.
    # When fetching information from the database server, the server sets the length field. 
    :binary,
    # Long binary data.
    :long_binary,
    # 8-bit signed integer.
    :tiny_int,
    # 64-bit signed integer.
    :big_int,
    # 32-bit unsigned integer.
    :unsigned_int,
    # 16-bit unsigned integer.
    :unsigned_small_int,
    # 64-bit unsigned integer.
    :unsigned_big_int,
    # 8-bit signed integer.
    :bit,
    # Long varying length character string, in the NCHAR character set.
    :long_n_varchar,
  ]

end

# typedefs
require_relative 'bool.rb'

# structures
#
# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-data-value-str.html
require_relative 'data_value.rb'
# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-bind-param-str.html
require_relative 'bind_param.rb'
# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-bind-param-info-str.html
require_relative 'bind_param_info.rb'
# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-column-info-str.html
require_relative 'column_info.rb'
# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-data-info-str.html
require_relative 'data_info.rb'


require_relative 'sql_anywhere_interface.rb'
require_relative 'api.rb'
