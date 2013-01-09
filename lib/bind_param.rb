require 'ffi'

class SQLAnywhere::BindParam < FFI::Struct

  layout(
    :direction, SQLAnywhere::DataDirection,
    :name, :string,
    :value, SQLAnywhere::DataValue,
    )

end
