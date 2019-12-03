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

## ----song---------------------------------------------------------------------
voice1 <- rp(p("c5 d5 e5 f5 g5", "1 2 4 4 1", "1*5"), 2)

notes <- "c e g c' e' c' g e g b d' g' f a c' f' c e g e c"
strings <- "5 4 3 2 1 2 3 4 4 3 2 1 4 3 2 1 5 4 3 4 5"
voice2 <- rp(p(notes, "8*20 2", strings), 2)

bass <- rp(p("c2e2*4 g1*2 f1*2 c2e2*3", "4*10 2", "32*4 4*4 32*3"), 2)

t1 <- track(voice1, voice = 1)
t2 <- track(voice2, voice = 2)
t3 <- track(bass, clef = "bass_8", tuning = "bass")

chords <- chord_set(c(c = "x32o1o", g = "355433", f = "133211"))
chord_seq <- rep(setNames(c(1, 2, 2, 1), names(chords)[c(1:3, 1)]), 3)
chords
chord_seq

song <- trackbind(t1, t2, t3, id = c(1, 1, 2)) %>% score(chords, chord_seq)
song

## ----metadata, results="hide", eval=FALSE-------------------------------------
#  lilypond(song, "ex32.ly", "dm", "2/2", "4 = 120")
#  tab(song, "ex32.pdf", "dm", "2/2", "4 = 120")

## ----header, results="hide", eval=FALSE---------------------------------------
#  header <- list(
#    title = "Song title",
#    composer = "Words and music by the composer",
#    performer = "Song performer",
#    album = "Album title",
#    subtitle = "Subtitle",
#    arranger = "Arranged by tab arranger",
#    copyright = "2018 <Record Label>",
#    instrument = "guitar and bass",
#    tagline = "A tagline",
#    meter = "meter tag", opus = "opus tag", piece = "piece tag", poet = "poet tag"
#  )
#  
#  tab(song, "ex33.pdf", header = header)

## ----png1, eval=FALSE---------------------------------------------------------
#  x <- pitch_seq("e,", 24, key ="c") %>% as_music(8) %>% p() %>% track() %>% score()
#  
#  ppr <- list(linewidth = 60, page_numbers = FALSE)
#  hdr <- list(title = "Notes in C on guitar", subtitle = "Standard tuning")
#  tab(x, "ex_png1.png", tempo = NULL, midi = FALSE, header = hdr, paper = ppr)

## ----png2, eval=FALSE---------------------------------------------------------
#  colors <- list(color = "#e4e4e4", background = "gray10", head = "tomato", tabhead = "tomato")
#  
#  x <- as_music(pitch_seq("e,", 24, key ="c"), 8) %>%
#    render_music_guitar("ex_png2.png", colors = colors, res = 300)

## ----ly1----------------------------------------------------------------------
lilypond(song, "song.ly", simplify = FALSE)
cat(readLines("song.ly"), sep = "\n")

## ----ly2----------------------------------------------------------------------
lilypond(song, "song.ly")
cat(readLines("song.ly"), sep = "\n")

## ----cleanup, echo=FALSE------------------------------------------------------
unlink(c("*.ly", "*.mid"))

