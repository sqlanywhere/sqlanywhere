require 'ffi'

class SQLAnywhere::Bool < FFI::Struct

  layout(
    :value, :int32,
  )

end
