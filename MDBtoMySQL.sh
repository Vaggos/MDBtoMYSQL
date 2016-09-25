#!/usr/bin/env bash

# Table 2-1. MDB Utilities

# Name	Description
# mdb-tables	list tables in the specified file
# mdb-schema	generate schema DDL for the specified file
# mdb-export	generate CSV style output for a table
# mdb-ver	display the version of the specified file
# mdb-header	support for using MDB data in C
# mdb-parsecsv	support for using MDB data in C
# mdb-sql	command line SQL query tool

echo "-- -----------------------------------------------------------------------";
echo "-- MDBtoSQL";
echo "-- A library for easy data migration from MS Access to a MySQL database";
echo "-- Copyright (C) 2016- Vagelis Prokopiou.";
echo "-- Licensed under the MIT licence.";
echo "-- For more info, check out https://github.com/Vaggos/MDBtoMySQL";
echo "-- ";
echo "-- Usage info:";
echo "-- This script presupposes that \"mdbtools\" are installed in your system.";
echo "-- If not, install them with \"sudo apt-get install mdbtools\" in a Debian";
echo "-- or Debian-based system.";
echo "-- -----------------------------------------------------------------------";


# Get all the info you need.
sleep 1;
echo "";
echo "Please, provide the name of the MySQL user.";
read user;

echo "";
echo "Please, provide the password of the MySQL user.";
read password;

echo "";
echo "Please, provide the name of the database that will be created.";
echo "Do not use spaces or any special characters:";
read db_to_create;
echo "$db_to_create";

echo "";
echo "Please, provide the name of the mdb file.";
echo "Make sure to provide the full path,
if the file is not in the current directory.";
read db_to_read;

# db_Movies.mdb

tables=$(mdb-tables $db_to_read);
#tables=$(mdb-tables $db_to_read | tr " "  "\n");
#for table in $tables; do echo "$table"; done;

# Create the database.
mysql -u$user -p$password -e "DROP DATABASE IF EXISTS $db_to_create";
mysql -u$user -p$password -e "CREATE DATABASE $db_to_create DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;";
echo "";
echo "<------------------------------------------------------------------------>"
echo "           Database \"$db_to_create\" was successfully created."
echo "<------------------------------------------------------------------------>"

# Create the tables.
for table in $tables;
    do mysql -uroot -proot -e "CREATE TABLE $db_to_create.$table(id INT NOT NULL AUTO_INCREMENT, PRIMARY KEY ( id ))";

    echo "";
    echo "<------------------------------------------------------------------------>"
    echo "           Table \"$table\" was successfully created."
    echo "<------------------------------------------------------------------------>"

done;

# Todo: Fix the mdb-schema output, to create automatically all the fields in the tables.
# Remove stuff I dont want.
#query=$(mdb-schema db.mdb  | sed "s/type.*/VARCHAR (255)/g" | tr '[' ' ' | tr ']' ' ' | sed 's/Long\ Integer/INT/g' | sed 's/Integer/INT/g' | sed "s/Text \(.*\)/VARCHAR (255)/g" | tr '/' '_' | sed "s/Memo_Hyperlink/VARCHAR (255)/g");
