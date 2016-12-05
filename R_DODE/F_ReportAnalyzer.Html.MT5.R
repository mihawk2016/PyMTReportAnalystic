# ''' all functions for mt5 html file '''
# 2016-08-15: Create

file.html.mt5 <- function(file.link, html.parse) {
  # ''' handle mt5 html file '''
  # 2016-08-15: Working
  require(XML)
  html_title <- tryCatch(xmlValue(getNodeSet(html.parse, '//title')[[1]]), error = function() return('error'))
  if (html_title == 'error') {
    return(NULL)
  }
  if (grepl('Trade', html_title)) {
    return(file.html.mt5.trade(file.link))
  }
  if (grepl('Strategy', html_title)) {
    # Working
    return(file.html.mt5.strategy(file.link))
  }
  return(NULL)
}

#### Trade ####

file.html.mt5.trade <- function(file.link) {
  # ''' mt5 html trade file '''
  # 2016-08-16: TESTING
  require(XML)
  html_table <- readHTMLTable(file.link, stringsAsFactors = FALSE, encoding = 'UTF-8')[[1]]
  build.report(
    type = 'MT5 - Trade',
    tickets = file.html.mt5.trade.tickets(html_table),
    info = file.html.mt5.trade.info(html_table)
  )
} # 2016-08-16: TESTING

file.html.mt5.trade.info <- function(html.table) {
  # ''' mt5 html trade info '''
  # 2016-08-17: Done
  head.info <- html.table$V2[1:4]
  within(build.report.info(
    account = head.info[2],
    name = head.info[1],
    broker = head.info[3],
    currency = head.info[2],
    leverage = head.info[2],
    time = head.info[4]
  ), Time <- Time - 8 * 3600)
} # 2016-08-17: Done

file.html.mt5.trade.tickets <- function(html.table) {
  # ''' get mt5 strategy tickets '''
  # 2016-08-17: Working
  first_col <- html.table$V1
  spaces_index <- which(first_col == '')
  orders <- file.html.mt5.trade_strategy.tickets.group(html.table, first_col, spaces_index, 'Orders')
  positions <- file.html.mt5.trade_strategy.tickets.group(html.table, first_col, spaces_index, 'Trade Positions')
  workings <- file.html.mt5.trade_strategy.tickets.group(html.table, first_col, spaces_index, 'Working Orders')
  deals <- file.html.mt5.trade_strategy.tickets.group(html.table, first_col, spaces_index, 'Deals')
  positions.market.price <- file.html.mt5.trade.tickets.positions.market.price(positions)
  build.report.tickets.group(
    pending = file.html.mt5.trade.tickets.pending(orders),
    working = file.html.mt5.trade.tickets.working(workings),
    closed = file.html.mt5.trade_strategy.tickets.money_closed_open(deals, positions.market.price)
  )
} # 2016-08-17: Working

file.html.mt5.trade_strategy.tickets.group <- function(html.table, first.col, spaces.index, group.name) {
  # ''' get mt5 trade html group tickets '''
  # 2016-08-15: Done
  group.name.index <- which(first.col == group.name)
  if (length(group.name.index) == 0) return(NULL)
  group.begin.index <- group.name.index + 2
  group.end.index <- spaces.index[which(spaces.index > group.name.index)[1]] - 1
  if (group.begin.index > group.end.index) return(NULL)
  group <- html.table[group.begin.index:group.end.index,]
  colnames(group) <- html.table[group.name.index + 1,]
  group
} # 2016-08-15: Done

file.html.mt5.trade.tickets.working <- function(workings) {
  # ''' work with workings, create working ticktes '''
  # 2016-08-16: Done
  if (is.null(workings)) return(NULL)
  with(workings, {
    build.report.tickets.working.from.columns(
      ticket = Order,
      otime = `Open Time`,
      type = Type,
      volume = Volume,
      item = Symbol,
      oprice = Price,
      sl = `S / L`,
      tp = `T / P`,
      cprice = `Market Price`,
      comment = Comment
    )
  })
} # 2016-08-16: Done

file.html.mt5.trade.tickets.pending <- function(orders) {
  # ''' handle mt5 trade html orders tickets pending '''
  # 2016-08-16: Done
  pending.index <- with(orders, which(State == 'canceled'))
  if (length(pending.index) == 0) return(NULL)
  pending <- orders[pending.index, ]
  with(pending, {
    build.report.tickets.pending.from.columns(
      ticket = Order,
      otime = `Open Time`,
      type = Type,
      volume = Volume,
      item = Symbol,
      oprice = Price,
      sl = `S / L`,
      tp = `T / P`,
      ctime = Time,
      cprice = NA,
      comment = Comment
    )
  })
} # 2016-08-16: Done

