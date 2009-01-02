/* ====================================================
 * 
 *       Copyright 2008-2009 iAnywhere Solutions, Inc.
 * 
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 * 
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * 
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 * 
 *    While not a requirement of the license, if you do modify this file, we
 *    would appreciate hearing about it. Please email
 *    sqlany_interfaces@sybase.com
 * 
 * ====================================================
 */

#ifndef SACAPI_H 
#define SACAPI_H

/** \mainpage SQL Anywhere C API
 *
 * \section intro_sec Introduction
 * The purpose of this API is to simplify creating C/C++ wrapper drivers for various interpreted languages
 * such as PHP, Perl, Python, Ruby, and others. This API layer sits on top of DBLIB and was implemented
 * using Embedded SQL. This API is not a replacement of DBLIB. It is just a way to simplify creating applications
 * from C/C++ code without having to learn all the details of Embedded SQL.
 *
 * \section distribution Distribution of the API
 * The API is built as a DLL (shared object on UNIX). The name of the DLL is \b dbcapi.dll 
 * ( \b libdbcapi.so on UNIX). This DLL is linked statically to DBLIB of the SQL Anywhere version that it was
 * built against. When dbcapi.dll is loaded, the corresponding dblibX.dll is loaded by the OS. Applications that
 * interface with dbcapi.dll can either link directly to it or load it dynamically. For dynamic
 * loading of the DLL, please refer to the Dynamic Loading section below.
 *
 * The file sacapi.h is the main header file for the API. It describes all the data types and the entry
 * points of the API. 
 *
 * \section dynamic_loading Dynamically Loading the DLL
 * The header file sacapidll.h contains the proper code to dynamically load the DLL. An application would 
 * need to include the sacapidll.h header file and compile in sacapidll.c with their source. 
 * sqlany_initialize_interface() can be used to dynamically load the DLL and lookup all the entry points.
 *
 * \section threading_support Threading Support
 * The C API library is thread-unaware, meaning that the library does not perform any tasks that require
 * mutual exclusion. In order to allow the library to work in threaded applications, there is only one rule to
 * follow: <b>no more than one request is allowed on a single connection </b>. With this rule, the application 
 * is responsible for doing mutual exclusion when accessing any connection-specific resource. This includes 
 * connection handles, prepared statements, and result set objects.
 *
 * \version 1.0
 */

/** \file sacapi.h
 * Main API header file.
 * This file describes all the data types and entry points of the API.
 */

/** A define to indicate the current API level
 */
#define SQLANY_CURRENT_API_VERSION	0x1

/** Error buffer size
 */
#define SACAPI_ERROR_SIZE		256

