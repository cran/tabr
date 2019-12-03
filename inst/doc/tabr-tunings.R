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

## ----table0-------------------------------------------------------------------
head(tunings)

## ----tuning1------------------------------------------------------------------
p1 <- p("a", 1)
track(p1, tuning = "standard")
track(p1, tuning = "e2 a2 d g b e4")
track(p1, tuning = "e, a, d g b e'")

## ----tuning2------------------------------------------------------------------
guitar <- tuplet("e, a, d g b e'", 4)
bass <- p("e,, a,, d, g,", 4)
one_string <- p("c' d' e' f'", 4)
tracks <- trackbind(
  track(guitar, clef = NA), 
  track(bass, clef = NA, tuning = "bass"), 
  track(one_string, clef = NA, tuning = "c'")
)
tracks

## ----tuning2b, results="hide", eval=FALSE-------------------------------------
#  score(tracks) %>% tab("out.pdf")

## ----tuning3------------------------------------------------------------------
tracks <- trackbind(
  track(guitar), 
  track(bass, clef = "bass_8", tuning = "bass"), 
  track(one_string, clef = "treble", tuning = "c'")
)
tracks

## ----tuning3b, results="hide", eval=FALSE-------------------------------------
#  score(tracks) %>% tab("out.pdf")

## ----cleanup, echo=FALSE------------------------------------------------------
unlink("*.mid")

