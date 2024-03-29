#' Tied notes
#'
#' Tie notes efficiently.
#'
#' This function is useful for bar chords.
#'
#' @param x character, a single chord.
#'
#' @return a character string.
#' @export
#'
#' @examples
#' tie("e,b,egbe'")
tie <- function(x){
  .check_noteworthy(x)
  y <- .uncollapse(x)
  if(any(grepl("~", y))) y <- gsub("~", "", y)
  y <- sapply(y, function(x) paste0(.split_chord(x), "~", collapse = ""),
              USE.NAMES = FALSE)
  if(length(x) == 1) y <- paste(y, collapse = " ")
  .asnw(y)
}

#' @export
#' @rdname tie
untie <- function(x){
  .check_noteworthy(x)
  .asnw(gsub("~", "", x))
}

#' Create rests
#'
#' Create multiple rests efficiently with a simple wrapper around `rep()` using
#' the `times` argument.
#'
#' @param x integer, duration.
#' @param n integer, number of repetitions.
#'
#' @return a character string.
#' @export
#'
#' @examples
#' rest(c(1, 8), c(1, 4))
rest <- function(x, n = 1){
  paste0(rep(paste0("r", x), times = n), collapse = " ")
}

#' Add text to music staff
#'
#' Annotate a music staff, vertically aligned above or below the music staff at
#' a specific note/time.
#'
#' This function binds text annotation in LilyPond syntax to a note's
#' associated `info` entry.
#' Technically, the syntax is a hybrid form, but is later updated safely and
#' unambiguously to LilyPond syntax with respect to the rest of the note info
#' substring when it is fed to `phrase()` for musical phrase assembly.
#'
#' @param x character.
#' @param text character.
#' @param position character, top or bottom.
#'
#' @return a character string.
#' @export
#'
#' @examples
#' notate("8", "Solo")
#' phrase("c'~ c' d' e'", pc(notate(8, "First solo"), "8 8 4."), "5 5 5 5")
notate <- function(x, text, position = "top"){
  pos <- switch(position, top = "^", bottom = "_")
  paste0(x, ";", pos, "\"", gsub(" ", "_", text), "\"", collapse = " ")
}

#' Concatenate and repeat
#'
#' Helper functions for concatenating musical phrases and raw strings
#' together as well as repetition.
#'
#' Note: When working with special `tabr` classes, you can simply use generics
#' like `c()` and `rep()` as many custom methods exist for these classes. The
#' additional respective helper functions, `pc()` and `pn()`, are more
#' specifically for phrase objects and when you are still working with character
#' strings, yet to be converted to a phrase object (numbers not yet in string
#' form are allowed). See examples.
#'
#' The functions `pc()` and `pn()` are based on base functions `paste()` and
#' `rep()`, respectively, but are tailored for efficiency in creating musical
#' phrases.
#'
#' These functions respect and retain the phrase class when applied to phrases.
#' They are aggressive for phrases and secondarily for noteworthy strings.
#' Combining a phrase with a non-phrase string will assume compatibility and
#' result in a new phrase object.
#' If no phrase objects are present, the presence of any noteworthy string will
#' in turn attempt to force conversion of all strings to noteworthy strings.
#' The aggressiveness provides convenience, but is counter to expected coercion
#' rules. It is up to the user to ensure all inputs can be forced into the more
#' specific child class.
#'
#' This is especially useful for repeated instances. This function applies to
#' general slur notation as well.
#' Multiple input formats are allowed. Total number of note durations must be
#' even because all slurs require start and stop points.
#'
#' @param ... character, phrase or non-phrase string.
#' @param x character, phrase or non-phrase string.
#' @param n integer, number of repetitions.
#' @name append_phrases
#'
#' @return phrase on non-phrase character string, noteworthy string if
#' applicable.
#'
#' @examples
#' pc(8, "16-", "8^")
#' pn(1, 2)
#' x <- phrase("c ec'g' ec'g'", "4 4 2", "5 432 432")
#' y <- phrase("a", 1, 5)
#' pc(x, y)
#' pc(x, pn(y, 2))
#' pc(x, "r1") # add a simple rest instance
#' class(pc(x, y))
#' class(pn(y, 2))
#' class(pc(x, "r1"))
#' class(pn("r1", 2))
#' class(pc("r1", "r4"))
NULL

#' @export
#' @rdname append_phrases
pc <- function(...){
  x <- list(...)
  classes <- unlist(lapply(x, class))
  if(any(!classes %in% c("phrase", "noteworthy", "character", "numeric", "integer")))
    stop("pc() is only for phrase objects, noteworthy and simple character strings.",
         call. = FALSE)
  any_phrase <- any(classes == "phrase")
  nw <- any(sapply(unlist(x), noteworthy))
  x <- trimws(gsub("\\s\\s+", " ", paste(unlist(x), collapse = " ")))
  if(any_phrase){
    class(x) <- unique(c("phrase", class(x)))
  } else if(nw){
    x <- .asnw(x)
  }
  x
}


