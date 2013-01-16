#====================================================
#
#    Copyright 2012 iAnywhere Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#                                                                               
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.
#
# While not a requirement of the license, if you do modify this file, we
# would appreciate hearing about it.   Please email sqlany_interfaces@sybase.com
#
#
#====================================================
#
# This sample program contains a hard-coded userid and password
# to connect to the demo database. This is done to simplify the
# sample program. The use of hard-coded passwords is strongly
# discouraged in production code.  A best practice for production
# code would be to prompt the user for the userid and password.
#
#====================================================

require 'test/unit'
require 'date'

begin
  #require 'rubygems'
  #unless defined? SQLAnywhere
  #  require 'sqlanywhere'
  #end
  
  
  require 'sqlanywhere.rb'

end

class Types
    A_INVALID_TYPE= 0
    A_BINARY      = 1
    A_STRING      = 2
    A_DOUBLE      = 3
    A_VAL64       = 4
    A_UVAL64      = 5
    A_VAL32       = 6
    A_UVAL32      = 7
    A_VAL16       = 8
    A_UVAL16      = 9
    A_VAL8        = 10
    A_UVAL8       = 11
end

class Direction
    DD_INVALID       = 0
    DD_INPUT         = 1
    DD_OUTPUT        = 2
    DD_INPUT_OUTPUT  = 3
end

