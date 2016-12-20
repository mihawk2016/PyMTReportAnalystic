

MYSQL = {
    'user': 'root',
    'password': '',
    'host': '192.168.2.103',
    'database': 'historical_data'
}




if __name__ == '__main__':
    import pandas as pd
    a = pd.DataFrame.from_csv('.\\Symbols.csv')
    print(a, a.dtypes)