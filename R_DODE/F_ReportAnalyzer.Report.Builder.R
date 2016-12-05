# ''' build report functions '''
# 2016-08-16: Create

build.report <- function(tickets, info, type = NULL) {
  # ''' build report '''
  # 2016-08-14: Done
  list(
    Tickets = report.tickets.add.mode(tickets, type),
    Info = info,
    Type = type
  )
} # 2016-08-16: Done

report.tickets.add.mode <- function(tickets, type) {
  # ''' tickets add mode for recalculate '''
  # 2016-08-18: ToDo: for xlsx or database
  mode <- character(nrow(tickets))
  if (type == 'MT4 - EA') {
    closed.index <- which(tickets$Group == 'CLOSED')
    mode[closed.index] <- 'sp'
  } else if (grepl('MT5', type)) {
    closed_open.index <- which(tickets$Group %in% c('CLOSED', 'OPEN'))
    mode[closed_open.index] <- 'p'
  }
  within(tickets, Mode <- mode)
} # 2016-08-18: ToDo
