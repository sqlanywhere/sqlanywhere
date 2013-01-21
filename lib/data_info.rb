require 'ffi'

# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-data-info-str.html
class SQLAnywhere::DataInfo < FFI::Struct

  layout(
    :type, SQLAnywhere::DataType,
    :is_null, SQLAnywhere::Bool,
    :data_size, SQLAnywhere::SIZE_T,
    )

end
