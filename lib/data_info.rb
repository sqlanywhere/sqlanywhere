require 'ffi'

# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-data-info-str.html
class SQLAnywhere::DataInfo < FFI::Struct

  layout(
    :data_size, :size_t,
    :is_null, SQLAnywhere::Bool,
    :type, SQLAnywhere::DataType,
    )

end