#' @export
#' @rdname append_phrases
pn <- function(x, n = 1){
  classes <- class(x)
  if(any(!classes %in% c("phrase", "noteworthy", "character", "numeric", "integer")))
    stop("pn() is only for phrase objects, noteworthy and simple character strings.",
         call. = FALSE)
  if(n == 0) n <- 1
  y <- trimws(gsub("\\s\\s+", " ", paste(rep(x, n), collapse = " ")))
  if("phrase" %in% classes){
    class(y) <- unique(c("phrase", class(y)))
  } else if(is.character(x) && noteworthy(x)){
    y <- .asnw(y)
  }
  y
}

#' Hammer ons and pull offs
#'
#' Helper function for generating hammer on and pull off syntax.
#'
#' This is especially useful for repeated instances. This function applies to
#' general slur notation as well.
#' Multiple input formats are allowed. Total number of note durations must be
#' even because all slurs require start and stop points.
#'
#' @param ... character, note durations. Numeric is allowed for lists of single
#' inputs. See examples.
#'
#' @return character.
#' @export
#'
#' @examples
#' hp(16, 16)
#' hp("16 16")
#' hp("16 8 16", "8 16 8")
hp <- function(...){
  x <- unlist(purrr::map(list(...), ~{
    paste0(strsplit(as.character(paste0(.x, collapse = " ")), " ")[[1]])
  }))
  if(length(x) %% 2 == 1)
    stop("Even number of arguments required.", call. = FALSE)
  idx <- seq_along(x) %% 2 == 0
  x[idx == TRUE] <- paste0(x[idx == TRUE], ")")
  x[idx == FALSE] <- paste0(x[idx == FALSE], "(")
  paste(x, collapse = " ")
}

#' Tuplets
#'
#' Helper function for generating tuplet syntax.
#'
#' This function gives control over tuplet construction. The default arguments
#' `a = 3` and `b = 2` generates a triplet where three triplet notes,
#' each lasting for two thirds of a beat, take up two beats.
#' `n} is used to describe the beat duration with the same
#' fraction-of-measure denominator notation used for notes in `tabr` phrases,
#' e.g., 16th note triplet, 8th note triplet, etc.
#'
#' If you provide a note sequence for multiple tuplets in a row of the same
#' type, they will be connected automatically. It is not necessary to call
#' `tuplet()` each time when the pattern is constant.
#' If you provide a complete phrase object, it will simply be wrapped in the
#' tuplet tag, so take care to ensure the phrase contents make sense as part of
#' a tuplet.
#'
#' @param x noteworthy string or phrase object.
#' @param n integer, duration of each tuplet note, e.g., 8 for 8th note tuplet.
#' @param string, character, optional string or vector with same number of
#' timesteps as `x` that specifies which strings to play for each specific
#' note. Only applies when `x` is a noteworthy string.
#' @param a integer, notes per tuplet.
#' @param b integer, beats per tuplet.
#'
#' @return phrase
#' @export
#'
#' @examples
#' tuplet("c c# d", 8)
#' triplet("c c# d", 8)
#' tuplet("c c# d c c# d", 4, a = 6, b = 4)
#'
#' p1 <- phrase("c c# d", "8-. 8( 8)", "5*3")
#' tuplet(p1, 8)
tuplet <- function(x, n, string = NULL, a = 3, b = 2){
  if("phrase" %in% class(x)){
    x <- paste0("\\tuplet ", a, "/", b, " ", n / b, " { ", x, " }")
    class(x) <- c("phrase", class(x))
    return(x)
  } else {
    notes <- x
  }
  notes <- .uncollapse(notes)
  notes <- .octave_to_tick(.notesub(notes))
  s <- !is.null(string)
  if(s){
    string <- .uncollapse(string)
    if(length(string) == 1) string <- rep(string, length(notes))
    if(length(string) != length(notes))
      stop(paste("`string` must have the same number of timesteps as `x`,",
                 "or a single value to repeat, or be NULL."), call. = FALSE)
    string <- .strsub(string)
  }
  notes <- purrr::map_chr(
    seq_along(notes),
    ~paste0(
      "<", paste0(.split_chord(notes[.x]),
                  if(s && notes[.x] != "r" && notes[.x] != "s")
                    paste0("\\", .split_chord(string[.x], TRUE)),
                  collapse = " "), ">"))
  notes[1] <- paste0(notes[1], n)
  notes <- paste0(notes, collapse = " ")
  notes <- gsub("<r>", "r", notes)
  notes <- gsub("<s>", "s", notes)
  x <- paste0("\\tuplet ", a, "/", b, " ", n / b, " { ", notes, " }")
  class(x) <- c("phrase", class(x))
  x
}

#' @export
#' @rdname tuplet
triplet <- function(x, n, string = NULL){
  tuplet(x = x, n = n, string = string, a = 3, b = 2)
}
