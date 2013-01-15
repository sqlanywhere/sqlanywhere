require 'ffi'

# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-column-info-str.html
class SQLAnywhere::ColumnInfo < FFI::Struct

  layout(
    :max_size, :size_t,
    :name, :string,
    :native_type, SQLAnywhere::NativeType,
    :nullable, SQLAnywhere::Bool,
    :precision, :ushort,
    :scale, :ushort,
    :type, SQLAnywhere::DataType,
    )

end
