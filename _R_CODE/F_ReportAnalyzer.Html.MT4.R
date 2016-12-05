# ''' all functions for mt4 html file '''
# 2016-08-16: Create


#### Trade ####

file.html.mt4.trade <- function(file.link, html.parse) {
  # ''' work with mt4 statement html file '''
  # 2016-08-16: Done
  require(XML)
  html_table <- readHTMLTable(file.link, stringsAsFactors = FALSE, encoding = 'UTF-8')[[1]]
  build.report(
    type = 'MT4 - Trade',
    tickets = file.html.mt4.trade.tickets(html_table, html.parse),
    info = file.html.mt4.trade.info(html.parse)
  )
} # 2016-08-16: Done

file.html.mt4.trade.info <- function(html.parse) {
  # ''' get mt4 html trade file: info '''
  # 2016-08-16: Done
  require(XML)
  infos <- sapply(getNodeSet(html.parse, '//b')[1:8], xmlValue)
  time.index <- which(grepl('Trans', infos)) - 1
  others <- infos[2:(time.index - 1)]
  build.report.info(
    account = others[grep('Account', others)],
    name = others[grep('Name', others)],
    broker = infos[1],
    currency = others[grep('Currency', others)],
    leverage = others[grep('Leverage', others)],
    time = infos[time.index]
  )
} # 2016-08-16: Done

file.html.mt4.trade.tickets <- function(html.table, html.parse) {
  # ''' mt4 html trade tickets '''
  # 2016-08-16: Done
  # 2016-08-16: Optimate
  html.table[html.table == ''] <- NA
  html.table$Comment <- file.html.mt4.trade.tickets.comment(html.parse)
  suppressWarnings(tickets <- html.table[which(!is.na(as.numeric(html.table[, 1]))),])
  if (nrow(tickets) == 0) return(NULL)
  na.count <- as.numeric(rowSums(is.na(tickets)))
  build.report.tickets.group(
    money = build.report.tickets.money.from.table(tickets[which(na.count == 9), ], c(1, 2, 5, 15)),
    closed = build.report.tickets.closed.from.table(tickets[which(na.count == 0), ], 1:15),
    open = build.report.tickets.open.from.table(tickets[which(na.count == 1), ], c(1:8, 10:15)),
    pending = build.report.tickets.pending.from.table(tickets[which(na.count == 3), ], c(1:10, 15)),
    working = build.report.tickets.working.from.table(tickets[which(na.count == 5), ], c(1:8, 10, 15))
  )
} # 2016-08-16: Optimate

file.html.mt4.trade.tickets.comment <- function(html.parse) {
  # ''' get comment for mt4 statement html file '''
  # 2016-08-12: ToDo: getNodeSet() arg:fun= xmlChildren
  require(XML)
  tag_tr_children <- sapply(getNodeSet(html.parse, '//tr'), xmlChildren)
  comments <- sapply(tag_tr_children, function(title) {
    comment <- xmlGetAttr(title[[1]], 'title')
    return(ifelse(is.null(comment), '', comment))
  })[-1]
} # 2016-08-12: ToDo

#### strategy ####

file.html.mt4.strategy <- function(file.link, html.parse) {
  # ''' work with mt4 strategy from html file '''
  # 2016-08-17: TESTING
  info <- file.html.mt4.strategy.info(file.link, html.parse)
  build.report(
    type = 'MT4 - EA',
    tickets = file.html.mt4.strategy.tickets(file.link, html.parse, info$Time),
    info = info
  )
} # 2016-08-17: TESTING

file.html.mt4.strategy.info <- function(file.link, html.parse) {
  # ''' mt4 strategy info '''
  # 2016-08-17: Done
  require(XML)
  head.lines <- getNodeSet(html.parse, '//b', fun = xmlValue)[2:3]
  time.string <- getNodeSet(html.parse, '//tr', fun = xmlValue)[2]
  nchar.time.string <- nchar(time.string)
  time <- substr(time.string, nchar.time.string - 10, nchar.time.string - 1)
  build.report.info(
    name = head.lines[[1]],
    broker = head.lines[[2]],
    time = time
  )
} # 2016-08-17: Done

