-- create user
create user padawan password 'padawan12345';
grant all on database dsdojo_db to padawan;
grant pg_read_server_files to padawan ;
grant pg_write_server_files to padawan ;