library(colordistance)

img <- system.file("extdata","data/07/me.jpg", package = "colordistance")
colordistance::plotPixels(img, lower=NULL, upper=NULL)


path <- system.file("data/07/me.jpg")
img <- colordistance::loadImage(path, lower = rep(0.8, 3), upper = rep(1, 3),
                                CIELab = TRUE, ref.white = "D65", sample.size = 10000)
