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
library(dplyr)
mainIntervals <- tbl_df(mainIntervals)

## ----key-----------------------------------------------------------------
keys()

key_is_flat("f")
key_n_flats("f")

## ----scales--------------------------------------------------------------
scale_hungarian_minor(key = "am", collapse = TRUE)

## ----scales2-------------------------------------------------------------
scale_major("f", TRUE, ignore_octave = TRUE)
scale_major("f", TRUE, ignore_octave = FALSE)

## ----modes---------------------------------------------------------------
modes()
mode_aeolian("c")

## ----scale_chords--------------------------------------------------------
scale_chords("b_", "major", "seventh", collapse = TRUE)
scale_chords("f#", "minor", "triad", collapse = TRUE)

## ----scale_degrees-------------------------------------------------------
x <- "c e gb'd'"
scale_degree(x)
scale_degree(x, key = "a")
scale_degree(x, key = "am")
scale_degree(x, scale = "chromatic")

scale_note(1:7, "d")
scale_note(c(1:8), "dm", "harmonic minor")

note_in_scale("a_ b c", "a_", ignore_octave = TRUE)

## ----intervals-----------------------------------------------------------
mainIntervals

interval_semitones(c("m3", "M7"))

## ----intervals2----------------------------------------------------------
pitch_interval("c", "c,")
pitch_interval("a2", "c")

## ----intervals3----------------------------------------------------------
scale_interval("c", "c,")
scale_interval("a2", "c", format = "mmp")