#if defined(__cplusplus)
extern "C" {
#endif

/** A handle to a connection object
 */
typedef struct a_sqlany_connection a_sqlany_connection;

/** A handle to a statement object
 */
typedef struct a_sqlany_stmt	   a_sqlany_stmt;

#ifdef WIN32 
/** A portable 32-bit signed value */
typedef __int32  		sacapi_i32;
/** A portable 32-bit unsigned value */
typedef unsigned __int32 	sacapi_u32;
/** A portable boolean value */
typedef sacapi_i32 		sacapi_bool;
#else
/** A portable 32-bit signed value */
typedef signed int   	sacapi_i32;
/** A portable 32-bit unsigned value */
typedef unsigned int 	sacapi_u32;
/** A portable boolean value */
typedef sacapi_i32 	sacapi_bool;
#endif

// TODO:Character set issues


/** Data type enumeration.
 * This enum is used to specify the data type that is being passed in or retrieved.
 */
typedef enum a_sqlany_data_type
{
    A_INVALID_TYPE, /*!< Invalid data type */
    A_BINARY,       /*!< Binary data : binary data is treated as-is and no character set conversion is performed */
    A_STRING,	    /*!< String data : data where character set conversion is performed */
    A_DOUBLE,	    /*!< Double data : includes float values */
    A_VAL64,	    /*!< 64-bit integer */
    A_UVAL64,	    /*!< 64-bit unsigned integer */
    A_VAL32,	    /*!< 32-bit integer */
    A_UVAL32,	    /*!< 32-bit unsigned integer */
    A_VAL16,	    /*!< 16-bit integer */
    A_UVAL16,	    /*!< 16-bit unsigned integer */
    A_VAL8,	    /*!<  8-bit integer */
    A_UVAL8	    /*!<  8-bit unsigned integer */
} a_sqlany_data_type;

/** A data value structure.
 * This structure describes the attributes of a data value.
 */
typedef struct a_sqlany_data_value
{
    char * 		buffer;		/*!< Pointer to user supplied buffer of data */
    size_t		buffer_size;	/*!< The size of the buffer */
    size_t *		length;		/*!< The number of valid bytes in the buffer. Must be less than buffer_size */
    a_sqlany_data_type	type;		/*!< The type of the data */
    sacapi_bool *	is_null;	/*!< Whether the value is NULL or not */
} a_sqlany_data_value;

/** A data direction enumeration.
 */
typedef enum a_sqlany_data_direction
{
    DD_INVALID       = 0x0,	/*!< Invalid data direction */
    DD_INPUT         = 0x1,	/*!< Input only host variables */
    DD_OUTPUT        = 0x2,	/*!< Output only host variables */
    DD_INPUT_OUTPUT  = 0x3	/*!< Input and Output host variables */
} a_sqlany_data_direction;

/** A bind parameter structure.
 * This structure is used to bind parameters for prepared statements for execution.
 * \sa sqlany_execute()
 */
typedef struct a_sqlany_bind_param
{
    a_sqlany_data_direction	direction; /*!< The direction of the data (input, output, input_output) */
    a_sqlany_data_value		value; 	   /*!< The actual value of the data */
    char			*name;	   /*!< Name of the bind parameter. This is only used by
					     sqlany_describe_bind_param(). */
} a_sqlany_bind_param;

/** An enumeration of the native types of values as described by the server.
 * \sa sqlany_get_column_info(), a_sqlany_column_info
 */
typedef enum a_sqlany_native_type
{
    DT_NOTYPE       	= 0,
    DT_DATE         	= 384,
    DT_TIME         	= 388,
    DT_TIMESTAMP    	= 392,
    DT_VARCHAR      	= 448,
    DT_FIXCHAR      	= 452,
    DT_LONGVARCHAR  	= 456,
    DT_STRING       	= 460,
    DT_DOUBLE       	= 480,
    DT_FLOAT        	= 482,
    DT_DECIMAL      	= 484,
    DT_INT          	= 496,
    DT_SMALLINT     	= 500,
    DT_BINARY       	= 524,
    DT_LONGBINARY   	= 528,
    DT_TINYINT      	= 604,
    DT_BIGINT       	= 608,
    DT_UNSINT       	= 612,
    DT_UNSSMALLINT  	= 616,
    DT_UNSBIGINT    	= 620,
    DT_BIT          	= 624,
    DT_LONGNVARCHAR 	= 640
} a_sqlany_native_type;

/** A column info structure.
 * This structure returns metadata information about a column.
 * sqlany_get_column_info() can be used to populate this structure.
 */
typedef struct a_sqlany_column_info
{
    char *			name;		/*!< The name of the column (null-terminated ).
						  The string can be referenced
						  as long as the result set object is not freed. */
    a_sqlany_data_type		type;		/*!< The type of the column data */
    a_sqlany_native_type	native_type; 	/*!< The native type of the column in the 
						  database */
    unsigned short		precision;	/*!< Precision */
    unsigned short		scale;		/*!< Scale */
    size_t 			max_size; 	/*!< The maximum size a data value in this column 
						  can take */
    sacapi_bool			nullable;	/*!< If a value in the column can be null or not */
} a_sqlany_column_info;

/** A bind parameter info structure.
 * This structure allows the user to get information about the currently bound parameters.
 * sqlany_get_bind_param_info() can be used to populate this structure.
 */
typedef struct a_sqlany_bind_param_info
{
    char *		    	name;		/*!< Name of the parameter */
    a_sqlany_data_direction 	direction;	/*!< Parameter direction */

    a_sqlany_data_value		input_value;	/*!< Information about the bound input value */
    a_sqlany_data_value		output_value;	/*!< Information about the bound output value */
} a_sqlany_bind_param_info;

/** A data info structure.
 * This structure returns metadata information about a column value in a result set.
 * sqlany_get_data_info() can be used
 * to populate this structure with information about what was last retrieved by a fetch operation.
 */
typedef struct a_sqlany_data_info
{
    a_sqlany_data_type	type;	    /*!< Type of the data in the column. */
    sacapi_bool		is_null;    /*!< If the last fetched data is NULL or not.
				      This field is only valid after a successful fetch operation. */
    size_t 		data_size;  /*!< The total number of bytes available to be fetched.
				      This field is only valid after a successful fetch operation. */
} a_sqlany_data_info;

/** Initialize the interface.
 * \param app_name A string that names the API used, for example "PHP", "PERL", or "RUBY".
 * \param api_version The current API version that the application is using. 
 * This should normally be SQLANY_CURRENT_API_VERSION.
 * \param version_available An optional argument to return the maximum API version that is supported. 
 * \return 1 on success, 0 otherwise
 * \sa sqlany_fini()
 * \par Quick Example:
 * \code
   sacapi_u32 api_version;
   if( sqlany_init( "PHP", SQLANY_CURRENT_API_VERSION, &api_version ) ) {
   	printf( "Interface initialized successfully!\n" );
   } else {
   	printf( "Failed to initialize the interface! Supported version=%d\n", api_version );
   }
 * \endcode
 */
sacapi_bool sqlany_init( const char * app_name, sacapi_u32 api_version, sacapi_u32 * version_available );

/** Finalize the interface.
 * Frees any resources allocated by the API.
 * \sa sqlany_init()
*/
void sqlany_fini( void );

/** Creates a connection object.
 * An API connection object needs to be created before a database connection is established. Errors can be retrieved 
 * from the connection object. Only one request can be processed on a connection at a time. In addition,
 * not more than one thread is allowed to access a connection object at a time. If multiple threads attempt
 * to access a connection object simultaneously, then undefined behaviour/crashes will occur.
 * \return A connection object
 * \sa sqlany_connect(), sqlany_disconnect()
*/
a_sqlany_connection * sqlany_new_connection( void );

/** Frees the resources associated with a connection object.
 * \param sqlany_conn A connection object that was created by sqlany_new_connection(). 
 */
void sqlany_free_connection( a_sqlany_connection *sqlany_conn );

/** Creates a connection object based on a supplied DBLIB SQLCA pointer.
 * \param arg A void * pointer to a DBLIB SQLCA object. 
 * \return A connection object.
 * \sa sqlany_execute(), sqlany_execute_direct(), sqlany_execute_immediate(), sqlany_prepare()
 */
a_sqlany_connection * sqlany_make_connection( void * arg );

/** Establish a connection.
 * This function establishes a connection to a SQL Anywhere server using the supplied connection object and
 * the supplied connection string. The connection object must first be allocated using sqlany_new_connection().
 * \param sqlany_conn A connection object that was created by sqlany_new_connection().
 * \param str A SQL Anywhere connection string.
 * \return 1 if the connection was established successfully, or 0 otherwise. The error code and message can be 
 * retrieved using sqlany_error().
 * \sa sqlany_new_connection(), sqlany_error()
 * \par Quick Example:
 * \code
   a_sqlany_connection * sqlany_conn;
   sqlany_conn = sqlany_new_connection();
   if( !sqlany_connect( sqlany_conn, "uid=dba;pwd=sql" ) ) {
   	char 	       reason[SACAPI_ERROR_SIZE];
	sacapi_i32     code;
	code = sqlany_error( sqlany_conn, reason, sizeof(reason) );
   	printf( "Connection failed. Code: %d Reason: %s\n", code, reason );
   } else {
   	printf( "Connected successfully!\n" );
	sqlany_disconnect( sqlany_conn );
   }
   sqlany_free_connection( sqlany_conn );
 * \endcode
 */
sacapi_bool sqlany_connect( a_sqlany_connection * sqlany_conn, const char * str );

/** Disconnect an already established connection.
 * This function disconnects a SQL Anywhere connection.
 * Any uncommited transactions will be rolled back.
 * \param sqlany_conn A connection object with a connection established using sqlany_connect().
 * \return 1 on success; 0 otherwise
 * \sa sqlany_connect()
 */
sacapi_bool sqlany_disconnect( a_sqlany_connection * sqlany_conn );

/** Execute a SQL statement immediately without returning a result set.
 * Execute the specified SQL statement immediately.
 * This function is useful for SQL statements that do not return a result set. 
 * \param sqlany_conn A connection object with a connection established using sqlany_connect().
 * \param sql A string respresenting the SQL statement to be executed.
 * \return 1 on success, 0 otherwise
 */
sacapi_bool sqlany_execute_immediate( a_sqlany_connection * sqlany_conn, const char * sql );

/** Prepare a SQL statement.
 * This function prepares the supplied SQL string. Execution does not happen until sqlany_execute() is 
 * called. The returned statement object should be freed using sqlany_free_stmt().
 * \param sqlany_conn A connection object with a connection established using sqlany_connect().
 * \param sql_str The SQL statement to be prepared.
 * \return A handle to a SQL Anywhere statement object. The statement object can be used by sqlany_execute()
 * to execute the statement.
 * \sa sqlany_free_stmt(), sqlany_connect(), sqlany_execute()
 * \par Quick Example:
 * \code
   char * str;
   a_sqlany_stmt * stmt;

   str = "select * from employees where salary >= ?";
   stmt = sqlany_prepare( sqlany_conn, str );
   if( stmt == NULL ) {
   	// Failed to prepare statement, call sqlany_error() for more info
   }
 * \endcode
 */
a_sqlany_stmt * sqlany_prepare( a_sqlany_connection * sqlany_conn, const char * sql_str );

/** Frees resources associated with a prepared statement object.
 * This function frees the resources associated with a prepared statement object.
 * \param sqlany_stmt A statement object that was returned from sqlany_prepare().
 * \sa sqlany_prepare()
 */
void sqlany_free_stmt( a_sqlany_stmt * sqlany_stmt );

/** Returns the number of parameters that are expected for a prepared statement.
 * \param sqlany_stmt A statement object that was returned from sqlany_prepare().
 * \return The number of parameters that are expected. -1 if the sqlany_stmt object is not valid.
 */
sacapi_i32 sqlany_num_params( a_sqlany_stmt * sqlany_stmt );

/** Describes the bind parameters of a prepared statement.
 * This function allows the caller to determine information about parameters to a prepared statement. Depending
 * on the type of the prepared statement (call to stored procedured or a DML), only some information will be provided.
 * The information that will always be provided is the direction of the parameters (input, output, or input-output).
 * \param sqlany_stmt A statement that was prepared successfully using sqlany_prepare().
 * \param index The index of the parameter. This should be a number between 0 and sqlany_num_params()-1;
 * \param param A a_sqlany_bind_param structure that will be populated with information.
 * \return 1 on success or 0 on failure.
 */
sacapi_bool sqlany_describe_bind_param( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, a_sqlany_bind_param * param );

/** Bind a user supplied buffer as a parameter to the prepared statement.
 * \param sqlany_stmt A statement that was prepared successfully using sqlany_prepare().
 * \param index The index of the parameter. This should be a number between 0 and sqlany_num_params()-1.
 * \param param A a_sqlany_bind_param structure that describes the parameter that is to be bound.
 * \return 1 on success or 0 on failure.
 */
sacapi_bool sqlany_bind_param( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, a_sqlany_bind_param * param );

/** Send data as part of a bound parameter.
 * This function can be used to send a large amount of data for a bound parameter.
 * \param sqlany_stmt A statement that was prepared successfully using sqlany_prepare().
 * \param index The index of the parameter. This should be a number between 0 and sqlany_num_params()-1.
 * \param buffer The data to be sent.
 * \param size The number of bytes to send.
 * \return 1 on success or 0 on failure.
 * \sa sa_prepare()
 */
sacapi_bool sqlany_send_param_data( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, char * buffer, size_t size );

/** Reset a statement to its prepared state condition.
 * \param sqlany_stmt A statement that was prepared successfully using sqlany_prepare().
 * \return 1 on success, 0 on failure.
 * \sa sqlany_prepare()
 */
sacapi_bool sqlany_reset( a_sqlany_stmt * sqlany_stmt );

/** Get bound parameter info.
 * This function retrieves information about the parameters that were bound using sqlany_bind_param().
 * \param sqlany_stmt A statement that was prepared successfully using sqlany_prepare().
 * \param index The index of the parameter. This should be a number between 0 and sqlany_num_params()-1.
 * \param info A sqlany_bind_param_info buffer that will be populated with the bound parameter's information.
 * \return 1 on success or 0 on failure.
 * \sa sqlany_bind_param(), sqlany_describe_bind_param(), sqlany_prepare()
 */
sacapi_bool sqlany_get_bind_param_info( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, a_sqlany_bind_param_info * info );

/** Execute a prepared statement.
 * This function executes a prepared statement.
 * The user can check if the statement returns a result set or not
 * by checking the result of sqlany_num_cols().
 * \param sqlany_stmt A statement that was prepared successfully using sqlany_prepare().
 * \return 1 if the statement is executed successfully, 0 otherwise. 
 * \sa sqlany_prepare()
 * \par Quick Example:
 * \code
   // This example shows how to execute a statement that does not return a result set
   a_sqlany_stmt * 	 stmt;
   int		     	 i;
   a_sqlany_bind_param   param;

   stmt = sqlany_prepare( sqlany_conn, "insert into moe(id,value) values( ?,? )" );
   if( stmt ) {
       sqlany_describe_bind_param( stmt, 0, &param );
       param.value.buffer = (char *)&i;
       param.value.type   = A_VAL32;
       sqlany_bind_param( stmt, 0, &param );

       sqlany_describe_bind_param( stmt, 1, &param );
       param.value.buffer = (char *)&i;
       param.value.type   = A_VAL32;
       sqlany_bind_param( stmt, 1, &param );

       for( i = 0; i < 10; i++ ) {
           if( !sqlany_execute( stmt ) ) {	
	   	// call sqlany_error()
	   }
       }
       sqlany_free_stmt( stmt );
   }
 * \endcode
 */
sacapi_bool sqlany_execute( a_sqlany_stmt * sqlany_stmt );

/** Executes a SQL statement and possibly returns a result set.
 * This function executes the SQL statement specified by the string argument.
 * This function is suitable if you want to prepare and then execute a statement,
 * and can be used instead of calling sqlany_prepare() followed by sqlany_execute().
 * This function can \b not be used for executing a SQL statement with parameters.
 * \param sqlany_conn A connection object with a connection established using sqlany_connect().
 * \param sql_str A SQL string. The SQL string should not have parameters (i.e. '?' marks ).
 * \return A statement handle if the function executes successfully, NULL otherwise.
 * \sa sqlany_fetch_absolute(), sqlany_fetch_next(), sqlany_num_cols(), sqlany_get_column()
 * \par Quick Example:
 * \code
   stmt = sqlany_execute_direct( sqlany_conn, "select * from employees" ) ) {
   if( stmt ) {
       while( sqlany_fetch_next( stmt ) ) {
           int i;
	   for( i = 0; i < sqlany_num_cols( stmt ); i++ ) {
		// Get column i data 
	   }
       }
       sqlany_free_stmt( stmt  );
   }
 * \endcode
 */
a_sqlany_stmt * sqlany_execute_direct( a_sqlany_connection * sqlany_conn, const char * sql_str );

/** Fetch data at a specific row number in the result set.
 * This function moves the current row in the result set to the row number specified and fetches the data at that row.
 * \param sqlany_stmt A statement object that was executed by
 *     sqlany_execute() or sqlany_execute_direct().
 * \param row_num The row number to be fetched. The first row is 1, the last row is -1.
 * \return 1 if the fetch was successfully, 0 otherwise.
 * \sa sqlany_execute_direct(), sqlany_execute(), sqlany_error(), sqlany_fetch_next()
 */
sacapi_bool sqlany_fetch_absolute( a_sqlany_stmt * sqlany_stmt, sacapi_i32 row_num );

/** Fetch the next row from the result set.
 * This function fetches the next row from the result set.
 * When the result object is first created, the current row 
 * pointer is set to before the first row (i.e. row 0).
 * This function first advances the row pointer and then fetches
 * the data at the new row.
 * \param sqlany_stmt A statement object that was executed by
 *     sqlany_execute() or sqlany_execute_direct().
 * \return 1 if a row was fetched successfully, 0 otherwise. 
 * \sa sqlany_fetch_absolute(), sqlany_execute_direct(), sqlany_execute(), sqlany_error()
 */
sacapi_bool sqlany_fetch_next( a_sqlany_stmt * sqlany_stmt );

/** Advance to the next result set in a multiple result set query.
 * If a query (such as a call to a stored procedure) returns multiple result sets, then this function
 * advances from the current result set to the next.
 * \param sqlany_stmt A statement object that was executed by
 *     sqlany_execute() or sqlany_execute_direct().
 * \return 1 if was successfully able to advance to the next result set, 0 otherwise.
 * \sa sqlany_execute_direct(), sqlany_execute()
 * \par Quick Example:
 * \code
   stmt = sqlany_execute_direct( sqlany_conn, "call my_multiple_results_procedure()" );
   if( result ) {
       do {
           while( sqlany_fetch_next( stmt ) ) {
	       // get column data    
	   }
       } while( sqlany_get_next_result( stmt ) );
       sqlany_free_stmt( stmt );
   }
 * \endcode
 */
sacapi_bool sqlany_get_next_result( a_sqlany_stmt * sqlany_stmt );

/** Returns the number of rows affected by execution of the prepared statement.
 * \param sqlany_stmt A statement that was prepared and executed successfully with no result set returned.
 * \return The number of rows affected or -1 on failure.
 * \sa sqlany_execute(), sqlany_execute_direct()
 */
sacapi_i32 sqlany_affected_rows( a_sqlany_stmt * sqlany_stmt );

/** Returns number of columns in the result set.
 * \param sqlany_stmt A statement object that was created by sqlany_prepare() or sqlany_execute_direct().
 * \return The number of columns in the result set or -1 on a failure.
 * \sa sqlany_execute_direct(), sqlany_prepare()
 */
sacapi_i32 sqlany_num_cols( a_sqlany_stmt * sqlany_stmt );

/** Returns number of rows in the result set.
 * By default this function only returns an estimate. To return an exact count, users must set the ROW_COUNTS option
 * on the connection. Refer to SQL Anywhere documentation for the SQL syntax to set this option.
 * \param sqlany_stmt A statement object that was executed by
 *     sqlany_execute() or sqlany_execute_direct().
 * \return The number rows in the result set. If the number of rows is an estimate, the number returned will be 
 * negative and the estimate is the absolute value of the returned integer. If the number of rows is exact, then the 
 * value returned will be positive.
 * \sa sqlany_execute_direct(), sqlany_execute()
 */
sacapi_i32 sqlany_num_rows( a_sqlany_stmt * sqlany_stmt );

/** Retrieve the data fetched for the specified column.
 * This function fills the supplied buffer with the value fetched for the
 * specified column. For A_BINARY and A_STRING * data types,
 * buffer->buffer will point to an internal buffer associated with the result set.
 * The content of the pointer buffer should not be relied on or altered
 * as it will change when a new row is fetched or when the result set
 * object is freed. Users should copy the data out of those pointers into their
 * own buffers. The length field indicates the number of valid characters that
 * buffer->buffer points to. The data returned in buffer->buffer is \b not
 * null-terminated. This function fetches all of the returned value from the server.
 * For example, if the column contains
 * a 2GB blob, this function will attempt to allocate enough memory to hold that value.
 * If this is not desired, sqlany_get_data() should be used instead.
 * \param sqlany_stmt A statement object that was executed by
 *     sqlany_execute() or sqlany_execute_direct().
 * \param col_index The number of the column to be retrieved.
 *	A column number is between 0 and sqlany_num_cols()-1.
 * \param buffer A a_sqlany_data_value object that will be filled with the data fetched for column col_index.
 * \return 1 on success or 0 for failure. A failure can happen if any of the parameters is invalid or if there is 
 * not enough memory to retrieve the full value from the server.
 * \sa sqlany_execute_direct(), sqlany_execute()
 */
sacapi_bool sqlany_get_column( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, a_sqlany_data_value * buffer );

/** Retrieve the data fetched for the specified column into the supplied buffer memory.
 * \param sqlany_stmt A statement object that was executed by
 *     sqlany_execute() or sqlany_execute_direct().
 * \param col_index The number of the column to be retrieved.
 *	A column number is between 0 and sqlany_num_cols()-1.
 * \param offset The starting offset of the data to get.
 * \param buffer A buffer to be filled with the contents of the column. The buffer pointer must be aligned correctly
 * for the data type that will be copied into it.
 * \param size The size of the buffer in bytes. The function will fail
 * if a size greater than 2GB is specified. 
 * \return The number of bytes successfully copied into the supplied buffer.
 * This number will not exceed 2GB. 
 * 0 indicates no data remains to be copied. A -1 indicates a failure.
 */
sacapi_i32 sqlany_get_data( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, size_t offset, void * buffer, size_t size );

/** Retrieves information about the data that was fetched by the last fetch operation.
 * \param sqlany_stmt A statement object that was executed by
 *     sqlany_execute() or sqlany_execute_direct().
 * \param col_index The column number.
 *	A column number is between 0 and sqlany_num_cols()-1.
 * \param buffer A data info buffer to be filled with the metadata about the data fetched.
 * \return 1 on success, and 0 on failure. Failure is returned if any of the supplied parameters is invalid.
 */
sacapi_bool sqlany_get_data_info( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, a_sqlany_data_info * buffer );

/** Retrieves column metadata information.
 * This function fills the a_sqlany_column_info structure with information about the column. 
 * \param sqlany_stmt A statement object that was created by sqlany_prepare() or sqlany_execute_direct().
 * \param col_index The column number.
 *	A column number is between 0 and sqlany_num_cols()-1.
 * \param buffer A column info structure to be filled with information about the column.
 * \return 1 on success. Returns 0 if the column index is out of range,
 * or if the statement does not return a result set.
 * \sa sqlany_execute_direct(), sqlany_prepare()
 */
sacapi_bool sqlany_get_column_info( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, a_sqlany_column_info * buffer );

/** Commit the current transaction.
 * \param sqlany_conn The connection object on which the commit operation is to be performed.
 * \return 1 on success, 0 otherwise.
 * \sa sqlany_rollback()
 */
sacapi_bool sqlany_commit( a_sqlany_connection * sqlany_conn );

/** Rollback the current transaction.
 * \param sqlany_conn The connection object on which the rollback operation is to be performed.
 * \return 1 on success, 0 otherwise.
 * \sa sqlany_commit()
 */
sacapi_bool sqlany_rollback( a_sqlany_connection * sqlany_conn );

/** Returns the current client version.
 * This function fills the buffer passed with the major, minor, patch, and build number of the client library. 
 * The buffer will be null-terminated.
 * \param buffer The buffer to be filled with the client version.
 * \param len The length of the buffer.
 * \return 1 on success; 0 otherwise
 */
sacapi_bool sqlany_client_version( char * buffer, size_t len );

/** Retrieves the last error code and message.
 * This function can be used to retrieve the last error code and message stored in the connection object.
 * \param sqlany_conn A connection object that was returned from sqlany_new_connection().
 * \param buffer A buffer that will be filled with the error message.
 * \param size Size of the supplied buffer.
 * \return The last error code. Positive values are warnings, negative values are errors, and 0 is success.
 */
sacapi_i32 sqlany_error( a_sqlany_connection * sqlany_conn, char * buffer, size_t size );

/** Retrieve the current SQL state.
 * \param sqlany_conn A connection object that was returned from sqlany_new_connection().
 * \param buffer A buffer that will be filled with the SQL state.
 * \param size The size of the buffer.
 * \return The number of bytes copied into the buffer.
 */
size_t sqlany_sqlstate( a_sqlany_connection * sqlany_conn, char * buffer, size_t size );

/** Clears the last stored error code
 * \param sqlany_conn A connection object that was returned from sqlany_new_connection().
 */
void sqlany_clear_error( a_sqlany_connection * sqlany_conn );

#if defined(__cplusplus)
}
#endif

/** \example connecting.cpp
 * This is an example of how to create a connection object and connect with it to SQL Anywhere.
 */

/** \example fetching_a_result_set.cpp
 * This example shows how to fetch data from a result set.
 */

/** \example preparing_statements.cpp
 * This example shows how to prepare and execute a statement.
 */

/** \example fetching_multiple_from_sp.cpp
 * This example shows how to fetch multiple result sets from a stored procedure.
 */

/** \example send_retrieve_part_blob.cpp
 * This example shows how to insert a blob in chunks and retrieve it in chunks too.
 */

/** \example send_retrieve_full_blob.cpp
 * This example shows how to insert and retrieve a blob in one chunk .
 */

/** \example dbcapi_isql.cpp
 * This example shows how to write an ISQL application using dbcapi.
 */

#endif 
