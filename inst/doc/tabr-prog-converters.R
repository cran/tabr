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

## ----music21------------------------------------------------------------------
m21 <- "4/4 CC#FF4.. trip{c#8eg# d'- e-' f g a'} D4~# D E F r B16 trip{c4 d e}"
x <- from_music21(m21)
class(x)
x

summary(x)

y <- to_tabr(id = "music21", x = m21)
identical(x, y)

from_music21(m21, output = "list") # same as music_split(x)

## ----chorrrds1----------------------------------------------------------------
chords <- c("Bb", "Bbm", "Bbm7", "Bbm7(b5)", "Bb7(#5)/G", "Bb7(#5)/Ab")
x <- from_chorrrds(chords)
x

y <- to_tabr("chorrrds", x = chords)
identical(x, y)

## ----chorrrds2----------------------------------------------------------------
x <- transpose(x, -12) %>% chord_slice(1:3) %>% sharpen_flat()
tally_pitches(x)
distinct_pitches(x) %>% pitch_semitones()

## ----chorrrds3----------------------------------------------------------------
from_chorrrds(chords, guitar = TRUE)

## ----chorrrds4----------------------------------------------------------------
chords <- c("Am", "C", "D", "F", "Am", "E", "Am", "E")
x <- from_chorrrds(chords, guitar = TRUE)

as_music_df(x)

## ----chorrrds5----------------------------------------------------------------
x <- rep(x, each = 4)
time <- rep(4, length(x))

mdf <- as_music_df(x, time, key = "am")
mdf

## ----chorrrds6----------------------------------------------------------------
chords <- unique(chords)
x <- from_chorrrds(chords, guitar = TRUE, gc_args = list(min_fret = 0:1))
x

gc_is_known(x) # Are chords available with these exact pitch sequences?
y <- gc_notes_to_fb(x)
y

## ----chorrrds7, eval=FALSE----------------------------------------------------
#  out <- "House of the rising sun - chords.pdf"
#  render_chordchart(y, out, fontsize = 80)

## ----chorrrds8----------------------------------------------------------------
library(dplyr)

fret_span <- function(x){
  f <- function(x) strsplit(x, ";") %>% unlist() %>% as.integer() %>% 
    range(na.rm = TRUE) %>% diff()
  suppressWarnings(sapply(x, f) + 1L) # coercing string to NA integer
}

mutate(mdf, frets = gc_notes_to_fb(pitch), fret_span = fret_span(frets)) %>%
  select(duration, pitch, frets, fret_span)

