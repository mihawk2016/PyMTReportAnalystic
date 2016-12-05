# ''' build report tickets functions '''
# 2016-08-16: Create
# 2016-08-17: Optimate

build.report.tickets <- function(ticket = NA, otime = NA, type = NA, volume = NA, item = NA, oprice = NA, sl = NA, tp = NA, ctime = NA, cprice = NA, commission = NA, taxes = NA, swap = NA, profit = NA, group = NA, comment = NA, symbol = NA) {
  # ''' build report tickets: money '''
  # 2016-08-16: Done
  if (length(ticket) == 0) return(NULL)
  data.frame(
    stringsAsFactors = F,
    row.names = NULL,
    Ticket = reform.report.tickets.number(ticket),
    OTime = reform.report.tickets.time(otime),
    Type = reform.report.tickets.string(type),
    Volume = reform.report.tickets.number(volume),
    Item = reform.report.tickets.string(item),
    OPrice = reform.report.tickets.number(oprice),
    SL = reform.report.tickets.number(sl),
    TP = reform.report.tickets.number(tp),
    CTime = reform.report.tickets.time(ctime),
    CPrice = reform.report.tickets.number(cprice),
    Commission = reform.report.tickets.money(commission),
    Taxes = reform.report.tickets.money(taxes),
    Swap = reform.report.tickets.money(swap),
    Profit = reform.report.tickets.money(profit),
    Group = group,
    Comment = reform.comments(comment)
  )
} # 2016-08-16: Done

build.report.tickets.money.from.columns <- function(ticket, otime, profit, comment = '') {
  # ''' build report tickets: money, from columns '''
  # 2016-08-16: Done
  build.report.tickets(
    ticket = ticket,
    otime = otime,
    profit = profit,
    group = 'MONEY',
    comment = comment
  )
} # 2016-08-16: Done

build.report.tickets.money.from.table <- function(money.table, columns) {
  # ''' build report tickets: money, from data.frame '''
  # 2016-08-16: Done
  build.report.tickets.money.from.columns(
    ticket = money.table[[columns[1]]],
    otime = money.table[[columns[2]]],
    profit = money.table[[columns[3]]],
    comment = money.table[[columns[4]]]
  )
} # 2016-08-16: Done

build.report.tickets.closed.from.columns <- function(ticket, otime, type, volume, item, oprice, sl = 0, tp = 0, ctime, cprice, commission = 0, taxes = 0, swap = 0, profit = 0, comment = '') {
  # ''' build report tickets: closed, from columns '''
  # 2016-08-16: Done
  build.report.tickets(
    ticket = ticket,
    otime = otime,
    type = type,
    volume = volume,
    item = item,
    oprice = oprice,
    sl = sl,
    tp = tp,
    ctime = ctime,
    cprice = cprice,
    commission = commission,
    taxes = taxes,
    swap = swap,
    profit = profit,
    group = 'CLOSED',
    comment = comment
  )
} # 2016-08-12: Done

build.report.tickets.closed.from.table <- function(closed.table, columns) {
  # ''' build report tickets: closed, from data.frame '''
  # 2016-08-16: Done
  build.report.tickets.closed.from.columns(
    ticket = closed.table[[columns[1]]],
    otime = closed.table[[columns[2]]],
    type = closed.table[[columns[3]]],
    volume = closed.table[[columns[4]]],
    item = closed.table[[columns[5]]],
    oprice = closed.table[[columns[6]]],
    sl = closed.table[[columns[7]]],
    tp = closed.table[[columns[8]]],
    ctime = closed.table[[columns[9]]],
    cprice = closed.table[[columns[10]]],
    commission = closed.table[[columns[11]]],
    taxes = closed.table[[columns[12]]],
    swap = closed.table[[columns[13]]],
    profit = closed.table[[columns[14]]],
    comment = closed.table[[columns[15]]]
  )
} # 2016-08-16: Done

build.report.tickets.open.from.columns <- function(ticket, otime, type, volume, item, oprice, sl = 0, tp = 0, cprice, commission = 0, taxes = 0, swap = 0, profit = NA, comment = '') {
  # ''' build report tickets: open-, from columns '''
  # 2016-08-16: Done
  build.report.tickets(
    ticket = ticket,
    otime = otime,
    type = type,
    volume = volume,
    item = item,
    oprice = oprice,
    sl = sl,
    tp = tp,
    cprice = cprice,
    commission = commission,
    taxes = taxes,
    swap = swap,
    profit = profit,
    group = 'OPEN',
    comment = comment
  )
} # 2016-08-12: Done

