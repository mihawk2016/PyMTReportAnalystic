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


class GroupFieldCount(enum.IntEnum):
    CLOSED = 0
    MONEY = 9
    PENDING = 3
    OPEN = 1
    WORKING = 5

TICKET_COLUMNS = [TicketColumn.TICKET.value,
                  TicketColumn.OPEN_TIME.value,
                  TicketColumn.TYPE.value,
                  TicketColumn.SIZE.value,
                  TicketColumn.ITEM.value,
                  TicketColumn.OPEN_PRICE.value,
                  TicketColumn.SL.value,
                  TicketColumn.TP.value,
                  TicketColumn.CLOSE_TIME.value,
                  TicketColumn.CLOSE_PRICE.value,
                  TicketColumn.COMMISSION.value,
                  TicketColumn.TAXES.value,
                  TicketColumn.SWAP.value,
                  TicketColumn.PROFIT.value,
                  TicketColumn.GROUP.value,
                  TicketColumn.COMMENT.value]

TICKET_COLUMN_GROUP = {
    'INT': [TicketColumn.TICKET.value],
    'TIME': [TicketColumn.OPEN_TIME.value,
             TicketColumn.CLOSE_TIME.value],
    'STRING': [TicketColumn.TYPE.value,
               TicketColumn.ITEM.value,
               TicketColumn.GROUP.value,
               TicketColumn.COMMENT.value],
    'FLOAT': [TicketColumn.SIZE.value,
              TicketColumn.OPEN_PRICE.value,
              TicketColumn.SL.value,
              TicketColumn.TP.value,
              TicketColumn.CLOSE_PRICE.value],
    'MONEY': [TicketColumn.COMMISSION.value,
              TicketColumn.TAXES.value,
              TicketColumn.SWAP.value,
              TicketColumn.PROFIT.value]
}



