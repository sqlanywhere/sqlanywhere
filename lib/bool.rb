require 'ffi'

class SQLAnywhere::Bool < FFI::Struct

  layout(
    :value, :int32,
  )

  def read
    self[:value]
  end

end
