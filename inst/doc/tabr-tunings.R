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

## ----table1, echo=FALSE--------------------------------------------------
knitr::kable(tunings, "html", escape = TRUE, align = "c") %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "condensed"), position = "float_right", full_width = FALSE)

## ----table0, eval=FALSE--------------------------------------------------
#  tunings

## ----tuning1-------------------------------------------------------------
p1 <- p("a", 1)
track(p1, tuning = "standard")
track(p1, tuning = "e2 a2 d g b e4")
track(p1, tuning = "e, a, d g b e'")

## ----tuning2-------------------------------------------------------------
guitar <- tuplet("e, a, d g b e'", 4)
bass <- p("e,, a,, d, g,", 4)
one_string <- p("c' d' e' f'", 4)
tracks <- trackbind(track(guitar, music_staff = NA), 
                    track(bass, "bass", music_staff = NA), 
                    track(one_string, "c'", music_staff = NA))
tracks

## ----tuning2b, results="hide", eval=FALSE--------------------------------
#  score(tracks) %>% tab("out.pdf")

## ----tuning3-------------------------------------------------------------
tracks <- trackbind(track(guitar), 
                    track(bass, "bass", music_staff = "bass_8"), 
                    track(one_string, "c'", music_staff = "treble"))
tracks

## ----tuning3b, results="hide", eval=FALSE--------------------------------
#  score(tracks) %>% tab("out.pdf")

## ----cleanup, echo=FALSE-------------------------------------------------
unlink("*.mid")

