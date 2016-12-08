import enum


class TicketGroup(enum.Enum):
    MONEY = 'Money'
    CLOSED = 'Closed'
    PENDING = 'Pending'
    OPEN = 'Open'
    WORKING = 'Working'


class Generator(enum.Enum):
    MT4TRADE = 'MT4-Trade'
    MT4EA = 'MT4-EA'
    MT5TRADE = 'MT5-Trade'
    MT5EA = 'MT5-EA'


class Info(enum.Enum):
    GENERATOR = 'Generator'
    ACCOUNT = 'Account'
    NAME = 'Name'
    CURRENCY = 'Currency'
    LEVERAGE = 'Leverage'
    TIME = 'Time'
    GROUP = 'Group'
    BROKER = 'Broker'


class TicketColumn(enum.Enum):
    TICKET = 'Ticket'
    OPEN_TIME = 'Open_Time'
    TYPE = 'Type'
    SIZE = 'Size'
    ITEM = 'Item'
    OPEN_PRICE = 'Open_Price'
    SL = 'SL'
    TP = 'TP'
    CLOSE_TIME = 'Close_Time'
    CLOSE_PRICE = 'Close_PRICE'
    COMMISSION = 'Commission'
    TAXES = 'Taxes'
    SWAP = 'Swap'
    PROFIT = 'Profit'
    GROUP = 'Group'
    COMMENT = 'Comment'