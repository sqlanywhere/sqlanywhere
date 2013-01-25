require 'ffi'

# 
class SQLAnywhere::DataValue < FFI::Struct

  layout(
    :buffer, :pointer, # deliberately not a string
    :buffer_size, SQLAnywhere::SIZE_T,
    :length, :pointer,
    :type, SQLAnywhere::DataType,
    :is_null, :pointer,
  )

  def inspect
    "<#{self.class} value: #{self.value}, buffer_size: #{self[:buffer_size]}, is_null: #{self.is_null?}, length: #{self.length}, type: #{self[:type]}, buffer: #{self[:buffer]}, length_pointer: #{self[:length]}>"
  end


  def is_null?
    return nil if self[:is_null].null?
    self[:is_null].read_uint == 1
  end

  def length
    return nil if self[:length].null?
    self[:length].read_uint
  end

  def value
    return nil if is_null?

    case self[:type]
    #when :invalid_type
    when :binary, :string
      self[:buffer].get_string(0, length)
    when :double
      self[:buffer].read_double
    when :val64 # 64 bit integer
      self[:buffer].read_long_long
    when :unsigned_val64 # 64 bit unsigned integer
      self[:buffer].read_ulong_long
    when :val32
      self[:buffer].read_int
    when :unsigned_val32
      self[:buffer].read_uint
    when :val16
      self[:buffer].read_short
    when :unsigned_val16
      self[:buffer].read_ushort
    when :val8
      self[:buffer].read_char
    when :unsigned_val8
      self[:buffer].read_uchar
    else
      raise "Type not yet implemented #{self[:type]}"
    end

  end

end
