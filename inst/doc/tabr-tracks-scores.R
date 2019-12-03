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

## ----intro--------------------------------------------------------------------
notesC <- "c e g c' e' c' g e g b d' g' f a c' f' c e g e c"
strings <- "5 4 3 2 1 2 3 4 4 3 2 1 4 3 2 1 5 4 3 4 5"
p1 <- p(notesC, "8*20 2", strings) 
track(p1)

## ----track0-------------------------------------------------------------------
trackbind(track_tc(p1), track_bc(p1))

## ----track1-------------------------------------------------------------------
trackbind(track(p1, clef = NA), track(p1, key = "g", tab = FALSE))

## ----track2-------------------------------------------------------------------
t1 <- p("c'' d'' e'' f'' g''", "1 2 4 4 1", 5) %>% track()
t2 <- track(p1)
trackbind(t1, t2)

## ----track3, results="hide", eval=FALSE---------------------------------------
#  trackbind(t1, t2) %>% score %>% tab("ex22.pdf")

## ----track4-------------------------------------------------------------------
p2 <- tp(notesC, 2, key = "d") %>% p("8*20 2", strings)
t1 <- track(p2, key = "d", tab = FALSE)
t2 <- track(p1, clef = NA)
trackbind(t1, t2)

## ----track5, results="hide", eval=FALSE---------------------------------------
#  trackbind(t1, t2) %>% score() %>% tab("ex23.pdf")

## ----track6-------------------------------------------------------------------
p2 <- p("c'' d'' e'' f'' g''", "1 2 4 4 1", 5)
t1 <- track(p2, voice = 1)
t2 <- track(p1, voice = 2)
trackbind(t1, t2)

## ----track7-------------------------------------------------------------------
trackbind(t1, t2, id = c(1, 1))

## ----track8, results="hide", eval=FALSE---------------------------------------
#  trackbind(t1, t2, id = c(1, 1)) %>% score() %>% tab("ex24.pdf")

## ----track9-------------------------------------------------------------------
t1 <- track(p2, voice = 1)
t2 <- track(p1, voice = 2)
t3 <- track(p("ce*4 g,*2 f,*2 ce*3", "4*10 2", "54*4 6*4 54*3"), clef = NA)
t_all <- trackbind(t1, t2, t3, id = c(1, 1, 2))
t_all

## ----track10, results="hide", eval=FALSE--------------------------------------
#  score(t_all) %>% tab("ex25.pdf")

## ----track11------------------------------------------------------------------
x <- p("e, b, e g b e'", 8)
t1 <- track(x)
t2 <- track(x, tuning = "dropD")
t3 <- track(x, tuning = "dropC")

## ----track12, echo=FALSE, results="hide", eval=FALSE--------------------------
#  score(t1) %>% tab("ex26a.pdf")
#  score(t2) %>% tab("ex26b.pdf")
#  score(t3) %>% tab("ex26c.pdf")

## ----track13------------------------------------------------------------------
t1 <- track(rp(p2, 2), voice = 1)
t2 <- track(rp(p1, 2), voice = 2)
t3 <- track(rp(p("c,e,*4 g,,*2 f,,*2 c,e,*3", "4*10 2", "32*4 4*4 32*3"), 2), 
            clef = "bass_8", tuning = "bass")
t_all <- trackbind(t1, t2, t3, id = c(1, 1, 2))
t_all

## ----track14, results="hide", eval=FALSE--------------------------------------
#  score(t_all) %>% tab("ex28.pdf")

## ----track15------------------------------------------------------------------
chords <- chord_set(c(c = "x32o1o", g = "355433", f = "133211"))
chord_seq <- rep(setNames(c(1, 2, 2, 1), names(chords)[c(1:3, 1)]), 3)
chords
chord_seq

## ----track16, results="hide", eval=FALSE--------------------------------------
#  score(t_all, chords = chords) %>% tab("ex29.pdf")

## ----track17, results="hide", eval=FALSE--------------------------------------
#  score(t_all, chord_seq = chord_seq) %>% tab("ex30.pdf")

## ----track18, results="hide", eval=FALSE--------------------------------------
#  score(t_all, chords, chord_seq) %>% tab("ex31.pdf")

## ----cleanup, echo=FALSE------------------------------------------------------
unlink("*.mid")