file.html.mt5.trade.tickets.money <- function(money) {
  # ''' get money tickets for mt5 html file ''
  # 2016-08-16: Done
  if (is.null(money)) return(NULL)
  with(money, {
    build.report.tickets.money.from.columns(
      ticket = Deal,
      otime = Time,
      profit = Profit,
      comment = Comment
    )
  })
} # 2016-08-16: Done

file.html.mt5.trade.tickets.closed_open <- function(deals.closed_open, positions) {
  # ''' get closed and open tickets for mt5 html file ''
  # 2016-08-16: TESTING
  if (is.null(deals.closed_open)) return(NULL)
  closed_open <- within(deals.closed_open, {
    Time <- reform.time(Time)
    Type <- toupper(Type)
    Volume <- as.numeric(Volume)
    Price <- as.numeric(Price)
    Order <- as.numeric(Order)
  })
  split.item <- split.data.frame(closed_open, closed_open$Symbol)
  do.call(rbind, lapply(split.item, file.html.mt5.trade.tickets.closed_open.symbol, positions))
} # 2016-08-16: TESTING

file.html.mt5.trade_strategy.tickets.money_closed_open <- function(deals, positions = NULL) {
  # ''' get money closed and open tickets for mt5 html file ''
  # 2016-08-17: TESTING
  if (is.null(deals)) return(NULL)
  money.index <- with(deals, which(Type == 'balance'))
  if (length(money.index) == 0) {
    money <- NULL
    closed_open <- deals
  } else {
    money <- deals[money.index, ]
    closed_open <- deals[ - money.index,]
    if (nrow(closed_open) == 0) {
      closed_open <- NULL
    }
  }
  tickets.money <- file.html.mt5.trade.tickets.money(money)
  tickets.closed_open <- file.html.mt5.trade.tickets.closed_open(closed_open, positions)
  rbind(tickets.money, tickets.closed_open)
} # 2016-08-17: TESTING

file.html.mt5.trade.tickets.closed_open.symbol <- function(symbol.trades, positions) {
  # ''' get single symbol closed and open tickets for mt5 html file '''
  # 2016-08-16: TESTING
  in_out.index <- with(symbol.trades, {
    which(Direction == 'in/out')
  })
  if (length(in_out.index) > 0) {
    volume.cumsum <- with(symbol.trades, {
      cumsum(ifelse(Type == 'BUY', Volume, -Volume))
    })
    in.volume.value <- abs(volume.cumsum[in_out.index])
    in_out.tickets <- symbol.trades[in_out.index,]
    other.tickets <- symbol.trades[ - in_out.index,]
    in_out.out <- within(in_out.tickets, {
      Direction <- 'out'
      Volume <- Volume - in.volume.value
      Time <- Time - 1
    })
    in_out.in <- within(in_out.tickets, {
      Direction <- 'in'
      Volume <- in.volume.value
    })
    symbol.trades <- sort.tickets(rbind(other.tickets, in_out.out, in_out.in), 'Deal')
  }
  buy <- symbol.trades$Type == 'BUY'
  buy.index <- which(buy)
  sell.index <- which(!buy)
  in_ <- symbol.trades$Direction == 'in'
  in.index <- which(in_)
  out.index <- which(!in_)
  buy_in.index <- intersect(buy.index, in.index)
  buy_out.index <- intersect(buy.index, out.index)
  sell_in.index <- intersect(sell.index, in.index)
  sell_out.index <- intersect(sell.index, out.index)
  buy.tickets <- file.html.mt5.trade.deals.closed_open.symbol.make.tickets(symbol.trades, buy_in.index, sell_out.index, positions, 'BUY')
  sell.tickets <- file.html.mt5.trade.deals.closed_open.symbol.make.tickets(symbol.trades, sell_in.index, buy_out.index, positions, 'SELL')
  rbind(buy.tickets, sell.tickets)
} # 2016-08-16: TESTING

