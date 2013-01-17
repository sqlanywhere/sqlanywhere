require 'ffi'

class SQLAnywhere::BindParam < FFI::Struct

  layout(
    :direction, SQLAnywhere::DataDirection,
    :value, SQLAnywhere::DataValue,
    :name, :string,
    )

  def get_name
    self[:name]
  end

  def get_direction
    self[:direction]
  end

  def set_direction d
    self[:direction] = d
  end

  def inspect
    "<#{self.class} direction: #{self[:direction]}, name: #{self[:name]}, value: #{self[:value].inspect}>"
  end

  def set_value(value)

    self[:value][:is_null] = FFI::MemoryPointer.new(SQLAnywhere::Bool, 1, true)

    if self[:direction] == :input

      case value
      when String
        self[:value][:length] = FFI::MemoryPointer.new(:size_t, 1, false)
        length = value.bytesize
        self[:value][:length].write_ulong(length)
        self[:value][:buffer] = FFI::MemoryPointer.new(:char, length + 1, false)

        self[:value][:buffer].put_string(0, value)
        self[:value][:type] = :string

      when Fixnum
        if FFI::Type::POINTER.size == 4 # 32 bit
          self[:value][:buffer] = FFI::MemoryPointer.new(:int, 1, false)
          self[:value][:type] = :val32
        else # 64 bit
          self[:value][:buffer] = FFI::MemoryPointer.new(:long, 1, false)
          self[:value][:type] = :val64
        end
        byte_array = [value].pack(self[:value][:type] == :val32 ? 'l' : 'q')
        offset = 0
        byte_array.each_byte do |b|
          self[:value][:buffer].put_char(offset, b)
          offset += 1
        end

      when Bignum
        self[:value][:buffer] = FFI::MemoryPointer.new(:long_long, 1, false)
        self[:value][:type] = :val64
        byte_array = [value].pack('Q')
        byte_array.each_byte.each_with_index do |b, offset|
          self[:value][:buffer].put_char(offset, b)
        end
      when Float
        self[:value][:buffer] = FFI::MemoryPointer.new(:double, 1, false)
        self[:value][:buffer].write_double(value)
        self[:value][:type] = :double
      when nil
        self[:value][:is_null].write_int(1)
        self[:value][:buffer] = FFI::MemoryPointer.new(:int, 1, false)
        self[:value][:type] = :val32
      else
        raise "Cannot convert type (#{value.class}). Must be STRING, FIXNUM, BIGNUM, FLOAT, or NIL"
      end

    else
      self[:value][:buffer] = FFI::MemoryPointer.new(:char,
        case self[:value][:type]
        when :string
          self[:value][:buffer_size]
        when :double
          FFI::Type::FLOAT.size # Is this right? it's what the old code does
        when :val64, :uval64
          FFI::Type::LONG_LONG.size
        when :val32, :uval32
          FFI::Type::INT.size
        when :val16, :uval16
          FFI::Type::SHORT.size
        when :val8, :uval8
          FFI::Type::CHAR.size
        else
          raise "Type unknown (#{self[:value][:type]})"
        end
        )
        
    end
    nil
  end

end