build.report.tickets.open.from.table <- function(open.table, columns) {
  # ''' build report tickets: open-, from data.frame '''
  # 2016-08-17: Done
  build.report.tickets.open.from.columns(
    ticket = open.table[[columns[1]]],
    otime = open.table[[columns[2]]],
    type = open.table[[columns[3]]],
    volume = open.table[[columns[4]]],
    item = open.table[[columns[5]]],
    oprice = open.table[[columns[6]]],
    sl = open.table[[columns[7]]],
    tp = open.table[[columns[8]]],
    cprice = open.table[[columns[9]]],
    commission = open.table[[columns[10]]],
    taxes = open.table[[columns[11]]],
    swap = open.table[[columns[12]]],
    profit = open.table[[columns[13]]],
    comment = open.table[[columns[14]]]
  )
} # 2016-08-17: Done

build.report.tickets.pending.from.columns <- function(ticket, otime, type, volume, item, oprice, sl = 0, tp = 0, ctime, cprice, comment = '') {
  # ''' build report tickets: pending, from columns '''
  # 2016-08-16: Done
  build.report.tickets(
    ticket = ticket,
    otime = otime,
    type = type,
    volume = volume,
    item = item,
    oprice = oprice,
    sl = sl,
    tp = tp,
    ctime = ctime,
    cprice = cprice,
    group = 'PENDING',
    comment = comment
  )
} # 2016-08-12: Done

build.report.tickets.pending.from.table <- function(pending.table, columns) {
  # ''' build report tickets: pending, from data.frame '''
  # 2016-08-16: Done
  build.report.tickets.pending.from.columns(
    ticket = pending.table[[columns[1]]],
    otime = pending.table[[columns[2]]],
    type = pending.table[[columns[3]]],
    volume = pending.table[[columns[4]]],
    item = pending.table[[columns[5]]],
    oprice = pending.table[[columns[6]]],
    sl = pending.table[[columns[7]]],
    tp = pending.table[[columns[8]]],
    ctime = pending.table[[columns[9]]],
    cprice = pending.table[[columns[10]]],
    comment = pending.table[[columns[11]]]
  )
}# 2016-08-16: Done

build.report.tickets.working.from.columns <- function(ticket, otime, type, volume, item, oprice, sl = 0, tp = 0, cprice, comment = '') {
  # ''' build report tickets: working, from columns '''
  # 2016-08-17: Done
  build.report.tickets(
    ticket = ticket,
    otime = otime,
    type = type,
    volume = volume,
    item = item,
    oprice = oprice,
    sl = sl,
    tp = tp,
    cprice = cprice,
    group = 'Working',
    comment = comment
  )
} # 2016-08-17: Done

build.report.tickets.working.from.table <- function(working.table, columns) {
  # ''' build report tickets: working, from data.frame '''
  # 2016-08-17: Done
  build.report.tickets.working.from.columns(
    ticket = working.table[[columns[1]]],
    otime = working.table[[columns[2]]],
    type = working.table[[columns[3]]],
    volume = working.table[[columns[4]]],
    item = working.table[[columns[5]]],
    oprice = working.table[[columns[6]]],
    sl = working.table[[columns[7]]],
    tp = working.table[[columns[8]]],
    cprice = working.table[[columns[9]]],
    comment = working.table[[columns[10]]]
  )
} # 2016-08-17: Done

build.report.tickets.group <- function(closed = NULL, open = NULL, money = NULL, pending = NULL, working = NULL) {
  # ''' build all report tickets groups'''
  # 2016-08-14: Done
  # 2016-08-16: Change to rbind.data.frame type, it's easy to sort or merge
  #@2016-08-14
  #list(
  #Closed = closed,
  #Open = open,
  #Money = money,
  #Pending = pending,
  #Working = working
  #)
  #@2016-08-16
  all.tickets <- rbind(money, closed, open, pending, working, make.row.names = F)
  sort.dataframe(within(all.tickets, CTime <- reform.report.tickets.time(CTime)), 'OTime')
} # 2016-08-16: Done

#### Reform Type ####

reform.report.tickets.number <- function(number) {
  # ''' reform report tickets column: number '''
  # 2016-08-16: Done
  if (is.numeric(number)) {
    return(number)
  }
  if (is.character(number)) {
    match1 <- regexpr('[[:digit:]]+.[[:digit:]]+', number)
    match1.index <- which(match1 > 0)
    number[match1.index] <- substr(number[match1.index], match1[match1.index], attr(match1, 'match.length')[match1.index] + match1[match1.index] - 1)
    number[number == ''] <- '0'
    return(as.numeric(number))
  }
  NA
} # 2016-08-16: Done

reform.report.tickets.money <- function(money) {
  # ''' reform report tickets column: money '''
  # 2016-08-16: Done
  if (is.numeric(money)) {
    return(money)
  }
  if (is.character(money)) {
    money[money == ''] <- '0'
    return(as.numeric(gsub(' ', '', money)))
  }
  NA
} # 2016-08-16: Done

reform.report.tickets.time <- function(time) {
  # ''' reform report tickets column: time '''
  # 2016-08-16: TESTING
  reform.time(time)
} # 2016-08-16: TESTING

reform.report.tickets.string <- function(string) {
  # ''' reform report tickets column: string '''
  # 2016-08-16: Done
  toupper(string)
} # 2016-08-16: Done

#----------------------------------------------