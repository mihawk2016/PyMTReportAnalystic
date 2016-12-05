# '' ' report info builder functions' ''
# 2016-08-16: Create



reform.report.info.account <- function(account) {
  # ''' reform report info: account '''
  # 2016-08-16: TESTING
  if (is.na(account) | is.numeric(account)) return(account)
  if (is.character(account)) {
    account <- gsub('Account: ', '', account)
    match1 <- regexpr('[[:digit:]]*', account)
    if (match1 > 0) {
      account <- substr(account, match1, attr(match1, 'match.length') + match1 - 1)
    }
    return(as.numeric(account))
  }
  print('ERROR: in reform.report.info.account()')
  NA
} # 2016-08-16: TESTING

reform.report.info.name <- function(name) {
  # ''' reform report info: name '''
  # 2016-08-16: TESTING
  if (is.na(name)) return(NA)
  name <- gsub('Name: ', '', name)
  ifelse(name == '', NA, name)
} # 2016-08-16: TESTING

reform.report.info.broker <- function(broker) {
  # ''' reform report info: broker '''
  # 2016-08-16: TESTING
  if (is.na(broker)) return(NA)
  gsub(' .*', '', broker)
} # 2016-08-16: TESTING

reform.report.info.currency <- function(currency) {
  # ''' reform report info: currency '''
  # 2016-08-16: TESTING
  if (is.na(currency)) return(NA)
  currency <- gsub('Currency: ', '', currency)
  match1 <- regexpr('[[:upper:]]+', currency)
  if (match1 > 0) {
    currency <- substr(currency, match1, attr(match1, 'match.length') + match1 - 1)
  }
  ifelse(currency == '', NA, currency)
} # 2016-08-16: TESTING

reform.report.info.leverage <- function(leverage) {
  # ''' reform report info: leverage '''
  # 2016-08-16: TESTING
  if (is.na(leverage) | is.numeric(leverage)) return(leverage)
  if (is.character(leverage)) {
    match1 <- regexpr('1:[[:digit:]]+', leverage)
    if (match1 > 0) {
      leverage <- substr(leverage, match1 + 2, attr(match1, 'match.length') + match1 - 1)
    }
    return(as.numeric(leverage))
  }
  print('ERROR: in reform.report.info.leverage()')
  NA
} # 2016-08-16: TESTING

reform.report.info.time <- function(time) {
  # ''' reform report info: time '''
  # 2016-08-16: TESTING
  reform.time(time)
} # 2016-08-16: TESTING

#-----------------------------------