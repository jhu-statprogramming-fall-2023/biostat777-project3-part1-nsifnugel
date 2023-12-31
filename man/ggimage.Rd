% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ggimage.R
\name{ggimage}
\alias{ggimage}
\title{Plot an image using ggplot2}
\usage{
ggimage(mat, fullpage = TRUE, coord_equal = TRUE, scale_axes = FALSE)
}
\arguments{
\item{mat}{a matrix, imagematrix, array, or raster (something
that can be coerced by as.raster)}

\item{fullpage}{should the image take up the entire viewport?}

\item{coord_equal}{should the axes units be equal?}

\item{scale_axes}{should the axes be
(0,ncol(mat)-1)x(0,nrow(mat)-1) (F) or (0,1)x(0,1) (T)}
}
\value{
a ggplot object
}
\description{
ggimage is the near ggplot2 equivalent of image.
}
\examples{

img <- matrix(1:16, 4, 4)
image(img)
ggimage(t(img[,4:1]), fullpage = FALSE, scale_axes = TRUE)
ggimage(t(img[,4:1]), fullpage = FALSE)


\dontrun{
# not run due to slow performance

data(hadley)
ggimage(hadley)
ggimage(hadley, coord_equal = FALSE)

x <- seq(1, 438, 15); n <- length(x)
df <- data.frame(x = x, y = -(120*(scale((x - 219)^3 - 25000*x) + rnorm(n)/2 - 3)))
qplot(x, y, data = df, geom = c('smooth','point'))
ggimage(hadley, fullpage = FALSE) +
  geom_smooth(
    aes(x = x, y = y),
    data = df, color = 'green', size = 1
  ) +
  geom_point(
    aes(x = x, y = y),
    data = df, color = 'green', size = 3
  )

}
}
\author{
David Kahle \email{david@kahle.io}
}