class SQLAnywhere_Test < Test::Unit::TestCase
  def setup
    @api = SQLAnywhere::SQLAnywhereInterface.new()
    assert_not_nil @api
    assert_nothing_raised do
      SQLAnywhere::API.sqlany_initialize_interface( @api )
    end
    assert_nothing_raised do
      @api.sqlany_init()
    end
    @conn = @api.sqlany_new_connection()
    assert_not_nil @conn
    conn_str = "eng=test;uid=dba;pwd=sql"
    assert_succeeded @api.sqlany_connect(@conn, conn_str)
  end

  def teardown
    assert_succeeded @api.sqlany_execute_immediate(@conn, 'SELECT * FROM dummy')
    assert_nil @api.sqlany_disconnect(@conn)
    assert_failed @api.sqlany_execute_immediate(@conn, 'SELECT * FROM dummy')
    assert_nil @api.sqlany_free_connection(@conn)
    assert_nothing_raised do
      @api.sqlany_fini()
    end
    assert_nothing_raised do
      SQLAnywhere::API.sqlany_finalize_interface( @api )
    end
  end

  def test_execute_immediate
    assert_succeeded @api.sqlany_execute_immediate(@conn, 'SELECT * FROM dummy')
  end

  def test_errors
    sql = "INSERT INTO test(\"id\") VALUES('test');"
    assert_failed @api.sqlany_execute_immediate(@conn, sql)
    code, msg = @api.sqlany_error(@conn)
    assert_equal -157, code
    assert_not_equal "", msg
    assert_equal "53018\000", @api.sqlany_sqlstate(@conn)
    assert_nil @api.sqlany_clear_error(@conn)
    code, msg = @api.sqlany_error(@conn)
    assert_equal 0, code
    assert_equal "", msg
  end

  def test_rollback
    id = setup_transaction
    @api.sqlany_rollback(@conn)
    sql = "SELECT * FROM test where \"id\" = "  + id.to_s + ";"
    rs = exec_direct_with_test(sql)
    assert_failed @api.sqlany_fetch_next(rs)
  end

  def test_commit
    id = setup_transaction
    @api.sqlany_commit(@conn)
    sql = "SELECT * FROM test where \"id\" = "  + id.to_s + ";"
    rs = exec_direct_with_test(sql)
    assert_succeeded @api.sqlany_fetch_next(rs)
    res, ret_id = @api.sqlany_get_column(rs, 0)
    assert_succeeded res
    assert_not_nil ret_id
    assert_equal id, ret_id    
    assert_failed @api.sqlany_fetch_next(rs)
  end

  def test_column_info
    is_iq = is_iq_table?("types")
	rs = exec_direct_with_test("SELECT TOP 2 * FROM \"types\" ORDER BY \"id\"")
    assert_equal 22, @api.sqlany_num_cols(rs)
    assert_column_info(rs, 0, "id", Types::A_VAL32, 4)
    assert_column_info(rs, 1, "_binary_", Types::A_BINARY, 8)
    assert_column_info(rs, 2, "_numeric_", Types::A_STRING, 2)
    assert_column_info(rs, 3, "_decimal_", Types::A_STRING, 2)
    assert_column_info(rs, 4, "_bounded_string_", Types::A_STRING, 255)
    assert_column_info(rs, 5, "_unbounded_string_", Types::A_STRING, (2 * (2**30)) - 1)
    assert_column_info(rs, 6, "_signed_bigint_", Types::A_VAL64, 8)
    assert_column_info(rs, 7, "_unsigned_bigint_", Types::A_UVAL64, 8)
    assert_column_info(rs, 8, "_signed_int_", Types::A_VAL32, 4)
    assert_column_info(rs, 9, "_unsigned_int_", Types::A_UVAL32, 4)
    assert_column_info(rs, 10, "_signed_smallint_", Types::A_VAL16, 2)
    assert_column_info(rs, 11, "_unsigned_smallint_", Types::A_UVAL16, 2) unless is_iq #IQ Does not have an unsigned small int datatype
    assert_column_info(rs, 12, "_signed_tinyint_", Types::A_UVAL8, 1)
    assert_column_info(rs, 13, "_unsigned_tinyint_", Types::A_UVAL8, 1)
    assert_column_info(rs, 14, "_bit_", Types::A_VAL8, 1)
    assert_column_info(rs, 15, "_date_", Types::A_STRING, 10)
    assert_column_info(rs, 16, "_datetime_", Types::A_STRING, 23)
    assert_column_info(rs, 17, "_smalldatetime_", Types::A_STRING, 23)
    assert_column_info(rs, 18, "_timestamp_", Types::A_STRING, 23)
    assert_column_info(rs, 19, "_double_", Types::A_DOUBLE, 8)
    assert_column_info(rs, 20, "_float_", Types::A_DOUBLE, 4)
    assert_column_info(rs, 21, "_real_", Types::A_DOUBLE, 4)
    assert_nil @api.sqlany_free_stmt(rs)
  end

  def test_bounds_on_types
    is_iq = is_iq_table?("types")
	rs = exec_direct_with_test("SELECT TOP 2 * FROM \"types\" ORDER BY \"id\"")    
    assert_succeeded @api.sqlany_fetch_next(rs)
    assert_class_and_value(rs, String, 1, "x") 
    assert_class_and_value(rs, String, 2, "1.1")
    assert_class_and_value(rs, String, 3, "1.1")     
    assert_class_and_value(rs, String, 4, 'Bounded String Test') 
    assert_class_and_value(rs, String, 5, 'Unbounded String Test')
    assert_class_and_value(rs, Bignum, 6, 9223372036854775807)
    assert_class_and_value(rs, Bignum, 7, 18446744073709551615)
    assert_class_and_value(rs, Bignum, 8, 2147483647)
    assert_class_and_value(rs, Bignum, 9, 4294967295)
    assert_class_and_value(rs, Fixnum, 10, 32767)
    assert_class_and_value(rs, Fixnum, 11, 65535) unless is_iq #IQ Does not have an unsigned small int datatype
    assert_class_and_value(rs, Fixnum, 12, 255)    
    assert_class_and_value(rs, Fixnum, 13, 255)
    assert_class_and_value(rs, Fixnum, 14, 1)
    assert_date_and_time(rs, Date, 15, Date.new(1999, 1, 2))
    assert_date_and_time(rs, DateTime, 16, DateTime.new(1999, 1, 2, 21, 20, 53))
    assert_date_and_time(rs, DateTime, 17, DateTime.new(1999, 1, 2, 21, 20, 53))
    assert_date_and_time(rs, DateTime, 18, DateTime.new(1999, 1, 2, 21, 20, 53))
    assert_class_and_float_value(rs, Float, 19, 1.79769313486231e+308, 1e+293  ) 
    assert_class_and_float_value(rs, Float, 20, 3.402823e+38, 1e+32 ) 
    assert_class_and_float_value(rs, Float, 21, 3.402823e+38, 1e+32 ) 

    assert_succeeded @api.sqlany_fetch_next(rs)
    assert_class_and_value(rs, String, 1, 255.chr)
    assert_class_and_value(rs, String, 2, "-1.1")
    assert_class_and_value(rs, String, 3, "-1.1")      
    assert_class_and_value(rs, String, 4, '') 
    assert_class_and_value(rs, String, 5, '')
    assert_class_and_value(rs, Bignum, 6, -9223372036854775808)
    assert_class_and_value(rs, Fixnum, 7, 0)
    assert_class_and_value(rs, Bignum, 8, -2147483648)
    assert_class_and_value(rs, Fixnum, 9, 0)    
    assert_class_and_value(rs, Fixnum, 10, -32768)    
    assert_class_and_value(rs, Fixnum, 11, 0) unless is_iq   #IQ Does not have an unsigned small int datatype
    assert_class_and_value(rs, Fixnum, 12, 0)    
    assert_class_and_value(rs, Fixnum, 13, 0)
    assert_class_and_value(rs, Fixnum, 14, 0)
    assert_class_and_value(rs, NilClass, 15, nil)
    assert_class_and_value(rs, NilClass, 16, nil)
    assert_class_and_value(rs, NilClass, 17, nil)
    assert_class_and_value(rs, NilClass, 18, nil)
    assert_class_and_float_value(rs, Float, 19, -1.79769313486231e+308, 1e+293 ) 
    assert_class_and_float_value(rs, Float, 20, -3.402823e+38, 1e+32 ) 
    assert_class_and_float_value(rs, Float, 21, -3.402823e+38, 1e+32 )     
    assert_nil @api.sqlany_free_stmt(rs) 
  end

  def test_prepared_stmt
    is_iq = is_iq_table?("types")
	stmt = @api.sqlany_prepare(@conn, "SELECT * FROM \"types\" WHERE \"id\" = ?")
    assert_not_nil stmt
    assert_failed @api.sqlany_execute(stmt) unless is_iq #IQ does not throw an error here
    assert_equal 1, @api.sqlany_num_params(stmt)
    res, param = @api.sqlany_describe_bind_param(stmt, 0)
    assert_not_equal 0, res
    assert_equal "?", param.get_name()
    assert_equal Direction::DD_INPUT, param.get_direction()

    assert_nil param.set_value(0);
    @api.sqlany_bind_param(stmt, 0, param)
    assert_succeeded @api.sqlany_execute(stmt)
    assert_succeeded @api.sqlany_fetch_next(stmt)
    assert_class_and_value(stmt, String, 4, "Bounded String Test")     

    assert_nil param.set_value(1);
    @api.sqlany_bind_param(stmt, 0, param)
    assert_succeeded @api.sqlany_execute(stmt)
    assert_succeeded @api.sqlany_fetch_next(stmt)
    assert_class_and_value(stmt, String, 4, "")     

    assert_nil @api.sqlany_free_stmt(stmt) 
  end

  def test_insert_binary
    assert_insert("_binary_", "x", String)
  end

  def test_insert_numeric
    assert_insert("_numeric_", "1.1", String)
  end

  def test_insert_decimal
    assert_insert("_decimal_", "1.1", String)
  end

  def test_insert_bounded_string
    assert_insert("_bounded_string_", "Bounded String Test", String)
  end

  def test_insert_unbounded_string
    assert_insert("_unbounded_string_", "Unbounded String Test", String)
  end

  def test_insert_int64
    assert_insert("_signed_bigint_", 9223372036854775807, Bignum)
    assert_insert("_signed_bigint_", -9223372036854775808, Bignum)
  end  

  def test_insert_uint64
    assert_insert("_unsigned_bigint_", 9223372036854775807, Bignum)
    assert_insert("_unsigned_bigint_", 0, Fixnum)
  end

  def test_insert_int32
    assert_insert("_signed_int_", 2147483647, Bignum)
    assert_insert("_signed_int_", -2147483648, Bignum)
  end  

  def test_insert_uint32
    assert_insert("_unsigned_int_", 4294967295, Bignum)
    assert_insert("_unsigned_int_", 0, Fixnum)
  end

  def test_insert_int16
    assert_insert("_signed_smallint_", 32767, Fixnum)
    assert_insert("_signed_smallint_", -32768, Fixnum)
  end  

  def test_insert_uint16
    is_iq = is_iq_table?("types") #IQ Does not have an unsigned small int datatype
	assert_insert("_unsigned_smallint_", 65535, Fixnum) unless is_iq
    assert_insert("_unsigned_smallint_", 0, Fixnum) unless is_iq
  end

  def test_insert_int8
    assert_insert("_signed_smallint_", 255, Fixnum)
    assert_insert("_signed_smallint_", 0, Fixnum)
  end  

  def test_insert_uint8
    is_iq = is_iq_table?("types") #IQ Does not have an unsigned small int datatype
	assert_insert("_unsigned_smallint_", 255, Fixnum) unless is_iq
    assert_insert("_unsigned_smallint_", 0, Fixnum) unless is_iq
  end

  def test_insert_date
    assert_insert("_date_", Date.new(1999, 1, 2), Date)
  end

  def test_insert_datetime
    assert_insert("_datetime_", DateTime.new(1999, 1, 2, 21, 20, 53), DateTime)
  end 

  def test_insert_smalldate
    assert_insert("_smalldatetime_", DateTime.new(1999, 1, 2, 21, 20, 53), DateTime)
  end 

  def test_insert_timestamp
    assert_insert("_timestamp_", DateTime.new(1999, 1, 2, 21, 20, 53), DateTime)
  end

  def test_insert_double
    assert_insert("_double_", 1.79769313486231e+308, Float, 1e+293)
  end    

  def test_insert_float
    assert_insert("_float_", 3.402823e+38, Float, 1e+32)
  end

  def test_insert_real
    assert_insert("_real_", 3.402823e+38, Float, 1e+32)
  end  

  def is_iq_table?(table_name)
	rs = @api.sqlany_execute_direct(@conn, "SELECT server_type FROM SYS.SYSTABLE WHERE table_name = '#{table_name}'")
	@api.sqlany_fetch_next(rs)
	return @api.sqlany_get_column(rs, 0)[1] == 'IQ'
  end

  def assert_insert(column_name, value, type, delta = nil)
    stmt = @api.sqlany_prepare(@conn, 'INSERT INTO "types"("id", "' + column_name + '", "_bit_") VALUES(3, ?, 1)')
    assert_not_nil stmt
    res, param = @api.sqlany_describe_bind_param(stmt, 0)
    if type == Date or type == DateTime then
      assert_nil param.set_value(value.strftime("%F %T"));
    else
      assert_nil param.set_value(value);
    end
    @api.sqlany_bind_param(stmt, 0, param)
    assert_succeeded @api.sqlany_execute(stmt)
    assert_nil @api.sqlany_free_stmt(stmt)
    
    rs = exec_direct_with_test('SELECT "' + column_name + '" FROM "types" WHERE "id" = 3')
    assert_succeeded @api.sqlany_fetch_next(rs)
    if type == Date or type == DateTime then    
      assert_date_and_time(rs, type, 0, value)
    elsif type == Float
      assert_class_and_float_value(rs, type, 0, value, delta)
    else
      assert_class_and_value(rs, type, 0, value)
    end
    
    assert_nil @api.sqlany_free_stmt(rs)   

    @api.sqlany_rollback(@conn)
  end    

  def assert_column_info(rs, pos, expected_col_name, expected_col_type, expected_col_size)
    res, col_num, col_name, col_type, col_native_type, col_precision, col_scale, col_size, col_nullable = @api.sqlany_get_column_info(rs, pos);
    assert_succeeded res
    assert_equal expected_col_name, col_name 
    assert_equal SQLAnywhere::DataType[expected_col_type], col_type
    assert_equal expected_col_size, col_size
  end

  def assert_class_and_float_value(rs, cl, pos, expected_value, allowed_delta)
    res, val = @api.sqlany_get_column(rs, pos)
    assert_succeeded res
    assert_not_nil val unless expected_value.nil?
    assert_in_delta expected_value, val, allowed_delta
    assert_instance_of cl, val
  end

  def assert_date_and_time(rs, cl, pos, expected_value)
    res, val = @api.sqlany_get_column(rs, pos)
    assert_succeeded res
    assert_not_nil val unless expected_value.nil?
    parsed = cl.parse(val)
    assert_equal expected_value, parsed
    assert_instance_of cl, parsed
  end

  def assert_class_and_value(rs, cl, pos, expected_value)
    res, val = @api.sqlany_get_column(rs, pos)
    assert_succeeded res
    assert_not_nil val unless expected_value.nil?
    assert_equal expected_value, val
    assert_instance_of cl, val unless RUBY_PLATFORM == 'java' and cl == Bignum and Fixnum === val
  end

  def setup_transaction
    sql = "INSERT INTO test VALUES( DEFAULT );"
    assert_succeeded @api.sqlany_execute_immediate(@conn, sql)

    rs = exec_direct_with_test("SELECT @@identity")
    assert_succeeded @api.sqlany_fetch_next(rs)
    res, id = @api.sqlany_get_column(rs, 0)
    assert_succeeded res
    assert_not_nil id

    sql = "SELECT * FROM test where \"id\" = "  + id.to_s + ";"
    rs = @api.sqlany_execute_direct(@conn, sql)
    assert_not_nil rs
    
    assert_succeeded @api.sqlany_fetch_next(rs)
    assert_failed @api.sqlany_fetch_next(rs)
    assert_nil @api.sqlany_free_stmt(rs)
    id
  end

  def exec_direct_with_test(sql)
    rs = @api.sqlany_execute_direct(@conn, sql)
    code, msg =  @api.sqlany_error(@conn)
    assert_not_nil rs,  "SQL Code: #{code}; Message: #{msg}"
    rs
  end

  def assert_succeeded(val)
    assert_not_equal 0, val, @api.sqlany_error(@conn)
  end

  def assert_failed(val)
    assert_equal 0, val, @api.sqlany_error(@conn)
  end

end

