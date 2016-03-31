farbenfroh_get <- function(color_scheme = "wes_b_fave") {
jsonlite::fromJSON(httr::content(httr::GET(paste0("https://raw.githubusercontent.com/vsbuffalo/farbenfroh/master/",color_scheme ,".json")), as = 'text'))
}

colorz <- farbenfroh_get()
library(ggplot2)
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
  geom_point(size = 3) + 
  scale_color_manual(values = colorz$colors) + 
  theme_gray()


