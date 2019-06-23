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

## ----chords1-------------------------------------------------------------
x <- "ce_g cd#g"
chord_is_diatonic(x, key = "b_")

## ----chords 2------------------------------------------------------------
x <- "a2 c a2 ceg ce_g cea"
chord_rank(x, "min")
chord_rank(x, "max")
chord_rank(x, "mean")

chord_order(x)
chord_order(x, "mean")

chord_sort(x, "mean")

## ----chords3-------------------------------------------------------------
x <- "ce_g"
chord_break(x)

## ----chords4-------------------------------------------------------------
glue(sapply((-3):3, function(i) chord_invert(x, i)))

## ----chords5-------------------------------------------------------------
chord_arpeggiate("ce_gb_", 2)
chord_arpeggiate("ce_gb_", -2)
chord_arpeggiate("ce_gb_", 2, by = "chord")
chord_arpeggiate("ce_gb_", 1, broken = TRUE, collapse = TRUE)

## ----chords6-------------------------------------------------------------
dyad("a", 3)
x <- c("minor third", "m3", "augmented second", "A2")
sapply(x, function(x) dyad("a", x))
sapply(x, function(x) dyad("c'", x, reverse = TRUE))

## ----chords7, echo=FALSE-------------------------------------------------
name <- c("chord_min", "chord_maj", "chord_min7", "chord_dom7", "chord_7s5", "chord_maj7", "chord_min6", "chord_maj6", "chord_dim", 
  "chord_dim7", "chord_m7b5", "chord_aug", "chord_5", "chord_sus2", "chord_sus4", "chord_dom9", "chord_7s9", "chord_maj9", 
  "chord_add9", "chord_min9", "chord_madd9", "chord_min11", "chord_7s11", "chord_maj7s11", "chord_11", "chord_maj11", "chord_13", "chord_min13", "chord_maj13")
abb <- c("xm", "xM", "xm7", "x7", "x7s5", "xM7", "xm6", "xM6", "xdim", "xdim7", "xm7b5", "xaug", 
  "x5", "xs2", "xs4", "x9", "x7s9", "xM9", "xadd9", "xm9", "xma9", "xm11", "x7s11", "xM7s11", "x_11", "xM11", "x_13", "xm13", "xM13")
data.frame(full_name = name, abbreviation = abb)

## ----chords8-------------------------------------------------------------
chord_min7("a c e")
chord_min7("a c e", key = "f")
xm7("a c e", key = "f")

## ----guitarChords--------------------------------------------------------
guitarChords

## ----chord_def-----------------------------------------------------------
frets <- c(NA, 0, 2, 2, 1, 0)
chord_def(frets, "m", 6) # sixth entry (highest string: string #1) is optional

## ----chord_def2----------------------------------------------------------
purrr::map_dfr(1:12, ~chord_def(frets + .x, "m"))
purrr::map_dfr(1:12, ~chord_def(frets + .x, "m", key = "f")) # flats

## ----gc_helpers1---------------------------------------------------------
lp_chord_id("a a a", "m M m7_5")
lp_chord_mod("a a a", "m M m7_5")

## ----gc_helpers2---------------------------------------------------------
chord_is_known("a b_,fb_d'f'")

x <- "a aM b_,m7#5"
chord_name_split(x)
chord_name_root(x)
chord_name_mod(x)

## ----gc_info-------------------------------------------------------------
gc_info("a") # a major chord, not a single note
gc_info("ceg a#m7_5") # only third entry is a guitar chord
gc_info("ceg a#m7_5", key = "f")

gc_info("a,m c d f,")

## ----gc_notes------------------------------------------------------------
x <- gc_notes("a,7 b,m", 0:2) # filter/restriction: root fret must be in 0:2
summary(x)

## ----gc_fretboard--------------------------------------------------------
gc_fretboard("a,m c d f,", NA, 0:1)

