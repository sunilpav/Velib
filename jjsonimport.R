

require(jsonlite)
library(mongolite)

?readLines
# le document initial est compos? de plusieurs doc JSON
Histo <- readLines(file("data_all_Paris.jjson.txt"))
# on applique le fonction FROMJSON a chaque doc JSON, pour les transformer en DataFrame
Histo <- lapply(Histo,jsonlite::fromJSON)
# Histo est alors une liste de DataFrame
# Histo[1] : liste d'un seul ?lement
# Histo[[1]] : dataFrame

# pour obtenir un dataFrame de toutes les dataFrame
HistoDT <- do.call('rbind',Histo)
str(HistoDT)