file.html.mt4.strategy.tickets <- function(file.link, html.parse, end.time) { #}, item.symbol.mapping, support.symbols.table) {
  # ''' get mt4 strategy tickets '''
  # 2016-08-17: TESTING
  require(XML)
  item <- file.html.mt4.strategy.tickets.item(html.parse)
  tickets.table <- readHTMLTable(file.link, stringsAsFactors = FALSE)[[2]]

  tickets <- subset(tickets.table, subset = tickets.table[, 3] != 'modify', select = -c(1, 10))
  tickets[, 1] <- reform.time(tickets[, 1])
  tickets[, 3] <- as.numeric(tickets[, 3])
  pending.tickets.close.index <- which(tickets[, 2] == 'delete')
  if (length(pending.tickets.close.index) > 0) {
    pending.tickets.close <- tickets[pending.tickets.close.index,]
    pending.tickets.tickets <- pending.tickets.close[, 3]
    tickets._pending.tickets.close <- tickets[ - pending.tickets.close.index,]
    pending.tickets.open.index <- which(tickets._pending.tickets.close[, 3] %in% pending.tickets.tickets)
    pending.tickets.open <- tickets._pending.tickets.close[pending.tickets.open.index,]
    pending.tickets <- merge(pending.tickets.open, pending.tickets.close, by = 3)
    # pending.tickets$Item <- file.html.mt4.strategy.tickets.item(html.parse)
    # pending.tickets$Comment <- ''
    # pending.tickets <- build.report.tickets.pending.from.table(pending.tickets, c(1:4, 15, 5, 13, 14, 9, 12, 16))
    tickets.pending <- build.report.tickets.pending.from.columns(
      ticket = pending.tickets[, 1],
      otime = pending.tickets[, 2],
      type = pending.tickets[, 3],
      volume = pending.tickets[, 4],
      item = item,
      oprice = pending.tickets[, 5],
      sl = pending.tickets[, 13],
      tp = pending.tickets[, 14],
      ctime = pending.tickets[, 9],
      cprice = pending.tickets[, 12]
    )
    closed.tickets <- tickets._pending.tickets.close[-pending.tickets.open.index, ]
  } else {
    tickets.pending <- NULL
    closed.tickets <- tickets
  }
  closed.pending.index <- which(grepl('(buy|sell) (limit|stop)', closed.tickets[, 2]))
  if (length(closed.pending.index) > 0) {
    closed.tickets <- closed.tickets[ - closed.pending.index,]
  }
  closed.tickets.open.index <- which(grepl('(buy|sell)', closed.tickets[, 2]))
  closed.tickets <- merge(closed.tickets[closed.tickets.open.index,], closed.tickets[ - closed.tickets.open.index,], by = 3)
  comment <- closed.tickets[, 10]
  close.at.stop.index <- which(grepl(' at ', comment))
  so.index.in.close.at.stop <- which(difftime(end.time, closed.tickets[close.at.stop.index, 9], units = 'mins') >= 1)
  if (length(so.index.in.close.at.stop) > 0) {
    so.index <- close.at.stop.index[so.index.in.close.at.stop]
    comment[so.index] <- 'so'
    closed.tickets[, 10] <- comment
  }
  part.closed.index <- which(closed.tickets[, 4] != closed.tickets[, 11])
  closed.tickets[part.closed.index, 4] <- closed.tickets[part.closed.index, 11]
  if (length(part.closed.index) > 0) {
    sapply(part.closed.index + 1, function(x) {
      closed.tickets[x, 2] <<- closed.tickets[x - 1, 2]
      # closed.tickets[x, 4] <- closed.tickets[x, 11]
    })
  }
  tickets.closed <- build.report.tickets.closed.from.columns(
    ticket = closed.tickets[, 1],
    otime = closed.tickets[, 2],
    type = closed.tickets[, 3],
    volume = closed.tickets[, 4],
    item = item,
    oprice = closed.tickets[, 5],
    sl = closed.tickets[, 13],
    tp = closed.tickets[, 14],
    ctime = closed.tickets[, 9],
    cprice = closed.tickets[, 12],
    profit = closed.tickets[, 15],
    comment = closed.tickets[, 10]
  )
  tickets.money <- build.report.tickets.money.from.columns(
    ticket = 0,
    otime = file.html.mt4.strategy.tickets.begin(html.parse),
    profit = file.html.mt4.strategy.tickets.capital(html.parse)
  )
  build.report.tickets.group(
    closed = tickets.closed,
    pending = tickets.pending,
    money = tickets.money
  )
} # 2016-08-17: TESTING

file.html.mt4.strategy.tickets.item <- function(html.parse) {
  # ''' mt4 strategy item '''
  # 2016-08-14: Done
  item.string <- getNodeSet(html.parse, '//tr/td', fun = xmlValue)[[2]]
  gsub(' ([ \\(\\)[:alpha:]])*', '', item.string)
} # 2016-08-14: Done

file.html.mt4.strategy.tickets.begin <- function(html.parse) {
  # ''' mt4 strategy info '''
  # 2016-08-14: Done
  require(XML)
  time.string <- getNodeSet(html.parse, '//tr', fun = xmlValue)[2]
  nchar.time.string <- nchar(time.string)
  substr(time.string, nchar.time.string - 23, nchar.time.string - 14)
} # 2016-08-14: Done

file.html.mt4.strategy.tickets.capital <- function(html.parse) {
  # ''' mt4 strategy capital '''
  # 2016-08-14: Done
  xmlValue(xmlChildren(getNodeSet(html.parse, '//tr')[[7]])[[2]])
} # 2016-08-14: Done

#------------------------