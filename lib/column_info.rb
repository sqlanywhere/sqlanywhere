require 'ffi'

# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-column-info-str.html
class SQLAnywhere::ColumnInfo < FFI::Struct

  layout(
    # The name of the column (null-terminated).
    # The string can be referenced as long as the result set object is not freed.
    :name, :string,
    :type, SQLAnywhere::DataType,
    :native_type, SQLAnywhere::NativeType,
    :precision, :ushort,
    :scale, :ushort,
    :max_size, :size_t,
    :nullable, SQLAnywhere::Bool,
    )

end
