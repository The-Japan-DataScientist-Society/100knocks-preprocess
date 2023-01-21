-- create user
CREATE USER padawan PASSWORD 'padawan12345';
GRANT ALL ON DATABASE dsdojo_db TO padawan;
GRANT pg_read_server_files TO padawan;
GRANT pg_write_server_files TO padawan;
ALTER DATABASE dsdojo_db OWNER TO padawan;
