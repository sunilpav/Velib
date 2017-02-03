#prerequis: avoir les 2 tables 
#stations-velib-disponibilites-en-temps-reel.csv
#data_all_Paris.jjson.txt

#PROJET MONUMENTalVELIB
#Participants: Laurent Camus - Severine Castor - Sunil Pavitrin - Maxime Ponsart
#V1: atelier R 31/01
#humeur des participants: 


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



# moyenne des velo disponible par jour et station
moy_jour<- aggregate(available_bikes ~ number+jour,
                     HistoDT, 
                     FUN=mean,
                     na.rm=T)
names(moy_location)

#a faire: creation variable "heure" avec fonction "si > 30min, passer a l'heure suivante





#importation table temps_reel (longitude/latitude) pour ggogle maps

#setwd a changer
setwd("//telemaque/Usergroupes/CEPE-FORMATION/Salle 1/TP3101")
velib2<-read.csv("stations-velib-disponibilites-en-temps-reel.csv",
                 sep=";")
names(velib2)
hist(velib2$bike_stands,freq=FALSE,xlab="Taille",main="Hist. de la taille des stations")
lines(density(velib2$bike_stands),lwd=2,col=2)
position <- as.character(velib2$position)
vecteur <- do.call('rbind',strsplit(position,',',fixed=TRUE))
velib2$longitude <- as.numeric(vecteur[,2])
velib2$latitude <- as.numeric(vecteur[,1])
plot(latitude~longitude,data=velib2,cex=.2)


# MERGE TABLE nov2016 avec table longitude/latitude

moy_location<- merge(velib2,moy_jour, by="number")
moy_location_lundi<- moy_location[which(moy_location$jour=="lundi"),] 

library(ggmap)
map.Decaux <- get_map(c(lon=2.35,lat=48.86), zoom =12,  maptype = "roadmap")
ggmap(map.Decaux)
map.Decaux <- ggmap(map.Decaux, extent = "device")
map.Decaux + geom_point(data = moy_location_lundi, aes(x = longitude, y = latitude))
map.Decaux + geom_point(data = moy_location_lundi, aes(x = longitude,
                                                       y = latitude,size=available_bikes.y))





# fin du programme de E.Maznner sur porjection temps reel velib. (pas utilisé pour l'instant)
library(leaflet)

ColorPal <- colorNumeric(scales::seq_gradient_pal(low = "#132B43", high = "#56B1F7", space = "Lab"), domain = c(0,1))
m <- leaflet(data = velib2) %>%
  addTiles() %>%
  addCircles(~ longitude, ~ latitude, popup = ~ sprintf("<b> Available bikes: %s</b>",as.character(available_bikes)),
             radius = ~ sqrt(bike_stands),
             color = ~ ColorPal( available_bikes / (available_bikes + available_bike_stands)),
             stroke = TRUE, fillOpacity = 0.75)







m