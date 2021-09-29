import time
import pandas as pd
from sqlalchemy import create_engine
import psycopg2


#INPUT YOUR OWN CONNECTION STRING HERE
conn_string = 'postgresql://postgres:@localhost:5432/devbox'


db = create_engine(conn_string)
conn = db.connect()


sql = '''
COPY products
FROM '/Users/devbox/HackReactor/RFP55/SDC/Products-Service/csv/product.csv'
DELIMITER ',' CSV;
'''

table_create_sql = '''
CREATE TABLE IF NOT EXISTS products (id                bigint,
                                      name             varchar (100),
                                      slogan           varchar(255),
                                      description      text,
                                      category         varchar(100),
                                      default_price    integer)
'''

pg_conn = psycopg2.connect(conn_string)
cur = pg_conn.cursor()
cur.execute(table_create_sql)
cur.execute('TRUNCATE TABLE products') #Truncate the table in case you've already run the script before

start_time = time.time()
cur.execute(sql)
pg_conn.commit()
cur.close()
print("COPY duration: {} seconds".format(time.time() - start_time))


#close connection
conn.close()