file.html.mt5.trade.deals.closed_open.symbol.make.tickets <- function(symbol.trades, in.index, out.index, positions, type) {
  # ''' mt5 trade html file tickets '''
  # 2016-08-16: Done
  if (length(in.index) == 0) return(NULL)
  item <- symbol.trades$Symbol[1]
  deals.in <- symbol.trades$Deal[in.index]
  volume.in <- symbol.trades$Volume[in.index]
  deals.out <- symbol.trades$Deal[out.index]
  volume.out <- symbol.trades$Volume[out.index]
  volume.cumsum.in <- cumsum(volume.in)
  volume.cumsum.out <- cumsum(volume.out)
  volume.cumsum <- sort(union(volume.cumsum.in, volume.cumsum.out))
  tickets.in <- sapply(volume.cumsum, function(x) {
    deals.in[which(volume.cumsum.in >= x)[1]]
  })
  tickets.out <- sapply(volume.cumsum, function(x) {
    deals.out[which(volume.cumsum.out >= x)[1]]
  })
  tickets.volume <- c(volume.cumsum[1], diff(volume.cumsum))
  tickets.in.index <- match(tickets.in, symbol.trades$Deal)
  tickets.out.index <- match(tickets.out, symbol.trades$Deal)
  na.check <- is.na(tickets.out.index)
  open.index <- which(na.check)
  closed.index <- which(!na.check)
  if (length(open.index) == 0) {
    tickets.open <- NULL
  } else {
    open.tickets.in.index <- tickets.in.index[open.index]
    tickets.open <- with(symbol.trades, {
      build.report.tickets.open.from.columns(
        ticket = Order[open.tickets.in.index],
        otime = Time[open.tickets.in.index],
        type = type,
        volume = tickets.volume,
        item = item,
        oprice = Price[open.tickets.in.index],
        cprice = positions[item]
      )
    })
  }
  if (length(closed.index) == 0) {
    tickets.closed <- NULL
  } else {
    closed.tickets.in.index <- tickets.in.index[closed.index]
    closed.tickets.out.index <- tickets.out.index[closed.index]
    tickets.closed <- with(symbol.trades, {
      build.report.tickets.closed.from.columns(
        ticket = Order[closed.tickets.in.index],
        otime = Time[closed.tickets.in.index],
        type = type,
        volume = tickets.volume,
        item = item,
        oprice = symbol.trades$Price[closed.tickets.in.index],
        ctime = Time[closed.tickets.out.index],
        cprice = Price[closed.tickets.out.index],
        commission = Commission[closed.tickets.out.index],
        swap = Swap[closed.tickets.out.index],
        profit = NA,
        comment = Comment[closed.tickets.out.index]
      )
    })
    tp.index <- which(tickets.closed$Comment == 'TP')
    sl.index <- which(tickets.closed$Comment == 'SL')
    tickets.closed <- within(tickets.closed, {
      TP[tp.index] <- CPrice[tp.index]
      SL[sl.index] <- CPrice[sl.index]
    })
  }
  rbind(tickets.open, tickets.closed)
} # 2016-08-16: Done

file.html.mt5.trade.tickets.positions.market.price <- function(positions) {
  # ''' handle mt5 trade html positions '''
  # 2016-08-15: Done
  price <- as.numeric(positions$'Market Price')
  names(price) <- positions$Symbol
  price
} # 2016-08-15: Done

#### strategy ####

file.html.mt5.strategy <- function(file.link) {
  # ''' mt5 html strategy file '''
  # 2016-08-16: Working
  require(XML)
  html_table <- readHTMLTable(file.link, stringsAsFactors = FALSE, encoding = 'UTF-8')
  build.report(
    type = 'MT5 - EA',
    tickets = file.html.mt5.strategy.tickets(html_table[[2]]),
    info = file.html.mt5.strategy.info(html_table[[1]])
  )
}

file.html.mt5.strategy.info <- function(info.table) {
  # ''' mt5 html strategy file: info '''
  # 2016-08-16: Done
  labels <- info.table[, 1]
  values <- info.table[, 2]
  time.string <- values[which(grepl('Period', labels))[1]]
  nchar.time.string <- nchar(time.string)
  build.report.info(
    broker = values[which(grepl('Broker', labels))[1]],
    name = values[which(grepl('Expert', labels))[1]],
    time = substr(time.string, nchar.time.string - 10, nchar.time.string - 1),
    currency = values[which(grepl('Currency', labels))[1]],
    leverage = values[which(grepl('Leverage', labels))[1]]
  )
} # 2016-08-16: Done

file.html.mt5.strategy.tickets <- function(tickets.table) {
  # ''' mt5 html strategy file: tickets '''
  # 2016-08-17: ToDo: 'end of test'
  first_col <- tickets.table[, 1]
  spaces_index <- which(first_col == '')
  deals <- file.html.mt5.trade_strategy.tickets.group(tickets.table, first_col, spaces_index, 'Deals')
  file.html.mt5.trade_strategy.tickets.money_closed_open(deals)
  build.report.tickets.group(
    closed = file.html.mt5.trade_strategy.tickets.money_closed_open(deals)
  )
} # 2016-08-17: ToDo

require(quantmod)