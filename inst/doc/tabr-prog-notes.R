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

## ----notes1--------------------------------------------------------------
x <- "c e_ g b_"
note_is_natural(x)
note_is_accidental(x)
note_is_flat(x)
note_is_sharp(x)

## ----notes2--------------------------------------------------------------
x <- "c e_ g b_ cd#g"
is_diatonic(x, "c")
is_diatonic(x, "b_")

## ----notes3--------------------------------------------------------------
flatten_sharp(x)
sharpen_flat(x)

## ----notes4--------------------------------------------------------------
naturalize(x)

## ----notes5--------------------------------------------------------------
note_set_key(x, "c") # no change possible
note_set_key(x, "f") # key of F has a flat
note_set_key(x, "g") # key of G has a sharp

## ----notes6--------------------------------------------------------------
x <- "b_2 ce_g"
y <- "b_ cd#g"
note_is_equal(x, y)
note_is_identical(x, y)

pitch_is_equal(x, y)
pitch_is_identical(x, y)

## ----notes7--------------------------------------------------------------
x <- "b_2 ce_g b_"
y <- "b_2 ce_gb_"
note_is_equal(x, y)

## ----notes8--------------------------------------------------------------
x <- "b_2 ce_g b_"
y <- "b_2 ce_ gb_"
note_is_equal(x, y)

## ----notes9--------------------------------------------------------------
x <- "a1 b_2 a1b2c3 a1b4 g1a1b1"
y <- "a_2 g#2 d1e1f2g3 a1b2b4 d1e1"
octave_is_equal(x, y)
octave_is_identical(x, y)
octave_is_identical(x, y, single_octave = TRUE)

## ----notes10-------------------------------------------------------------
x <- "a b ceg"
note_rotate(x, 1)
note_rotate(x, -1)

## ----notes11-------------------------------------------------------------
note_shift("c e g", 1)
note_shift("c e g", -4)

## ----notes12-------------------------------------------------------------
note_arpeggiate("c e g", 5)
note_arpeggiate("c e g", -5)

