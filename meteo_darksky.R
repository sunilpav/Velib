require(jsonlite)
require(RCurl)
require(curl)
library(RCurl)
install.packages("darksky")
library(darksky)
install.packages("purrr")
library(purrr)
install.packages("RJSONIO")
library(RJSONIO)
library(plyr)


#url <- 'https://api.darksky.net/forecast/9778cdc6ddc2eaf7b6854ad412c21eec/48.866667,2.333333'
#now <- get_current_forecast(48.866667, 2.333333)

#darksky_api_key <- "9778cdc6ddc2eaf7b6854ad412c21eec"

#tmp <- get_forecast_for(48.866667,2.333333,"2016-08-01T12:00:00",units="si",language = "fr")
#tmp1<-as.data.frame(tmp)


#lancer 1 prremiere fois. demande de clé dans console. rentrer clé et relancer

#########
date.range <- seq.Date(from=as.Date('2016-11-01'), to=as.Date('2016-11-30'), by='1 day')
date.range


hdwd <- data.frame()

for(i in seq_along(date.range)) {
  tmp<-get_forecast_for(48.866667,2.333333,paste(date.range[i],'T12:00:00',sep=""),units="si",language = "fr")
  tmp1<-as.data.frame(tmp)
  tmp2<-data.frame(tmp1$hourly.time,tmp1$hourly.summary,tmp1$hourly.precipIntensity,tmp1$hourly.temperature)
  hdwd <- rbind(hdwd,tmp2)
}


