# Swift Vapor Postgres Demo

Probably not best practice, I didn't want to use Fluent, so this is what I've scraped together - might be useful for others to see.


## Database setup

Within psql run:
    
```sql
CREATE DATABASE example;
\c example;
# make sure the uuid-ossp function is working for default ID
CREATE EXTENSION "uuid-ossp";
CREATE TABLE table1(id UUID NOT NULL DEFAULT uuid_generate_v1(), field1 VARCHAR, field2 VARCHAR, CONSTRAINT pkey_example PRIMARY KEY ( id ));
```



## Testing

```shell
# starts web server
swift run
```

In another tab, you can test the endpoints:

```shell
# test SQL connection
curl --location --request GET 'localhost:8080/sql' \
--header 'Content-Type: application/json'

# create an item
curl --location --request PUT 'localhost:8080/create' \
--header 'Content-Type: application/json' \
--data-raw '{
    "field1": "Hello, world!",
    "field2": "42"
}'
# 9FE1C462-426D-11EC-9D0D-ACDE48001122

# gets list of items in table1
curl --location --request GET 'localhost:8080/list' \
--header 'Content-Type: application/json'
# [{"id":"9FE1C462-426D-11EC-9D0D-ACDE48001122","field2":"42","field1":"Hello, world!"}]
```
