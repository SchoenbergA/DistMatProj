# set folder
path <- "C:/Envimaster/DistMat" # local path to data

alps <- read.csv(file.path(path,"Alpine_tests.csv"))
flat <- read.csv(file.path(path,"Flachland_tests.csv"))
terr <- read.csv(file.path(path,"Gelände_tests.csv"))


test <- order(alps$fromTo)

# cor test from to and reverse for osm vs google
cor(alps$fromTo,alps$fromTo_google)
cor(alps$reverse,alps$reverse_google)
cor(flat$fromTo,flat$fromTo_google)
cor(flat$reverse,flat$reverse_google)
cor(terr$fromTo,terr$fromTo_google)
cor(terr$reverse,terr$reverse_google)

# plot
plot(alps$fromTo,alps$fromTo_google)
plot(alps$reverse,alps$reverse_google)
plot(flat$fromTo,flat$fromTo_google)
plot(flat$reverse,flat$reverse_google)
plot(terr$fromTo,terr$fromTo_google)
plot(terr$reverse,terr$reverse_google)

# lm
l_alp <- lm(alps$fromTo~alps$fromTo_google)
l_alp_r<- lm(alps$reverse~alps$reverse_google)
l_flat<- lm(flat$fromTo~flat$fromTo_google)
l_flat_r<- lm(flat$reverse~flat$reverse_google)
l_terr<- lm(terr$fromTo~terr$fromTo_google)
l_terr_r<- lm(terr$reverse~terr$reverse_google)

# plot with lm

plot(alps$fromTo~alps$fromTo_google)
abline(l_alp,col="green")
lines(alps$fromTo~alps$fromTo_google)

plot(alps$reverse,alps$reverse_google)
abline(l_alp_r,col="green")
lines(alps$reverse,alps$reverse_google)

plot(flat$fromTo,flat$fromTo_google)
abline(l_flat,col="green")
lines(flat$fromTo,flat$fromTo_google)

plot(flat$reverse,flat$reverse_google)
abline(l_flat_r,col="green")
lines(flat$reverse,flat$reverse_google)

plot(terr$fromTo,terr$fromTo_google)
abline(l_terr,col="green")
lines(terr$fromTo,terr$fromTo_google)

plot(terr$reverse~terr$reverse_google)
abline(l_terr_r,col="green")
lines(terr$reverse,terr$reverse_google)

# other
plot(terr$fromTo,col= "green")
points(terr$fromTo_google, col="orange")
lines(terr$fromTo,col= "green")
lines(terr$fromTo_google, col="orange")
lines((terr$fromTo+terr$fromTo_google/2, col="red")

plot(terr$reverse,terr$reverse_google)
abline(lm(terr$reverse~terr$reverse_google,data = terr),col="green")
lines(terr$reverse,terr$reverse_google)

plot(l_terr)


terr$reverse+terr$reverse_google/2


plot(l_flat)
plot(alps$fromTo,alps$fromTo_google)
abline(alp_l,col="green",)
