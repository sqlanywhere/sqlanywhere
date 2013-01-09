require 'ffi'

class SQLAnywhere::DataValue < FFI::Struct

  layout(
    :buffer, :pointer,
    :buffer_size, :size_t,
    :length, :pointer,
    :type, SQLAnywhere::DataType,
    :is_null, :pointer,
    )

  def is_null?
    self[:is_null].get_int(0) == 1
  end

  def value
    return nil if is_null?

    case self[:type]
    #when :invalid_type
    when :binary
      self[:buffer].get_string(0)
    when :string
      self[:buffer].get_string(0)
    #when :double
    #when :val64 # 64 bit integer
    #when :uval64 # 64 bit unsigned integer
    #when :val32
    #when :uval32
    #when :val16
    #when :uval16
    #when :val8
    #when :uval8
    else
      raise "Type not yet implemented #{self[:type]}"
    end

  end

end
