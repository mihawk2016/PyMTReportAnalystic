import mysql.connector
import pandas as pd





# conn = mysql.connector.connect(**mysql_config)
# cursor = conn.cursor()
#
# cursor.execute('select * from audcad limit 1000')
# values = cursor.fetchall()
#
# print(values)
#
# conn.close()

with mysql.connector.connect(**mysql_config) as conn:
    cursor = conn.cursor()
    cursor.execute('select * from audcad limit 1000')
    values = cursor.fetchall()

    print(values)

