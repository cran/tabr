## ----setup, include = FALSE---------------------------------------------------
options(crayon.enabled = TRUE)
sgr_wrap <- function(x, options){
  paste0("<pre class=\"r-output\"><code>", fansi::sgr_to_html(x = htmltools::htmlEscape(x)), "</code></pre>")
}
knitr::knit_hooks$set(output = sgr_wrap)
knitr::opts_chunk$set(
  collapse = TRUE, comment = "#>", message = FALSE, warning = FALSE, error = FALSE, tidy = FALSE, out.width = "100%"
)
library(tabr)
library(dplyr)

## ----chords-------------------------------------------------------------------
library(dplyr)

chords <- filter(
  guitarChords, 
  root %in% c("c", "f") & 
    id %in% c("7", "M7", "m7") &
    !grepl("#", notes) & root_fret <= 12
  ) %>%
  arrange(root, id)

chords <- setNames(chords$fretboard, chords$lp_name)
head(chords)

## ----chordchart, eval=FALSE---------------------------------------------------
#  hdr <- list(
#    title = "Dominant 7th, major 7th and minor 7th chords",
#    subtitle = "C and F root"
#  )
#  render_chordchart(chords, "out.png", 2, hdr, list(textheight = 175))

