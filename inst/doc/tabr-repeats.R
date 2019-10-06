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

## ----rep1----------------------------------------------------------------
p1 <- p("c e g c' e' c' g e", 8)
pn(p1, 2) # repeat n = 2 times
rp(p1, 1) # repeat once (n = 1), or play twice (n + 1)

## ----rep1b, results="hide", eval=FALSE-----------------------------------
#  pc(pn(p1, 2), rp(p1)) %>% track %>% score %>% tab("example17.pdf")

## ----rep2----------------------------------------------------------------
pct(p1, 3)

## ----rep2b, results="hide", eval=FALSE-----------------------------------
#  p2 <- p("g,b,dgbg'*16", 16)
#  pc(pct(p1, 3), pct(p2, 3)) %>% track %>% score %>% tab("example18.pdf")

## ----rep3----------------------------------------------------------------
e1 <- p("f a c' f'", 4)
e2 <- p("c*8", 8)
e3 <- p("cegc'e'", 1)

## ----rep3b---------------------------------------------------------------
volta(p1)
volta(p1, 2)

## ----rep3c, results="hide", eval=FALSE-----------------------------------
#  pc(volta(p1), volta(p1, 2)) %>% track %>% score %>% tab("example19.pdf")

## ----rep3d---------------------------------------------------------------
volta(p1, 1, e1)
volta(p1, 2, e1)

## ----rep3e, results="hide", eval=FALSE-----------------------------------
#  c1 <- p("c", 1)
#  pc(volta(p1, 1, e1), c1, volta(p1, 2, e1), c1) %>% track %>% score %>% tab("example20.pdf")

## ----rep3f---------------------------------------------------------------
x1 <- volta(p1, 2, list(e1, e2, e3))
x2 <- volta(p1, 2, list(e1, e2))
x3 <- volta(p1, 2, e1)
x1
x2
x3

## ----rep3g, results="hide", eval=FALSE-----------------------------------
#  pc(x1, c1, x2, c1, x3, c1) %>% track %>% score %>% tab("example21.pdf")

## ----cleanup, echo=FALSE-------------------------------------------------
unlink("*.mid")

