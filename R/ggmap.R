#' Plot a ggmap object
#'
#' ggmap plots the raster object produced by [get_map()].
#'
#' @param ggmap an object of class ggmap (from function get_map)
#' @param extent how much of the plot should the map take up? "normal",
#'   "device", or "panel" (default)
#' @param base_layer a ggplot(aes(...), ...) call; see examples
#' @param maprange logical for use with base_layer; should the map define the x
#'   and y limits?
#' @param legend "left", "right" (default), "bottom", "top", "bottomleft",
#'   "bottomright", "topleft", "topright", "none" (used with extent = "device")
#' @param padding distance from legend to corner of the plot (used with legend,
#'   formerly b)
#' @param darken vector of the form c(number, color), where number is in (0,1)
#'   and color is a character string indicating the color of the darken.  0
#'   indicates no darkening, 1 indicates a black-out.
#' @param b Deprecated, renamed to `padding`. Overrides any `padding` argument.
#' @param fullpage Deprecated, equivalent to `extent = "device"` when `TRUE`.
#'   Overrides any `extent` argument.
#' @param expand Deprecated, equivalent to `extent = "panel"` when `TRUE` and
#'   `fullpage` is `FALSE`. When `fullpage` is `FALSE` and `expand` is `FALSE`,
#'   equivalent to `extent="normal"`. Overrides any `extent` argument.
#' @param ... ...
#' @return a ggplot object
#' @author David Kahle \email{david@@kahle.io}
#' @seealso [get_map()], [qmap()]
#' @export ggmap inset inset_raster
#' @examples
#'
#' \dontrun{## map queries drag R CMD check
#'
#'
#' ## extents and legends
#' ##################################################
#' hdf <- get_map("houston, texas")
#' ggmap(hdf, extent = "normal")
#' ggmap(hdf) # extent = "panel", note qmap defaults to extent = "device"
#' ggmap(hdf, extent = "device")
#'
#'
#'
#' # make some fake spatial data
#' mu <- c(-95.3632715, 29.7632836); nDataSets <- sample(4:10,1)
#' chkpts <- NULL
#' for(k in 1:nDataSets){
#'   a <- rnorm(2); b <- rnorm(2);
#'   si <- 1/3000 * (outer(a,a) + outer(b,b))
#'   chkpts <- rbind(
#'     chkpts,
#'     cbind(MASS::mvrnorm(rpois(1,50), jitter(mu, .01), si), k)
#'   )
#' }
#' chkpts <- data.frame(chkpts)
#' names(chkpts) <- c("lon", "lat","class")
#' chkpts$class <- factor(chkpts$class)
#' qplot(lon, lat, data = chkpts, colour = class)
#'
#' # show it on the map
#' ggmap(hdf, extent = "normal") +
#'   geom_point(aes(x = lon, y = lat, colour = class), data = chkpts, alpha = .5)
#'
#' ggmap(hdf) +
#'   geom_point(aes(x = lon, y = lat, colour = class), data = chkpts, alpha = .5)
#'
#' ggmap(hdf, extent = "device") +
#'   geom_point(aes(x = lon, y = lat, colour = class), data = chkpts, alpha = .5)
#'
#' theme_set(theme_bw())
#' ggmap(hdf, extent = "device") +
#'   geom_point(aes(x = lon, y = lat, colour = class), data = chkpts, alpha = .5)
#'
#' ggmap(hdf, extent = "device", legend = "topleft") +
#'   geom_point(aes(x = lon, y = lat, colour = class), data = chkpts, alpha = .5)
#'
#' # qmplot is great for this kind of thing...
#' qmplot(lon, lat, data = chkpts, color = class, darken = .6)
#' qmplot(lon, lat, data = chkpts, geom = "density2d", color = class, darken = .6)
#'
#' ## maprange
#' ##################################################
#'
#' hdf <- get_map()
#' mu <- c(-95.3632715, 29.7632836)
#' points <- data.frame(MASS::mvrnorm(1000, mu = mu, diag(c(.1, .1))))
#' names(points) <- c("lon", "lat")
#' points$class <- sample(c("a","b"), 1000, replace = TRUE)
#'
#' ggmap(hdf) + geom_point(data = points) # maprange built into extent = panel, device
#' ggmap(hdf) + geom_point(aes(colour = class), data = points)
#'
#' ggmap(hdf, extent = "normal") + geom_point(data = points)
#' # note that the following is not the same as extent = panel
#' ggmap(hdf, extent = "normal", maprange = TRUE) + geom_point(data = points)
#'
#' # and if you need your data to run off on a extent = device (legend included)
#' ggmap(hdf, extent = "normal", maprange = TRUE) +
#'   geom_point(aes(colour = class), data = points) +
#'   theme_nothing(legend = TRUE) + theme(legend.position = "right")
#'
#' # again, qmplot is probably more useful
#' qmplot(lon, lat, data = points, color = class, darken = .4, alpha = I(.6))
#' qmplot(lon, lat, data = points, color = class, maptype = "stamen_toner_lite")
#'
#' ## cool examples
#' ##################################################
#'
#' # contour overlay
#' ggmap(get_map(maptype = "satellite"), extent = "device") +
#'   stat_density2d(aes(x = lon, y = lat, colour = class), data = chkpts, bins = 5)
#'
#'
#' # adding additional content
#' library(grid)
#' baylor <- get_map("one bear place, waco, texas", zoom = 15, maptype = "satellite")
#' ggmap(baylor)
#'
#' # use gglocator to find lon/lat"s of interest
#' (clicks <- gglocator(2) )
#' ggmap(baylor) +
#'   geom_point(aes(x = lon, y = lat), data = clicks, colour = "red", alpha = .5)
#' expand.grid(lon = clicks$lon, lat = clicks$lat)
#'
#' ggmap(baylor) + theme_bw() +
#'   annotate("segment", x=-97.110, xend=-97.1188, y=31.5450, yend=31.5485,
#'     colour=I("red"), arrow = arrow(length=unit(0.3,"cm")), size = 1.5) +
#'   annotate("label", x=-97.113, y=31.5445, label = "Department of Statistical Science",
#'     colour = I("red"), size = 3.5) +
#'   labs(x = "Longitude", y = "Latitude") + ggtitle("Baylor University")
#'
#'
#' baylor <- get_map("marrs mclean science, waco, texas", zoom = 16, maptype = "satellite")
#'
#' ggmap(baylor, extent = "panel") +
#'   annotate("segment", x=-97.1175, xend=-97.1188, y=31.5449, yend=31.5485,
#'     colour=I("red"), arrow = arrow(length=unit(0.4,"cm")), size = 1.5) +
#'   annotate("label", x=-97.1175, y=31.5447, label = "Department of Statistical Science",
#'     colour = I("red"), size = 4)
#'
#'
#'
#' # a shapefile like layer
#' data(zips)
#' ggmap(get_map(maptype = "satellite", zoom = 8), extent = "device") +
#'   geom_polygon(aes(x = lon, y = lat, group = plotOrder),
#'     data = zips, colour = NA, fill = "red", alpha = .2) +
#'   geom_path(aes(x = lon, y = lat, group = plotOrder),
#'     data = zips, colour = "white", alpha = .4, size = .4)
#'
#' library(plyr)
#' zipsLabels <- ddply(zips, .(zip), function(df){
#'   df[1,c("area", "perimeter", "zip", "lonCent", "latCent")]
#' })
#' ggmap(get_map(maptype = "satellite", zoom = 9),
#'     extent = "device", legend = "none", darken = .5) +
#'   geom_text(aes(x = lonCent, y = latCent, label = zip, size = area),
#'     data = zipsLabels, colour = I("red")) +
#'   scale_size(range = c(1.5,6))
#'
#' qmplot(lonCent, latCent, data = zipsLabels, geom = "text",
#'   label = zip, size = area, maptype = "stamen_toner_lite", color = I("red")
#' )
#'
#'
#' ## crime data example
#' ##################################################
#'
#' # only violent crimes
#' violent_crimes <- subset(crime,
#'   offense != "auto theft" &
#'   offense != "theft" &
#'   offense != "burglary"
#' )
#'
#' # rank violent crimes
#' violent_crimes$offense <-
#'   factor(violent_crimes$offense,
#'     levels = c("robbery", "aggravated assault",
#'       "rape", "murder")
#'   )
#'
#' # restrict to downtown
#' violent_crimes <- subset(violent_crimes,
#'   -95.39681 <= lon & lon <= -95.34188 &
#'    29.73631 <= lat & lat <=  29.78400
#' )
#'
#'
#' # get map and bounding box
#' theme_set(theme_bw(16))
#' HoustonMap <- qmap("houston", zoom = 14, color = "bw",
#'   extent = "device", legend = "topleft")
#' HoustonMap <- ggmap(
#'   get_map("houston", zoom = 14, color = "bw"),
#'   extent = "device", legend = "topleft"
#' )
#'
#' # the bubble chart
#' HoustonMap +
#'    geom_point(aes(x = lon, y = lat, colour = offense, size = offense), data = violent_crimes) +
#'    scale_colour_discrete("Offense", labels = c("Robbery","Aggravated Assault","Rape","Murder")) +
#'    scale_size_discrete("Offense", labels = c("Robbery","Aggravated Assault","Rape","Murder"),
#'      range = c(1.75,6)) +
#'    guides(size = guide_legend(override.aes = list(size = 6))) +
#'    theme(
#'      legend.key.size = grid::unit(1.8,"lines"),
#'      legend.title = element_text(size = 16, face = "bold"),
#'      legend.text = element_text(size = 14)
#'    ) +
#'    labs(colour = "Offense", size = "Offense")
#'
#'
#' # doing it with qmplot is even easier
#' qmplot(lon, lat, data = violent_crimes, maptype = "stamen_toner_lite",
#'   color = offense, size = offense, legend = "topleft"
#' )
#'
#' # or, with styling:
#' qmplot(lon, lat, data = violent_crimes, maptype = "stamen_toner_lite",
#'   color = offense, size = offense, legend = "topleft"
#' ) +
#'   scale_colour_discrete("Offense", labels = c("Robbery","Aggravated Assault","Rape","Murder")) +
#'   scale_size_discrete("Offense", labels = c("Robbery","Aggravated Assault","Rape","Murder"),
#'     range = c(1.75,6)) +
#'   guides(size = guide_legend(override.aes = list(size = 6))) +
#'   theme(
#'     legend.key.size = grid::unit(1.8,"lines"),
#'     legend.title = element_text(size = 16, face = "bold"),
#'     legend.text = element_text(size = 14)
#'   ) +
#'   labs(colour = "Offense", size = "Offense")
#'
#'
#'
#'
#'
#'
#' # a contour plot
#' HoustonMap +
#'   stat_density2d(aes(x = lon, y = lat, colour = offense),
#'     size = 3, bins = 2, alpha = 3/4, data = violent_crimes) +
#'    scale_colour_discrete("Offense", labels = c("Robbery","Aggravated Assault","Rape","Murder")) +
#'    theme(
#'      legend.text = element_text(size = 15, vjust = .5),
#'      legend.title = element_text(size = 15,face="bold"),
#'      legend.key.size = grid::unit(1.8,"lines")
#'    )
#'
#'
#'
#' # 2d histogram...
#' HoustonMap +
#'   stat_bin_2d(aes(x = lon, y = lat, colour = offense, fill = offense),
#'     size = .5, bins = 30, alpha = 2/4, data = violent_crimes) +
#'    scale_colour_discrete("Offense",
#'      labels = c("Robbery","Aggravated Assault","Rape","Murder"),
#'      guide = FALSE) +
#'    scale_fill_discrete("Offense", labels = c("Robbery","Aggravated Assault","Rape","Murder")) +
#'    theme(
#'      legend.text = element_text(size = 15, vjust = .5),
#'      legend.title = element_text(size = 15,face="bold"),
#'      legend.key.size = grid::unit(1.8,"lines")
#'    )
#'
#'
#'
#'
#'
#' # changing gears (get a color map)
#' houston <- get_map("houston", zoom = 14)
#' HoustonMap <- ggmap(houston, extent = "device", legend = "topleft")
#'
#' # a filled contour plot...
#' HoustonMap +
#'   stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
#'     size = 2, bins = 4, data = violent_crimes, geom = "polygon") +
#'   scale_fill_gradient("Violent\nCrime\nDensity") +
#'   scale_alpha(range = c(.4, .75), guide = FALSE) +
#'   guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))
#'
#' # ... with an insert
#'
#' overlay <- stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
#'     bins = 4, geom = "polygon", data = violent_crimes)
#'
#' attr(houston,"bb") # to help finding (x/y)(min/max) vals below
#'
#' HoustonMap +
#'   stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
#'     bins = 4, geom = "polygon", data = violent_crimes) +
#'   scale_fill_gradient("Violent\nCrime\nDensity") +
#'   scale_alpha(range = c(.4, .75), guide = FALSE) +
#'   guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10)) +
#'   inset(
#'     grob = ggplotGrob(ggplot() + overlay +
#'       scale_fill_gradient("Violent\nCrime\nDensity") +
#'       scale_alpha(range = c(.4, .75), guide = FALSE) +
#'       theme_inset()
#'     ),
#'     xmin = -95.35877, xmax = -95.34229,
#'     ymin = 29.73754, ymax = 29.75185
#'   )
#'
#'
#'
#'
#'
#'
#'
#'
#'
#' ## more examples
#' ##################################################
#'
#' # you can layer anything on top of the maps (even meaningless stuff)
#' df <- data.frame(
#'   lon = rep(seq(-95.39, -95.35, length.out = 8), each = 20),
#'   lat = sapply(
#'     rep(seq(29.74, 29.78, length.out = 8), each = 20),
#'     function(x) rnorm(1, x, .002)
#'   ),
#'   class = rep(letters[1:8], each = 20)
#' )
#'
#' qplot(lon, lat, data = df, geom = "boxplot", fill = class)
#'
#' HoustonMap +
#'   geom_boxplot(aes(x = lon, y = lat, fill = class), data = df)
#'
#'
#'
#'
#' ## the base_layer argument - faceting
#' ##################################################
#'
#' df <- data.frame(
#'   x = rnorm(1000, -95.36258, .2),
#'   y = rnorm(1000,  29.76196, .2)
#' )
#'
#' # no apparent change because ggmap sets maprange = TRUE with extent = "panel"
#' ggmap(get_map(), base_layer = ggplot(aes(x = x, y = y), data = df)) +
#'   geom_point(colour = "red")
#'
#' # ... but there is a difference
#' ggmap(get_map(), base_layer = ggplot(aes(x = x, y = y), data = df), extent = "normal") +
#'   geom_point(colour = "red")
#'
#' # maprange can fix it (so can extent = "panel")
#' ggmap(get_map(), maprange = TRUE, extent = "normal",
#'   base_layer = ggplot(aes(x = x, y = y), data = df)) +
#'   geom_point(colour = "red")
#'
#' # base_layer makes faceting possible
#' df <- data.frame(
#'   x = rnorm(10*100, -95.36258, .075),
#'   y = rnorm(10*100,  29.76196, .075),
#'   year = rep(paste("year",format(1:10)), each = 100)
#' )
#' ggmap(get_map(), base_layer = ggplot(aes(x = x, y = y), data = df)) +
#'   geom_point() +  facet_wrap(~ year)
#'
#' ggmap(get_map(), base_layer = ggplot(aes(x = x, y = y), data = df), extent = "device") +
#'   geom_point() +  facet_wrap(~ year)
#'
#' qmplot(x, y, data = df)
#' qmplot(x, y, data = df, facets = ~ year)
#'
#'
#' ## neat faceting examples
#' ##################################################
#'
#' # simulated example
#' df <- data.frame(
#'   x = rnorm(10*100, -95.36258, .05),
#'   y = rnorm(10*100,  29.76196, .05),
#'   year = rep(paste("year",format(1:10)), each = 100)
#' )
#' for(k in 0:9){
#'   df$x[1:100 + 100*k] <- df$x[1:100 + 100*k] + sqrt(.05)*cos(2*pi*k/10)
#'   df$y[1:100 + 100*k] <- df$y[1:100 + 100*k] + sqrt(.05)*sin(2*pi*k/10)
#' }
#'
#' ggmap(get_map(),
#'   base_layer = ggplot(aes(x = x, y = y), data = df)) +
#'   stat_density2d(aes(fill = ..level.., alpha = ..level..),
#'     bins = 4, geom = "polygon") +
#'   scale_fill_gradient2(low = "white", mid = "orange", high = "red", midpoint = 10) +
#'   scale_alpha(range = c(.2, .75), guide = FALSE) +
#'   facet_wrap(~ year)
#'
#'
#'
#' # crime example by month
#' levels(violent_crimes$month) <- paste(
#'   toupper(substr(levels(violent_crimes$month),1,1)),
#'   substr(levels(violent_crimes$month),2,20), sep = ""
#' )
#' houston <- get_map(location = "houston", zoom = 14, source = "osm", color = "bw")
#' HoustonMap <- ggmap(houston,
#'   base_layer = ggplot(aes(x = lon, y = lat), data = violent_crimes)
#'   )
#'
#' HoustonMap +
#'   stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
#'     bins = I(5), geom = "polygon", data = violent_crimes) +
#'   scale_fill_gradient2("Violent\nCrime\nDensity",
#'     low = "white", mid = "orange", high = "red", midpoint = 500) +
#'   labs(x = "Longitude", y = "Latitude") + facet_wrap(~ month) +
#'   scale_alpha(range = c(.2, .55), guide = FALSE) +
#'   ggtitle("Violent Crime Contour Map of Downtown Houston by Month") +
#'   guides(fill = guide_colorbar(barwidth = 1.5, barheight = 10))
#'
#'
#'
#'
#'
#'
#'
#'
#' ## darken argument
#' ##################################################
#' ggmap(get_map())
#' ggmap(get_map(), darken = .5)
#' ggmap(get_map(), darken = c(.5,"white"))
#' ggmap(get_map(), darken = c(.5,"red")) # silly, but possible
#'
#'
#' }
ggmap <- function(ggmap, extent = "panel", base_layer, maprange = FALSE,
  legend = "right", padding = .02, darken = c(0, "black"), b, fullpage, expand, ...)
{

  # dummies to trick R CMD check
  lon <- NULL; rm(lon); lat <- NULL; rm(lat); fill <- NULL; rm(fill);
  ll.lon <- NULL; rm(ll.lon); ur.lon <- NULL; rm(ur.lon);
  ll.lat <- NULL; rm(ll.lat); ur.lat <- NULL; rm(ur.lat);

  # deprecated syntaxes
  if(!missing(b)) {
    .Deprecated(msg = "b syntax deprecated, use padding.")
    padding <- b
  }

  if(!missing(fullpage) || !missing(expand)){
    .Deprecated(msg = "fullpage and expand syntaxes deprecated, use extent.")
    if(missing(fullpage)) { fullpage <- FALSE }
    if(missing(expand)) { expand <- FALSE }
    if(fullpage) extent <- "device"
    if(fullpage == FALSE && expand == TRUE) extent <- "panel"
    if(fullpage == FALSE && expand == FALSE) extent <- "normal"
  }



  # check arguments
  if(class(ggmap)[1] != "ggmap"){
    cli::cli_abort("{.fn ggmap::ggmap} only plots objects of class {.code ggmap}")
  }

  match.arg(legend, c("right", "left", "bottom", "top",
    "bottomleft", "bottomright", "topleft", "topright", "none"))

  if(is.language(darken)) darken <- eval(darken) # happens when passed from qmap


  # check darken
  stopifnot(0 <= as.numeric(darken[1]) && as.numeric(darken[1]) <= 1)
  if(length(darken) == 1 & is.numeric(darken)) darken <- c(darken, "black")


  # make raster plot or tile plot


  if(
    missing(base_layer) ||
    (is.character(base_layer) && (length(base_layer) == 1) && base_layer == "auto") # safer base_layer == "auto", https://github.com/dkahle/ggmap/issues/334
  ){
    if(inherits(ggmap, "raster")){ # raster
      # make base layer data.frame
      fourCorners <- expand.grid(
    	  lon = as.numeric(attr(ggmap, "bb")[,c("ll.lon","ur.lon")]),
  	    lat = as.numeric(attr(ggmap, "bb")[,c("ll.lat","ur.lat")])
      )

      # shorthand notation
      xmin <- attr(ggmap, "bb")$ll.lon
      xmax <- attr(ggmap, "bb")$ur.lon
      ymin <- attr(ggmap, "bb")$ll.lat
  	  ymax <- attr(ggmap, "bb")$ur.lat

      p <- ggplot(aes(x = lon, y = lat), data = fourCorners) +
  	    geom_blank() +
  	    inset_raster(ggmap, xmin, xmax, ymin, ymax) +
  	    annotate("rect", xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax,
  	      fill = darken[2], alpha = as.numeric(darken[1]))

    } else { # tile, depricated
      p <- ggplot() + geom_tile(aes(x = lon, y = lat, fill = fill), data = ggmap) +
        scale_fill_identity(guide = "none")
      .Deprecated(msg = "geom_tile method is deprecated, use rasters.")
    }
  } else { # base_layer provided making facets possible
    # get call
  	stopifnot(inherits(ggmap, "raster"))
    args <- as.list(match.call()[-1])
    base <- deparse(args$base_layer) # "ggplot(aes(), data = blah)"
    # if passed from another function
    if(base[1] == "base_layer") base <- deparse(eval(args$base_layer))

    # shorthand notation
    xmin <- attr(ggmap, "bb")$ll.lon
    xmax <- attr(ggmap, "bb")$ur.lon
  	ymin <- attr(ggmap, "bb")$ll.lat
  	ymax <- attr(ggmap, "bb")$ur.lat
    str2parse <- paste(paste(base, collapse = ""), "geom_blank()",
      "inset_raster(ggmap, xmin, xmax, ymin, ymax)",
      sep = " + "
    )

    # attempt to ensure that base_layer argument is evaluated correctly by forcing evaluation in the calling environment.
    # if that fails, the previous default behavior is provided. see https://github.com/dkahle/ggmap/issues/84 for background.
    p <- try(eval(parse(text = paste(base,collapse="")),parent.frame(1))+geom_blank()+inset_raster(ggmap, xmin, xmax, ymin, ymax))
    if(inherits(p,"try-error")) p <- eval(parse(text = str2parse))

    p <- p + annotate("rect", xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax,
  	  fill = darken[2], alpha = as.numeric(darken[1]))
  }

  # enforce maprange
  if(maprange) p <- p + xlim(xmin, xmax) + ylim(ymin, ymax)

  # set scales
  p <- p + coord_map2()

  # set extent
  xmin <- attr(ggmap, "bb")$ll.lon
  xmax <- attr(ggmap, "bb")$ur.lon
  ymin <- attr(ggmap, "bb")$ll.lat
  ymax <- attr(ggmap, "bb")$ur.lat

  if(extent == "normal"){
    # nothing
  } else if(extent == "panel"){
  	p <- p +
      scale_x_continuous(limits = c(xmin, xmax), expand = c(0,0)) +
      scale_y_continuous(limits = c(ymin, ymax), expand = c(0,0))
  } else if(extent == "device"){
  	p <- p +
      scale_x_continuous(limits = c(xmin, xmax), expand = c(0,0)) +
      scale_y_continuous(limits = c(ymin, ymax), expand = c(0,0)) +
      theme_nothing(legend = TRUE)

    # legend for full device map
    if(legend %in% c("topleft","topright","bottomleft","bottomright")){
      if(legend == "bottomleft"){
        lp <- c(padding, padding)
        lj <- c(0,0)
      } else if(legend == "topleft"){
        lp <- c(padding, 1-padding)
        lj <- c(0,1)
      } else if(legend == "bottomright"){
        lp <- c(1-padding, padding)
        lj <- c(1,0)
      } else if(legend == "topright"){
        lp <- c(1-padding, 1-padding)
        lj <- c(1,1)
      }
      p <- p + theme(
        legend.position = lp, legend.justification = lj,
        legend.background = element_rect(
          fill = "white", colour = "gray80", size = .2
        )
      )
    } else if(legend %in% c("left","right","bottom","top")){
      p <- p + theme(legend.position = legend)
    } # else legend = "none" as part of theme_nothing()
  }

  # return plot
  p
}





#' Don't use this function, use ggmap.
#'
#' ggmap plots the raster object produced by [get_map()].
#'
#' @param ggmap an object of class ggmap (from function [get_map()])
#' @param fullpage logical; should the map take up the entire viewport?
#' @param base_layer a ggplot(aes(...), ...) call; see examples
#' @param maprange logical for use with base_layer; should the map define the x and y limits?
#' @param expand should the map extend to the edge of the panel? used with base_layer and maprange=TRUE.
#' @param ... ...
#' @return a ggplot object
#' @author David Kahle \email{david@@kahle.io}
#' @seealso [get_map()], [qmap()]
#' @export
#' @examples
#' \dontrun{
#' this is a deprecated function, use ggmap.
#' }
ggmapplot <- function(ggmap, fullpage = FALSE,
  base_layer, maprange = FALSE, expand = FALSE, ...)
{
  .Deprecated(msg = "ggmapplot syntax deprecated, use ggmap.")
  ggmap(ggmap, fullpage = fullpage, base_layer = base_layer,
    maprange = FALSE, expand = FALSE, ggmapplot = TRUE)
}
