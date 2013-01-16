require 'ffi'

# http://dcx.sybase.com/1200/en/dbprogramming/programming-sacpp-a-sqlany-data-value-str.html
class SQLAnywhere::DataValue < FFI::Struct

  layout(
    :buffer, :pointer, # deliberately not a string
    :buffer_size, :size_t,
    :length, :pointer,
    :type, SQLAnywhere::DataType,
    :is_null, :pointer,
  )


  def is_null?
    self[:is_null] && self[:is_null].get_int(0) == 1
  end

  def length
    self[:length].read_uint
  end

  def value
    return nil if is_null?

    case self[:type]
    #when :invalid_type
    when :binary
      self[:buffer].get_string(0, length)
    when :string
      self[:buffer].get_string(0, length)
    when :double
      self[:buffer].read_double
    when :val64 # 64 bit integer
      self[:buffer].read_long
    when :unsigned_val64 # 64 bit unsigned integer
      self[:buffer].read_ulong
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
