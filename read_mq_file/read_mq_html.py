from bs4 import BeautifulSoup
import pandas as pd
import re

from defines import Generator, TicketGroup, Info, TicketColumn, TICKET_COLUMNS


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


def read_html_mt4(html_file, html_content):
    """"""
    title = html_content.title.string
    if title is None:
        return None
    elif 'Statement' in title:
        return read_html_mt4_trade(html_file, html_content)
    elif 'Strategy' in title:
        print('it is a mt4 EA html file')
        # Todo: handle mt4 EA html file
    else:
        return None


def read_html_mt4_trade(html_file, html_content):
    table = pd.read_html(html_file, encoding='UTF-8', na_values=' ', keep_default_na=False)[0]
    summary_index = list(table[0]).index('Summary:')
    table = table[:summary_index]

    def info_dict(string):
        if re.match('^[0-9]{4}', string) is not None:
            return 'time', string
        else:
            string = string.replace(' ', '')
            string_split = string.split(':')
            return string_split[0].lower(), string_split[-1]
    table_info = {k: v for k, v in [info_dict(string) for string in table.ix[0] if string is not '']}
    info = build_info(**table_info, broker=html_content.find('b').get_text(), generator=Generator.MT4TRADE.value)
    first_col_list = list(table[0])
    ticket_index = [first_col_list[index].isdigit() for index in range(len(first_col_list))]
    table = table[ticket_index]
    tr = html_content.find_all('tr', limit=summary_index)
    ticket_tr = [tr[index] for index in table.index]

    def get_group(table_row):
        row_list = list(table_row)
        leer_count = row_list.count('')
        if leer_count is 0:
            return TicketGroup.CLOSED.value
        if leer_count is 9:
            return TicketGroup.MONEY.value
        if leer_count is 3:
            return TicketGroup.PENDING.value
        if leer_count is 1:
            return TicketGroup.OPEN.value
        if leer_count is 5:
            return TicketGroup.WORKING.value
        return ''
    table[TicketColumn.GROUP.value] = table.apply(get_group, axis=1)
    table[TicketColumn.COMMENT.value] = [tr.td.get('title') if tr.td.has_attr('title') else '' for tr in ticket_tr]
    table.loc[table.Group == TicketGroup.MONEY.value, 13] = table.loc[table.Group == TicketGroup.MONEY.value, 4]
    table.loc[table.Group == TicketGroup.MONEY.value, 3] = table.loc[table.Group == TicketGroup.MONEY.value, 4] = ''
    table.loc[table.Group == TicketGroup.PENDING.value, 10] = ''
    table.columns = TICKET_COLUMNS[:16]
    return table, info







def build_info(generator=None, account=None, name=None, currency=None,
               leverage=None, time=None, group=None, broker=None):
    """
    :param generator: generator of html page in ['MT4-Trade', 'MT4-EA', 'MT5-Trade', 'MT5-EA']
    :param account: login number
    :param name: login name
    :param currency: account currency
    :param leverage: account leverage
    :param time: file create time
    :param group: account group in database
    :param broker: account broker
    :return: a dict of all infos of the file
    """
    return {
        Info.GENERATOR.value: generator,
        Info.ACCOUNT.value: account,
        Info.NAME.value: name,
        Info.CURRENCY.value: currency,
        Info.LEVERAGE.value: leverage,
        Info.TIME.value: time,
        Info.GROUP.value: group,
        Info.BROKER.value: broker
    }


if __name__ == '__main__':
    import timeit
    file = '../_TEST_FILE/MT4Trade.htm'
    content = html_content(file)
    # table = html_table(file)

    # x = read_html_mt4_trade(file, content)
    # print(x)


    def TEST():
        read_html_mt4_trade(file, content)
    print(timeit.timeit('TEST()', setup='from __main__ import TEST', number=1))

    # a = x.fillna('')

    # a = list(table.ix[0])

    # print(table.to_records()[0])
    # np.array
    # x.to_csv('../abc.csv')
    # print(x)

