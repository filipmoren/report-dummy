# here i define define all customers that should get a report.
# there's also some settings for each customer

customers <- list()

customers$customer1$departments <- c("dep1", "dep2")

customers$customer1$settings <- data_frame(currency = "EUR",
                                           companyFullName = "Example Inc.",
                                           settingSomething = TRUE,
                                           lang = "fr", 
                                           excludeWeekends = TRUE)

customers$customer2$departments <- c("dep1", "dep2")

customers$customer2$settings <- data_frame(currency = "USD",
                                           companyFullName = "INC. Example",
                                           settingSomething = FALSE,
                                           lang = "en", 
                                           excludeWeekends = FALSE)

