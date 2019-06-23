## ----setup, include = FALSE----------------------------------------------
options(crayon.enabled = TRUE)
sgr_wrap <- function(x, options){
  paste0("<pre class=\"r-output\"><code>", fansi::sgr_to_html(x = htmltools::htmlEscape(x)), "</code></pre>")
}
knitr::knit_hooks$set(output = sgr_wrap)
knitr::opts_chunk$set(
  collapse = TRUE, comment = "#>", message = FALSE, warning = FALSE, error = FALSE, tidy = FALSE, out.width = "100%"
)
library(tabr)

## ----fb1-----------------------------------------------------------------
fretboard_plot(string = 6:1, fret = c(0, 2, 2, 0, 0, 0))

## ----fb2-----------------------------------------------------------------
fretboard_plot(6:1, c(0, 2, 2, 0, 0, 0), c("G", "U", "I", "T", "A", "R"))

## ----fb3-----------------------------------------------------------------
string <- c(6, 6, 6, 5, 5, 5, 4, 4, 4, 4, 4, 3, 3, 3, 2, 2, 2, 1, 1, 1)
fret <- c(2, 4, 5, 2, 4, 5, 2, 4, 6, 7, 9, 6, 7, 9, 7, 9, 10, 7, 9, 10)
fretboard_plot(string, fret, "notes", show_tuning = TRUE)

## ----fb4-----------------------------------------------------------------
fretboard_plot(string, fret, "notes", show_tuning = TRUE, key = "f")

## ----fb5-----------------------------------------------------------------
fretboard_plot(string, fret, "notes", fret_range = c(0, 10), show_tuning = TRUE)

## ----fb6-----------------------------------------------------------------
tuning <- "b1 e2 a2 d3 g3 b3 e4"
fretboard_plot(c(7, string), c(1, fret), "notes", fret_range = c(0, 10), 
               tuning = tuning, show_tuning = TRUE)

## ----fb7-----------------------------------------------------------------
am_frets <- c(c(0, 0, 2, 2, 1, 0), c(5, 7, 7, 5, 5, 5))
am_strings <- c(6:1, 6:1)
mute <- c(TRUE, rep(FALSE, 11))

# colors
idx <- c(2, 2, 1, 1, 1, 2, rep(1, 6))
lab_col <- c("white", "black")[idx]
pt_fill <- c("firebrick1", "white")[idx]

fretboard_plot(am_strings, am_frets, "notes", mute, 
               label_color = lab_col, point_fill = pt_fill)

## ----fb7b----------------------------------------------------------------
f <- "0 2 2 1 0 0 0 2 2 0 0 0"
s <- c(6:1, 6:1)
grp <- rep(c("Open E", "Open Em"), each = 6)

# colors
idx <- c(2, 1, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2)
lab_col <- c("white", "black")[idx]
pt_fill <- c("firebrick1", "white")[idx]

fretboard_plot(s, f, "notes", group = grp, fret_range = c(0, 4),
               label_color = lab_col, point_fill = pt_fill)

## ----fb8-----------------------------------------------------------------
library(ggplot2)
fretboard_plot(string, fret, "notes", label_color = "white", point_fill = "dodgerblue",
               fret_range = c(0, 10), show_tuning = TRUE, horizontal = TRUE) +
  ggtitle("Horizontal")

fretboard_plot(string, fret, "notes", label_color = "white", point_fill = "dodgerblue",
               fret_range = c(0, 10), show_tuning = TRUE, horizontal = TRUE, left_handed = TRUE) +
  ggtitle("Horizontal and left-handed")

