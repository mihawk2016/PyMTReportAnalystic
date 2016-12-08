
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

build.report.info <- function(account = NA, group = NA, name = NA, broker = NA, currency = NA, leverage = NA, time = NA) {
  # ''' create info dataframe '''
  # 2016-08-16: Done
  # 2016-08-16: ToDo: chinese 'name'
  data.frame(
    stringsAsFactors = F,
    row.names = NULL,
    Account = reform.report.info.account(account),
    Group = group,
    Name = reform.report.info.name(name),
    Broker = reform.report.info.broker(broker),
    Currency = reform.report.info.currency(currency),
    Leverage = reform.report.info.leverage(leverage),
    Time = reform.report.info.time(time)
  )
} # 2016-08-16: Done

file.html.mt4 <- function(file.link, html.parse) {
  # ''' handle mt4 html file '''
  # 2016-08-16: TESTING
  require(XML)
  html_title <- tryCatch(xmlValue(getNodeSet(html.parse, '//title')[[1]]), error = function() return('error'))
  if (grepl('Sta', html_title)) {
    return(file.html.mt4.trade(file.link, html.parse))
  }
  if (grepl('Str', html_title)) {
    return(file.html.mt4.strategy(file.link, html.parse))
  }
  return(NULL)
} # 2016-08-16: TESTING


file.html.meta.content <- function(html.parse) {
  # ''' get html meta/content, get type "MT4" or "MT5" '''
  # 2016-08-11: Done
  require(XML)
  tryCatch(xmlAttrs(getNodeSet(html.parse, '//meta')[[1]])['content'], error = function() return('error'))
} # 2016-08-11: Done

file.html <- function(file.link) {
  # ''' work with html file '''
  # 2016-08-17: TESTING
  require(XML)
  html_parse <- htmlParse(file.link)
  html_type <- file.html.meta.content(html_parse)
  if (grepl('MetaQuotes', html_type)) {
    return(file.html.mt4(file.link, html_parse))
  }
  if (grepl('MetaTrader 5', html_type)) {
    return(file.html.mt5(file.link, html_parse))
  }
  return(NULL)
} # 2016-08-17: TESTING


input.files <- function(file.link) {
  # ''' input files to report '''
  # 2016-08-11: Working
  file_name <- file.name(file.link)
  file_extension <- file.extension(file_name)
  report <- if (grepl('htm|html', file_extension)) {
    file.html(file.link)
  } else if (grepl('xlsx|xls', file_extension)) {
    # 2016-08-11: Working
    require(xlsx)
    xlsx_table <- read.xlsx(file_link, 1, encoding = 'UTF-8', stringsasfactors = f)
    file.csv_xlsx(file.link, xlsx_table)
  } else if (grepl('csv', file_extension)) {
    # 2016-08-11: Working
    csv_table <- read.csv(file_link, encoding = 'UTF-8')
    file.csv_xlsx(file_link, csv_table)
  } else {
    NULL
  }
  if (is.null(report)) return(NULL)
  within(report, Source <- file.link)
} # 2016-08-17: TESTING

file.extension <- function(file.link) {
  # ''' get file extension '''
  # 2016-08-11: Done
  tolower(tail(strsplit(file.link, '.', fixed = T)[[1]], 1))
} # 2016-08-11: Done

file.name <- function(file.link) {
  # ''' get file name '''
  # 2016-08-11: Done
  tail(strsplit(file.link, '/', fixed = T)[[1]], 1)
} # 2016-08-11: Done

