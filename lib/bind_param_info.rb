require 'ffi'

# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-bind-param-info-str.html
class SQLAnywhere::BindParamInfo < FFI::Struct

  layout(
    :direction, SQLAnywhere::DataDirection,
    :input_value, SQLAnywhere::DataValue,
    :name, :string,
    :output_value, SQLAnywhere::OutputValue,
  )
end
