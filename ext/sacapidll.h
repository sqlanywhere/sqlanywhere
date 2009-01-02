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

#ifndef SACAPIDLL_H
#define SACAPIDLL_H

#include "sacapi.h"

/** \file sacapidll.h
 * \brief Header file for stub that can dynamically load the main API DLL.
 * The user will need to include sacapidll.h in their source files and compile in sacapidll.c
 */


#if defined( __cplusplus )
extern "C" {
#endif
typedef sacapi_bool (*sqlany_init_func)( const char * app_name, sacapi_u32 api_version, sacapi_u32 * max_version );
typedef void (*sqlany_fini_func)();
typedef a_sqlany_connection * (*sqlany_new_connection_func)( );
typedef void (*sqlany_free_connection_func)( a_sqlany_connection *sqlany_conn );
typedef a_sqlany_connection * (*sqlany_make_connection_func)( void * arg );
typedef sacapi_bool (*sqlany_connect_func)( a_sqlany_connection * sqlany_conn, const char * str );
typedef sacapi_bool (*sqlany_disconnect_func)( a_sqlany_connection * sqlany_conn );
typedef sacapi_bool (*sqlany_execute_immediate_func)( a_sqlany_connection * sqlany_conn, const char * sql );
typedef a_sqlany_stmt * (*sqlany_prepare_func)( a_sqlany_connection * sqlany_conn, const char * sql_str );
typedef void (*sqlany_free_stmt_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_i32 (*sqlany_num_params_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_bool (*sqlany_describe_bind_param_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, a_sqlany_bind_param * params );
typedef sacapi_bool (*sqlany_bind_param_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, a_sqlany_bind_param * params );
typedef sacapi_bool (*sqlany_send_param_data_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, char * buffer, size_t size );
typedef sacapi_bool (*sqlany_reset_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_bool (*sqlany_get_bind_param_info_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 index, a_sqlany_bind_param_info * info );
typedef sacapi_bool (*sqlany_execute_func)( a_sqlany_stmt * sqlany_stmt );
typedef a_sqlany_stmt * (*sqlany_execute_direct_func)( a_sqlany_connection * sqlany_conn, const char * sql_str );
typedef sacapi_bool (*sqlany_fetch_absolute_func)( a_sqlany_stmt * sqlany_result, sacapi_i32 row_num );
typedef sacapi_bool (*sqlany_fetch_next_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_bool (*sqlany_get_next_result_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_i32 (*sqlany_affected_rows_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_i32 (*sqlany_num_cols_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_i32 (*sqlany_num_rows_func)( a_sqlany_stmt * sqlany_stmt );
typedef sacapi_bool (*sqlany_get_column_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, a_sqlany_data_value * buffer );
typedef sacapi_i32 (*sqlany_get_data_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, size_t offset, void * buffer, size_t size );
typedef sacapi_bool (*sqlany_get_data_info_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, a_sqlany_data_info * buffer );
typedef sacapi_bool (*sqlany_get_column_info_func)( a_sqlany_stmt * sqlany_stmt, sacapi_u32 col_index, a_sqlany_column_info * buffer );
typedef sacapi_bool (*sqlany_commit_func)( a_sqlany_connection * sqlany_conn );
typedef sacapi_bool (*sqlany_rollback_func)( a_sqlany_connection * sqlany_conn );
typedef sacapi_bool (*sqlany_client_version_func)( char * buffer, size_t len );
typedef sacapi_i32 (*sqlany_error_func)( a_sqlany_connection * sqlany_conn, char * buffer, size_t size );
typedef size_t (*sqlany_sqlstate_func)( a_sqlany_connection * sqlany_conn, char * buffer, size_t size );
typedef void (*sqlany_clear_error_func)( a_sqlany_connection * sqlany_conn );

#if defined( __cplusplus )
}
#endif

#define function( x ) 	x ## _func x
/** An API interface structure.
 * The user would need only one instance of this in their environment. When the
 * instance is initialized, the DLL will be loaded and all the entry points will be looked up.
 */
typedef struct SQLAnywhereInterface {
    /** DLL handle.
     */
    void	* dll_handle;			

    /** Flag to know if initialized or not.
     */
    int		  initialized;			

    /** Pointer to ::sqlany_init() function.
     */
    function( sqlany_init );		

    /** Pointer to ::sqlany_fini() function.
     */
    function( sqlany_fini );			

    /** Pointer to ::sqlany_new_connection() function.
     */
    function( sqlany_new_connection );		

    /** Pointer to ::sqlany_free_connection() function.
     */
    function( sqlany_free_connection );		

    /** Pointer to ::sqlany_make_connection() function.
     */
    function( sqlany_make_connection );		

    /** Pointer to ::sqlany_connect() function.
     */
    function( sqlany_connect );			

    /** Pointer to ::sqlany_disconnect() function.
     */
    function( sqlany_disconnect );		

    /** Pointer to ::sqlany_execute_immediate() function.
     */
    function( sqlany_execute_immediate );	

    /** Pointer to ::sqlany_prepare() function.
     */
    function( sqlany_prepare );			

    /** Pointer to ::sqlany_free_stmt() function.
     */
    function( sqlany_free_stmt );		

    /** Pointer to ::sqlany_num_params() function.
     */
    function( sqlany_num_params );		

    /** Pointer to ::sqlany_describe_bind_param() function.
     */
    function( sqlany_describe_bind_param );		

    /** Pointer to ::sqlany_bind_param() function.
     */
    function( sqlany_bind_param );	

    /** Pointer to ::sqlany_send_param_data() function.
     */
    function( sqlany_send_param_data );		

    /** Pointer to ::sqlany_reset() function.
     */
    function( sqlany_reset );		

    /** Pointer to ::sqlany_get_bind_param_info() function.
     */
    function( sqlany_get_bind_param_info );		

    /** Pointer to ::sqlany_execute() function.
     */
    function( sqlany_execute );			

    /** Pointer to ::sqlany_execute_direct() function.
     */
    function( sqlany_execute_direct );		

    /** Pointer to ::sqlany_fetch_absolute() function.
     */
    function( sqlany_fetch_absolute );		

    /** Pointer to ::sqlany_fetch_next() function.
     */
    function( sqlany_fetch_next );		

    /** Pointer to ::sqlany_get_next_result() function.
     */
    function( sqlany_get_next_result );		

    /** Pointer to ::sqlany_affected_rows() function.
     */
    function( sqlany_affected_rows );		

    /** Pointer to ::sqlany_num_cols() function.
     */
    function( sqlany_num_cols );		

    /** Pointer to ::sqlany_num_rows() function.
     */
    function( sqlany_num_rows );		

    /** Pointer to ::sqlany_get_column() function.
     */
    function( sqlany_get_column );		

    /** Pointer to ::sqlany_get_data() function.
     */
    function( sqlany_get_data );		

    /** Pointer to ::sqlany_get_data_info() function.
     */
    function( sqlany_get_data_info );		

    /** Pointer to ::sqlany_get_column_info() function.
     */
    function( sqlany_get_column_info );		

    /** Pointer to ::sqlany_commit() function.
     */
    function( sqlany_commit );			

    /** Pointer to ::sqlany_rollback() function.
     */
    function( sqlany_rollback );		

    /** Pointer to ::sqlany_client_version() function.
     */
    function( sqlany_client_version );		

    /** Pointer to ::sqlany_error() function.
     */
    function( sqlany_error );			

    /** Pointer to ::sqlany_sqlstate() function.
     */
    function( sqlany_sqlstate );			

    /** Pointer to ::sqlany_clear_error() function.
     */
    function( sqlany_clear_error );		

} SQLAnywhereInterface;
#undef function

/** Initializes the SQLAnywhereInterface object and loads the DLL dynamically.
 * This function attempts to load the SQL Anywhere C API DLL dynamically and looks up all
 * the entry points of the DLL. The fields in the SQLAnywhereInterface structure will be
 * populated to point to the corresponding functions in the DLL. If the optional path argument
 * is NULL, the environment variable SQLANY_DLL_PATH will be checked. If the variable is set, 
 * the library will attempt to load the DLL specified by the environment variable. If that fails,
 * the interface will attempt to load the DLL directly (this relies on the environment being
 * setup correctly).
 * \param api An API structure to initialize.
 * \param optional_path_to_dll An optional argument that specifies a path to the DLL API to load.
 * \return 1 on successful initialization, and 0 on failure.
 */
int sqlany_initialize_interface( SQLAnywhereInterface * api, const char * optional_path_to_dll );

/** Finalize and free resources associated with the SQL Anywhere C API DLL.
 * This function will unload the library and uninitialize the supplied SQLAnywhereInterface
 * structure. 
 * \param api An initialized structure to finalize.
 */

void sqlany_finalize_interface( SQLAnywhereInterface * api );

#endif 
