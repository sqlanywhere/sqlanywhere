// *****************************************************
// Copyright (c) 2008-2010 iAnywhere Solutions, Inc.
// Portions copyright (c) 1988-2010 Sybase, Inc.
// All rights reserved. All unpublished rights reserved.
// *****************************************************
IF EXISTS( SELECT * FROM "SYS"."SYSTAB" WHERE "table_name" = 'test') THEN
  DROP TABLE "test";
END IF;

IF EXISTS( SELECT * FROM "SYS"."SYSTAB" WHERE "table_name" = 'types') THEN
  DROP TABLE "types";
END IF;

CREATE TABLE "test" (
  "id" INTEGER NOT NULL DEFAULT AUTOINCREMENT,
  PRIMARY KEY("id")
);

CREATE TABLE "types" (
  "id" INTEGER PRIMARY KEY,
  "_binary_" BINARY(8) DEFAULT NULL,
  "_numeric_" NUMERIC(2,1),
  "_decimal_" DECIMAL(2,1),
  "_bounded_string_" CHAR(255) DEFAULT NULL,
  "_unbounded_string_" LONG VARCHAR DEFAULT NULL,
  "_signed_bigint_" BIGINT DEFAULT NULL,
  "_unsigned_bigint_" UNSIGNED BIGINT DEFAULT NULL,
  "_signed_int_" INTEGER DEFAULT NULL,
  "_unsigned_int_" UNSIGNED INTEGER DEFAULT NULL,
  "_signed_smallint_" SMALLINT DEFAULT NULL,
  "_unsigned_smallint_" UNSIGNED SMALLINT DEFAULT NULL,
  "_signed_tinyint_" TINYINT DEFAULT NULL,
  "_unsigned_tinyint_" UNSIGNED TINYINT DEFAULT NULL,
  "_bit_" BIT,
  "_date_" DATE DEFAULT NULL,
  "_datetime_" DATETIME DEFAULT NULL,
  "_smalldatetime_" SMALLDATETIME DEFAULT NULL,
  "_timestamp_" TIMESTAMP DEFAULT NULL,
  "_double_" DOUBLE DEFAULT NULL,
  "_float_" FLOAT DEFAULT NULL,
  "_real_" REAL DEFAULT NULL
);

INSERT INTO types VALUES 
( 0,
  CAST ( 0x78 AS BINARY ),
  1.1,
  1.1,
  'Bounded String Test',
  'Unbounded String Test',
  9223372036854775807,
  18446744073709551615,
  2147483647,
  4294967295,
  32767,
  65535,
  255,
  255,
  1,
  DATE( '1999-01-02 21:20:53' ),
  DATETIME( '1999-01-02 21:20:53' ),
  DATETIME( '1999-01-02 21:20:53' ),
  DATETIME( '1999-01-02 21:20:53' ),
  1.79769313486231e+308,
  3.402823e+38,
  3.402823e+38
)

INSERT INTO types VALUES 
( 1,
  CAST ( 0xFF AS BINARY ), 
  -1.1,
  -1.1,
  '',
  '',
  -9223372036854775808,
  0,
  -2147483648,
  0,
  -32768,
  0,
  0,
  0,
  0,
  NULL,
  NULL,
  NULL,
  NULL,
  -1.79769313486231e+308,
  -3.402823e+38,
  -3.402823e+38 
)
