
#PROJET MONUMENTalVELIB
#Participants: Laurent Camus - Severine Castor - Sunil Pavitrin - Maxime Ponsart
#V1: atelier R 31/01
#humeur des participants: Jovial

install.packages("jsonlite")
library(jsonlite)


?readLines
# le document initial est compos? de plusieurs doc JSON

Histo_velib <- readLines(file("E:/data_all_Paris.jjson.txt"))
# on applique le fonction FROMJSON a chaque doc JSON, pour les transformer en DataFrame
Histo_velib <- lapply(Histo_velib,jsonlite::fromJSON)


# pour obtenir un dataFrame de toutes les dataFrame
HistoDT <- do.call('rbind',Histo_velib)
HistoDT$date <- as.POSIXct(HistoDT$download_date, origin="1970-01-01")
HistoDT$jour<- weekdays(as.Date(HistoDT$date))
HistoDT$mois<- months(as.Date(HistoDT$date))


#a faire: creation variable "heure" avec fonction "si > 30min, passer a l'heure suivante



# Classification des stations par jour
moy_jour<- aggregate(available_bikes ~ number+jour,
                  HistoDT, 
                  FUN=mean,
                  na.rm=T)
names(moy_location)
moy_location<- merge(velib2,moy_jour, by="number")
moy_location_lundi<- moy_location[which(moy_location$jour=="lundi"),] 

library(ggmap)
map.Decaux <- get_map(c(lon=2.35,lat=48.86), zoom =12,  maptype = "roadmap")
ggmap(map.Decaux)
map.Decaux <- ggmap(map.Decaux, extent = "device")
map.Decaux + geom_point(data = moy_location_lundi, aes(x = longitude, y = latitude))
map.Decaux + geom_point(data = moy_location_lundi, aes(x = longitude,
                                           y = latitude,size=available_bikes.y))



