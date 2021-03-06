test.cut.mondate <- function() {

  #require(RUnit)
  y <- cut(mondate(12:24), breaks = 12:24)
  checkEquals(length(levels(y)), 12)

  # mondate

  (x <- mondate(0:4))
  (y <- cut(x, x))
  checkEquals(levels(y), c("(12/31/1999,01/31/2000]","(01/31/2000,02/29/2000]",
                           "(02/29/2000,03/31/2000]","(03/31/2000,04/30/2000]"))
  (y <- cut(x, x, right = FALSE))
  checkEquals(levels(y), c("[12/31/1999,01/31/2000)","[01/31/2000,02/29/2000)",
                           "[02/29/2000,03/31/2000)","[03/31/2000,04/30/2000)"))

  # 4 levels of unit width.
  (y <- cut.mondate(x, breaks = 4, attr.breaks = TRUE))
  checkTrue(is.na(y[1]))
  checkEquals(levels(y), c("(12/31/1999,01/31/2000]", "(01/31/2000,02/29/2000]", "(02/29/2000,03/31/2000]", "(03/31/2000,04/30/2000]"))
  (y <- cut.mondate(x, breaks = 4, include.lowest = TRUE, attr.breaks = TRUE))
  checkTrue(!is.na(y[1]))
  checkEquals(levels(y), c("[12/31/1999,01/31/2000]", "(01/31/2000,02/29/2000]", "(02/29/2000,03/31/2000]", "(03/31/2000,04/30/2000]"))

  (y <- cut(x, attr(y, "breaks"), right = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), c("[12/31/1999,01/31/2000]", "(01/31/2000,02/29/2000]", "(02/29/2000,03/31/2000]", "(03/31/2000,04/30/2000]"))
  
  # "weeks"
  #3/30/2014 is a Sunday
  (x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:30)))
  (y <- cut.mondate(x, "weeks", right = TRUE,
                    include.lowest = TRUE, start.on.monday = TRUE))
  checkEquals(levels(y), c("03/30/2014", "04/06/2014", "04/13/2014", 
                           "04/20/2014", "04/27/2014", "05/04/2014"))
  (y <- cut.mondate(x, "weeks", right = FALSE, 
                    include.lowest = TRUE, start.on.monday = TRUE))
  # this time s/b labeled with the first day of the week, all mondays
  checkEquals(levels(y), c("03/24/2014", "03/31/2014", "04/07/2014", 
                           "04/14/2014", "04/21/2014", "04/28/2014"))

  x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:25))
  (y <- cut.mondate(x, "2 weeks", right = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), c("03/30/2014", "04/13/2014", "04/27/2014"))
  (y <- cut.mondate(x, "2 weeks", right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), c("03/24/2014", "04/07/2014", "04/21/2014"))
  
  #3/30/2014 is a Sunday
  (x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:30)))
  (y <- cut.mondate(x, "weeks", right = TRUE,
                    include.lowest = TRUE, start.on.monday = FALSE))
  checkEquals(levels(y), c("04/05/2014", "04/12/2014", "04/19/2014", 
                           "04/26/2014", "05/03/2014"))
  (y <- cut.mondate(x, "weeks", right = FALSE, 
                    include.lowest = TRUE, start.on.monday = FALSE))
  # this time s/b labeled with the first day of the week, all mondays
  checkEquals(levels(y), c("03/30/2014", "04/06/2014", 
                           "04/13/2014", "04/20/2014", "04/27/2014"))
  
  x <- c(mondate.ymd(2014, 3, 30:31), mondate.ymd(2014, 4, 1:25))
  (y <- cut.mondate(x, "2 weeks", right = TRUE, 
                    include.lowest = TRUE, start.on.monday = FALSE))
  checkEquals(levels(y), c("04/12/2014", "04/26/2014"))
  (y <- cut.mondate(x, "2 weeks", right = FALSE, 
                    include.lowest = TRUE, start.on.monday = FALSE))
  checkEquals(levels(y), c("03/30/2014", "04/13/2014"))
}
test.cut.mondate.Date <- function() {
  (x <- as.Date(c("2015-11-06", "2015-11-07", "2015-11-08")))
  (y <- cutmondate(x))
  checkEquals(levels(y), "2015-11-01")
  (y <- cutmondate(x, breaks = 3))
  checkEquals(levels(y), c("2015-11-06", "2015-11-07", "2015-11-08"))
  (y <- cutmondate(x, breaks = "weeks", start.on.monday = FALSE))
  checkEquals(levels(y), c("2015-11-01", "2015-11-08"))
  (y <- cutmondate(x, breaks = "weeks", start.on.monday = TRUE))
  checkEquals(levels(y), "2015-11-02")
  (y <- cutmondate(mondate(x)))
  checkEquals(levels(y), "11/30/2015") # Demo the month-end default for mondate's
  
  # Demo POSIXt's .. s/b just like Date's
  (u <- cutmondate(x))
  (v <- cutmondate(as.POSIXct(x)))
  checkTrue(identical(u, v))
  (v <- cutmondate(as.POSIXlt(x)))
  checkTrue(identical(u, v))
}
test.cut.mondate.days <- function() {
  # "days"
  x <- mondate.ymd(2014, 4, c(1, 7))
  (y <- cut.mondate(x, "days", attr.breaks = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), c("04/01/2014", "04/02/2014", "04/03/2014", "04/04/2014", 
                           "04/05/2014", "04/06/2014", "04/07/2014"))
  (y <- cut.mondate(x, "days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/02/2014", "04/03/2014", 
                           "04/04/2014", "04/05/2014", "04/06/2014", 
                           "04/07/2014"))

  x <- mondate.ymd(2014, 4, c(1, 8))
  (y <- cut.mondate(x, "days", attr.breaks = TRUE, include.lowest = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/02/2014", "04/03/2014", 
                           "04/04/2014", "04/05/2014", "04/06/2014", 
                           "04/07/2014", "04/08/2014"))

  (y <- cut.mondate(x, "days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/02/2014", "04/03/2014", "04/04/2014", "04/05/2014", "04/06/2014", "04/07/2014", "04/08/2014"))

  x <- mondate.ymd(2014, 4, c(1, 7))
  (y <- cut.mondate(x, "2 days", attr.breaks = TRUE, include.lowest = TRUE))
  # old behavior was that the starting value was always min(x) even
  #   when right. Now when right, ending value always max(x)
  # checkEquals(as.character(y), c(NA, "04/08/2014"))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
  # checkEquals(levels(y), c("04/04/2014", "04/06/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/03/2014", "04/05/2014", "04/07/2014"))

  (y <- cut.mondate(x, "2 days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
  checkEquals(levels(y), c("04/01/2014", "04/03/2014", "04/05/2014", "04/07/2014"))

  x <- mondate.ymd(2014, 4, c(1, 8))
  (y <- cut.mondate(x, "2 days", attr.breaks = TRUE, include.lowest = TRUE))
  checkEquals(as.character(y), c("04/02/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/02/2014", "04/04/2014", "04/06/2014", "04/08/2014"))

  (y <- cut.mondate(x, "2 days", include.lowest = TRUE, attr.breaks = TRUE))
  checkEquals(as.character(y), c("04/02/2014", "04/08/2014"))
  checkEquals(levels(y), c("04/02/2014", "04/04/2014", "04/06/2014", "04/08/2014"))
  checkEqualsNumeric(attr(y, "breaks"), mondate(c("03/31/2014", "04/02/2014", 
                                                  "04/04/2014", "04/06/2014", 
                                                  "04/08/2014")))

  x <- mondate.ymd(2014, 4, c(1, 7))
  (y <- cut.mondate(x, "days", right = FALSE, attr.breaks = TRUE, include.lowest = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
  (z <- cut.mondate(x, attr(y, "breaks"), right = FALSE))
  (z <- cut.mondate(x, attr(y, "breaks"), right = FALSE, include.lowest = TRUE))
  checkEquals(as.character(z), c("[04/01/2014,04/02/2014)", 
                                 "[04/07/2014,04/08/2014]"))
  (y <- cut.mondate(x, "days", right = FALSE, include.lowest = TRUE))
  checkEquals(as.character(y), c("04/01/2014", "04/07/2014"))
}
test.cut.mondate.months <- function() {
  (x <- mondate(0:4))
  (y <- cut(x, "months", include.lowest = TRUE))
  checkEquals(levels(y), c("12/31/1999", "01/31/2000", "02/29/2000", 
                           "03/31/2000", "04/30/2000"))
  (y <- cut(x, "months", right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), c("12/01/1999", "01/01/2000", "02/01/2000", 
                           "03/01/2000", "04/01/2000"))
  (y <- cut(x, "months", right = TRUE, include.lowest = TRUE, attr.breaks = TRUE))
  checkEqualsNumeric(attr(y, "breaks"), mondate(-1:4))
  
  # Test for non-NA when scalar x on month boundary
  (x <- mondate.ymd(2008, 6))
  (y <- cut(x, "month", right = TRUE, include.lowest = TRUE))
  checkTrue(!is.na(y))
  checkEquals(levels(y), "06/30/2008")
  (y <- cut(x, "month", right = FALSE, include.lowest = TRUE))
  checkTrue(!is.na(y))
  checkEquals(levels(y), "06/01/2008")
  
  (x <- mondate.ymd(2015, 1:12))
  (y <- cut(x, "2 month", right = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), c("02/28/2015", "04/30/2015", "06/30/2015", 
                           "08/31/2015", "10/31/2015", "12/31/2015"))
  (y <- cut(x, "2 month", right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), c("01/01/2015", "03/01/2015", "05/01/2015", 
                           "07/01/2015", "09/01/2015", "11/01/2015"))
  
  # labels
  x <- mondate.ymd(2015, 1:12)
  (y <- cut(x, "2 month", labels = LETTERS[1:6],
            right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), c("A", "B", "C", "D", "E", "F"))
  
}
test.cut.mondate.years <- function() {
  (x <- mondate.ymd(2004:2008, 6, 15))
  (y <- cut(x, "years", include.lowest = TRUE))
  checkEquals(levels(y), as.character(mondate.ymd(2004:2008, 6)))
  (y <- cut(x, "years", startmonth = 1, include.lowest = TRUE))  
  checkEquals(levels(y), c("12/31/2004", "12/31/2005", "12/31/2006", 
                           "12/31/2007", "12/31/2008"))
  (y <- cut(x, "years", right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), c("06/01/2004", "06/01/2005", "06/01/2006", 
                           "06/01/2007", "06/01/2008"))
  (y <- cut(x, "years", right = FALSE, startmonth = 1, include.lowest = TRUE))
  checkEquals(levels(y), c("01/01/2004", "01/01/2005", "01/01/2006", 
                           "01/01/2007", "01/01/2008"))
  (y <- cut(x, "2 years", right = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), c("06/30/2004", "06/30/2006", "06/30/2008"))
  # test an odd fiscal year
  (y <- cut(x, "years", right = FALSE, startmonth = 12, include.lowest = TRUE))
  checkEquals(levels(y), c("12/01/2003", "12/01/2004", "12/01/2005", "12/01/2006", 
                           "12/01/2007"))
  (y <- cut(x, "2 years", right = TRUE, startmonth = 1, include.lowest = TRUE))
  checkEquals(levels(y), c("12/31/2004", "12/31/2006", "12/31/2008"))
  (y <- cut(x, "years", right = TRUE, startmonth = 1, include.lowest = TRUE, 
            attr.breaks = TRUE))
  checkEqualsNumeric(attr(y, "breaks"), mondate.ymd(2003:2008))
  # Test for non-NA when scalar x on year boundary
  (x <- mondate.ymd(2008))
  checkException((y <- cut(x, "years", right = TRUE)))
  (y <- cut(x, "years", right = TRUE, include.lowest = TRUE))
  checkTrue(!is.na(y))
  checkEquals(levels(y), "12/31/2008")
  (y <- cut(x, "years", right = FALSE, include.lowest = TRUE))
  checkTrue(!is.na(y))
  checkEquals(levels(y), "12/01/2008")
  (y <- cut(x, "years", right = FALSE, include.lowest = TRUE, startmonth = 1))
  checkTrue(!is.na(y))
  checkEquals(levels(y), "01/01/2008")
  
  # demo recut with breaks as might occur with Date's
  (x <- mondate.ymd(2000:2015, 6, 15))
  (res <- cut(x, "year", right = FALSE, include.lowest = TRUE, 
              startmonth = 1, attr.breaks = TRUE))
  (b <- as.Date(attr(res, "breaks")) + 1)
  (u <- cut(as.Date(x), b))
  (v <- cut(as.Date(x), "year"))
  checkTrue(identical(u, v))
  
  (res <- cut(x, "2 year", right = FALSE, include.lowest = TRUE, 
              startmonth = 1, attr.breaks = TRUE))
  (b <- as.Date(attr(res, "breaks")) + 1)
  (u <- cut(as.Date(x), b))
  (v <- cut(as.Date(x), "2 year"))
  checkTrue(identical(u, v))
  
  # Check July - June fiscal year
  (x <- mondate.ymd(2010:2015, 6, 15))
  (res <- cut(x, "year", right = TRUE, include.lowest = TRUE, startmonth = 7))
  checkEquals(
    levels(res)
    , c("06/30/2010", "06/30/2011", "06/30/2012", 
        "06/30/2013", "06/30/2014", "06/30/2015"))
  (res <- cut(x, "year", right = FALSE, include.lowest = TRUE, startmonth = 7))
  checkEquals(
    levels(res)
    , c("07/01/2009", "07/01/2010", "07/01/2011", 
        "07/01/2012", "07/01/2013", "07/01/2014"))
  (res <- cut(x, "2 year", right = TRUE, include.lowest = TRUE, startmonth = 7))
  checkEquals(
    levels(res)
    , c("06/30/2011", "06/30/2013", "06/30/2015"))
  (res <- cut(x, "2 year", right = FALSE, include.lowest = TRUE, startmonth = 7))
  checkEquals(
    levels(res)
    , c("07/01/2009", "07/01/2011", "07/01/2013"))

  # test "decades"
  x <- mondate.ymd(1995:2012, 6, 15)
  (res <- cut(x, "10 years", right = FALSE, include.lowest = TRUE, 
              startmonth = 7, startyear = 1990))
  checkEquals(
    levels(res)
    , c("07/01/1990", "07/01/2000", "07/01/2010"))

  # startyear in middle of data, so lots of NA's
  (res <- cut(x, "10 years", right = FALSE, include.lowest = TRUE, 
              startmonth = 7, startyear = 2000))
  checkTrue(all(is.na(res[1:6])))
  checkEquals(
    levels(res)
    , c("07/01/2000", "07/01/2010"))
  # startyear not given, so left endpoint of first period when "left" (!right), 
  #   right endpoint last year when right
  (res <- cut(x, "10 years", right = FALSE, include.lowest = TRUE, 
              startmonth = 7))
  checkEquals(
    levels(res)
    , c("07/01/1994", "07/01/2004"))
  (res <- cut(x, "10 years", right = TRUE, include.lowest = TRUE, 
              startmonth = 7))
  checkEquals(
    levels(res)
    , c("06/30/2002", "06/30/2012"))
  
}
test.cut.mondate.quarters <- function() {
  (x <- mondate.ymd(2015, 1:12, 15))
  (y <- cut(x, "quarters", include.lowest = TRUE))
  checkEquals(levels(y), c("03/31/2015", "06/30/2015", "09/30/2015", "12/31/2015"))
  (y <- cut(x, "quarters", right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), c("01/01/2015", "04/01/2015", "07/01/2015", "10/01/2015"))
  (y <- cut(x, "2 quarters", right = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), c("06/30/2015", "12/31/2015"))
  (y <- cut(x, "2 quarters", right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), c("01/01/2015", "07/01/2015"))
  (y <- cut(x, "quarters", right = TRUE, include.lowest = TRUE, attr.breaks = TRUE))
  checkEqualsNumeric(attr(y, "breaks"), mondate.ymd(2014) + 3*(0:4))
  # Test for non-NA when scalar x on year boundary
  (x <- mondate.ymd(2008))
  (y <- cut(x, "quarters", right = TRUE, include.lowest = TRUE))
  checkEquals(levels(y), "12/31/2008")
  (y <- cut(x, "quarters", right = FALSE, include.lowest = TRUE))
  checkEquals(levels(y), "12/01/2008")
  (y <- cut(x, "quarters", right = FALSE, startmonth = 1, include.lowest = TRUE))
  checkEquals(levels(y), "10/01/2008")
  # demo recut with breaks as might occur with Date's
  (x <- mondate.ymd(2000:2015, 6, 15))
  (res <- cut(x, "quarters", right = FALSE, startmonth = 1, 
              include.lowest = TRUE, attr.breaks = TRUE))
  (b <- as.Date(attr(res, "breaks")) + 1)
  (u <- cut(as.Date(x), b))
  (v <- cut(as.Date(x), "quarter"))
  checkTrue(identical(u, v))
  
  # Check July - June fiscal year
  (x <- mondate.ymd(2010:2015, 6, 15))
  (res <- cut(x, "quarters", right = TRUE, include.lowest = TRUE, startmonth = 7))
  checkEquals(
    as.character(res)
    , c("06/30/2010", "06/30/2011", "06/30/2012", 
        "06/30/2013", "06/30/2014", "06/30/2015"))
  checkEquals(length(levels(res)), 21)
  (res <- cut(x, "quarters", right = FALSE, include.lowest = TRUE, startmonth = 7))
  checkEquals(
    as.character(res)
    , c("04/01/2010", "04/01/2011", "04/01/2012", 
        "04/01/2013", "04/01/2014", "04/01/2015"))
  checkEquals(length(levels(res)), 21)
  (res <- cut(x, "2 quarters", right = FALSE, include.lowest = TRUE, startmonth = 7))
  checkEquals(length(levels(res)), 11)
  checkEquals(
    levels(res)[c(1:5, 11)]
    , c("01/01/2010", "07/01/2010", "01/01/2011", 
        "07/01/2011", "01/01/2012", "01/01/2015"))
  
  # Force the beginning to be in 2009
  (res <- cut(x, "2 quarters", right = FALSE, include.lowest = TRUE, 
              startmonth = 7, startyear = 2009))
  checkEquals(
    levels(res)
    , c(
      "07/01/2009", "01/01/2010", "07/01/2010", "01/01/2011", "07/01/2011", "01/01/2012",
      "07/01/2012", "01/01/2013", "07/01/2013", "01/01/2014", "07/01/2014", "01/01/2015"))
  (res <- cut(x, "2 quarters", right = TRUE, include.lowest = TRUE, 
              startmonth = 7, startyear = 2009))
  checkEquals(
    levels(res)
    , c(
      "12/31/2009", "06/30/2010", "12/31/2010", "06/30/2011", "12/31/2011", "06/30/2012",
      "12/31/2012", "06/30/2013", "12/31/2013", "06/30/2014", "12/31/2014", "06/30/2015"))
  
}
