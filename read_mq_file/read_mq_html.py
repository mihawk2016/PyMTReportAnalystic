from bs4 import BeautifulSoup
import pandas as pd
import numpy as np












def read_html(html_file):
    mq_html_content = html_content(html_file)
    html_generator = mq_html_content.meta.get('content')
    if html_generator is None:
        return None
    elif 'MetaQuotes' in html_generator:
        print('it is a mt4 html file')
        # Todo: handle mt4 html file
        # read_html_mt4(html_file, mq_html_content)
    elif 'MetaTrader 5' in html_generator:
        print('it is a mt5 html file')
        # Todo: handle mt5 html file
    else:
        return None


def html_content(html_file):
    """
    :param html_file: input a html file
    :return: content of html file
    """
    with open(html_file, encoding='UTF-8') as f:
        mq_html_content = BeautifulSoup(f, 'lxml')
    return mq_html_content


# def html_table(html_file):
    # print(len(pd.read_html(html_file, encoding='UTF-8', index_col=False)))
    # return pd.read_html(html_file, encoding='UTF-8', na_values=' ', keep_default_na=False)[0]


def read_html_mt4(html_content):
    """"""
    title = html_content.title.string
    if title is None:
        return None
    elif 'Statement' in title:
        print('it is a mt4 trades html file')
        # Todo: handle mt4 trades html file
    elif 'Strategy' in title:
        print('it is a mt4 EA html file')
        # Todo: handle mt4 EA html file
    else:
        return None


def read_html_mt4_trade(html_file, html_content):
    table = pd.read_html(html_file, encoding='UTF-8', na_values=' ', keep_default_na=False)[0]
    summary_index = list(table[0]).index('Summary:')
    table = table[:summary_index]
    # table.columns = [['1', '2', '2', '2', '2', '2', '2', '2', '2', '2', '2', '2', '2', '2']]
    # print(table, '\n')
    broker = html_content.find('b').get_text()
    comment = [tr.td.get('title') if tr.td.has_attr('title') else ''
               for tr in html_content.find_all('tr', limit=summary_index)]

    # b = table.select(lambda x: list(x)[0].isdigit(), axis=1)
    b = []

    def get_group(table_row):
        row_list = list(table_row)
        if not row_list[0].isdigit():
            return ''
        leer_count = row_list.count('')
        if leer_count is 0:
            return 'Closed'
        if leer_count is 9:
            return 'Money'
        if leer_count is 3:
            return 'Pending'
        if leer_count is 1:
            return 'Open'
        if leer_count is 5:
            return 'Working'
        return ''
    table['Group'] = table.apply(get_group, axis=1)
    # a = table.apply(get_group, axis=1)
    # print(a)

    table['Comment'] = comment

    # for i in range(summary_index):
    #     print(list(table.iloc[i]).count(''))

    print(table)
    print(b)
    # for x in comment:
    #
    #     print(x)
    # table = html_table(html_file)

    pass






def build_info(account=None, name=None, currency=None, leverage=None, time=None, group=None, broker=None):
    return {
        'Account': account,
        'Name': name,
        'Currency': currency,
        'Leverage': leverage,
        'Time': time,
        'Group': group,
        'Broker': broker
    }


if __name__ == '__main__':
    import timeit
    file = '../_TEST_FILE/MT4Trade.htm'
    content = html_content(file)
    # table = html_table(file)

    read_html_mt4_trade(file, content)

    # def TEST():
    #     return read_html_mt4_trade(file, content)
    # print(timeit.timeit('TEST()', setup='from __main__ import TEST', number=10))

    # a = x.fillna('')

    # a = list(table.ix[0])

    # print(table.to_records()[0])
    # np.array
    # x.to_csv('../abc.csv')
    # print(x)

