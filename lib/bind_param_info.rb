require 'ffi'

# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-bind-param-info-str.html
class SQLAnywhere::BindParamInfo < FFI::Struct

  layout(
    :name, :string,
    :direction, SQLAnywhere::DataDirection,
    :input_value, SQLAnywhere::DataValue,
    :output_value, SQLAnywhere::DataValue,
  )
end
