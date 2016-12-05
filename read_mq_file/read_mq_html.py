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


def html_table(html_file):
    # print(len(pd.read_html(html_file, encoding='UTF-8', index_col=False)))
    return pd.read_html(html_file, encoding='UTF-8', index_col=False)[0]



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
    file = '../TEST_FILE/MT4Trade.htm'
    x = html_table(file)

    a = x.fillna('')
    print(list(a.ix[0]))

    # x.to_csv('../abc.csv')
    # print(x)

