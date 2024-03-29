#' Define chords
#'
#' Function for creating new chord definition tables.
#'
#' This function creates a tibble data frame containing information defining
#' various attributes of chords.
#' It is used to create the `guitarChords` dataset, but can be used to create
#' other pre-defined chord collections.
#' The tibble has only one row, providing all information for the defined chord.
#' The user can decide which arguments to vectorize over when creating a chord
#' collection. See examples.
#'
#' This function uses a vector of fret integers (`NA` for muted string) to
#' define a chord, in conjunction with a string `tuning` (defaults to standard
#' tuning, six-string guitar). `fret` is from lowest to highest pitch strings,
#' e.g., strings six through one.
#'
#' The `id` is passed directly to the output. It represents the type of chord
#' and should conform to accepted `tabr` notation. See `id` column in
#' `guitarChords` for examples.
#'
#' Note that the `semitones` column gives semitone intervals between chord
#' notes. These count from zero as the lowest pitch based on the tuning of the
#' instrument, e.g., zero is E2 with standard guitar tuning. To convert these
#' semitone intervals to standard semitone values assigned to pitches, use
#' e.g., `pitch_semitones("e2")` (40) if that is the lowest pitch and add
#' that value to the instrument semitone interval values.
#' This is the explanation, but doing this is not necessary. You can use
#' [chord_semitones()] to compute semitones directly on pitches in a
#' chord.
#'
#' @param fret integer vector defining fretted chord. See details.
#' @param id character, the chord type. See details.
#' @param optional `NA` when all notes required. Otherwise an integer
#' vector giving the indices of`fret` that are considered optional notes
#' for the chord.
#' @param tuning character, string tuning. See `tunings` for predefined
#' tunings. Custom tunings are specified with a similar `value` string.
#' @param ... additional arguments passed to `transpose()`.
#'
#' @return a data frame
#' @export
#'
#' @examples
#' frets <- c(NA, 0, 2, 2, 1, 0)
#' chord_def(frets, "m")
#' chord_def(frets, "m", 6)
#'
#' purrr::map_dfr(c(0, 2, 3), ~chord_def(frets + .x, "m"))
chord_def <- function(fret, id, optional = NA, tuning = "standard", ...){
  min_fret <- min(fret, na.rm = TRUE)
  idx <- which(!is.na(fret))
  root_fret <- fret[idx[1]]
  x <- .split_chords(.map_tuning(tuning))
  n <- length(x)
  bass_string <- (n:1)[min(idx)]

  f <- function(x){
    if(is.na(x)){
      "x"
    } else if(x == 0){
      "o"
    } else if(nchar(x) == 2){
      paste0("(", x, ")")
    } else {
      x
    }
  }

  f2 <- function(x){
    if(is.na(x)){
      "x"
    } else if(x == 0){
      "o"
    } else {
      x
    }
  }

  fret2 <- sapply(fret, f)
  fret3 <- paste(sapply(fret, f2), collapse = " ")
  fretboard <- chord_set(fret3, id, n = n)
  semitones <- fret + c(
    0,
    cumsum(sapply(1:(length(x) - 1),
                  function(i) pitch_interval(x[i], x[i + 1])))
    )

  dots <- list(...)
  o <- ifelse(is.null(dots$octaves), "tick", dots$octaves)
  a <- ifelse(is.null(dots$accidentals), "flat", dots$accidentals)
  k <- dots$key
  notes <- sapply(1:6, function(i){
    if(!i %in% idx) NA else transpose(x[i], fret[i], o, a, k)
  })
  if(!any(is.na(optional))) optional <- paste(notes[optional], collapse = " ")

  pitch1 <- notes[idx][1]
  root <- .pitch_to_note(pitch1)
  octave <- .pitch_to_octave(pitch1)
  notes <- paste(notes[idx], collapse = "")
  lp_name <- lp_chord_id(pitch1, id, ...)

  tibble::tibble(
    id = id, lp_name = lp_name,
    root = root, octave = octave, root_fret = root_fret, min_fret = min_fret,
    bass_string = bass_string, notes = notes,
    frets = paste(fret2, collapse = ""), semitones = list(semitones),
    optional = optional, fretboard = fretboard, open = "o" %in% fret2)
}

#' LilyPond chord notation
#'
#' Obtain LilyPond quasi-chord notation.
#'
#' These functions take a `tabr` syntax representation of a chord name and
#' convert it to quasi-LilyPond syntax;
#' "quasi" because the result still uses `_` for flats and `#` for sharps,
#' whereas LilyPond itself uses `es` and `is` (mostly).
#' This is the format used by `tabr` functions involved in communicating with
#' LilyPond for music transcription, and they make these final conversions on
#' the fly.
#' This can be overridden with `exact = TRUE`.
#'
#' @param root character, root note.
#' @param chord character, `tabr` format chord name.
#' @param exact logical, return a more exact LilyPond chord representation.
#' @param ... additional arguments passed to `transpose()`.
#'
#' @return character
#' @export
#'
#' @examples
#' lp_chord_id("a a a", "m M m7_5")
#' lp_chord_mod("a a a", "m M m7_5")
#' lp_chord_id("a a a", "m M m7_5", exact = TRUE)
#' lp_chord_mod("a a a", "m M m7_5", exact = TRUE)
lp_chord_id <- function(root, chord, exact = FALSE, ...){
  root <- .uncollapse(.octave_to_tick(root))
  chord <- .uncollapse(chord)
  x <- paste0(root, ":", sapply(chord, function(y){
    if(y == "M") return("5")
    if(y == "mM7") return("m7+")
    if(grepl("mb\\d+", y)){
      y <- gsub("(.*)(b)(\\d+)(.*)", "\\1\\3-\\4", y)
      y <- gsub("(.*)(b)(\\d+)(.*)", "\\1\\3-\\4", y)
    } else if(grepl("b\\d+", y)){
      y <- gsub("(.*)(b)(\\d+)(.*)", "\\1\\.\\3-\\4", y)
      y <- gsub("(.*)(b)(\\d+)(.*)", "\\1\\.\\3-\\4", y)
    }
    if(grepl("m#\\d+", y)){
      y <- gsub("(.*)(#)(\\d+)(.*)", "\\1\\3+\\4", y)
      y <- gsub("(.*)(#)(\\d+)(.*)", "\\1\\3+\\4", y)
    } else if(grepl("#\\d+", y)){
      y <- gsub("(.*)(#)(\\d+)(.*)", "\\1\\.\\3+\\4", y)
      y <- gsub("(.*)(#)(\\d+)(.*)", "\\1\\.\\3+\\4", y)
    }
    y <- gsub("M", "maj", y)
    y <- gsub("^madd", "m5\\.", y)
    y <- gsub("^add", "5\\.", y)
    y <- gsub("add", "\\.", y)
    y
  }
  ))
  idx <- grep(".*/\\d+$", x)
  if(length(idx)){
    x[idx] <- sapply(seq_along(x[idx]), function(z){
      i <- as.integer(gsub(".*/(\\d+)$", "\\1", x[idx][z]))
      i <- .pitch_to_note(transpose(root[idx][z], i, ...))
      gsub("(.*/)(\\d+)$", paste0("\\1", i), x[idx][z])
    })
  }
  if(exact){
    x <- gsub("#", "is", x)
    x <- gsub("_", "es", x)
    x <- gsub("(a|e)es", "\\1s", x)
  }
  x
}

#' @export
#' @rdname lp_chord_id
lp_chord_mod <- function(root, chord, exact = FALSE, ...){
  x <- sapply(strsplit(lp_chord_id(root, chord, exact, ...), ":"), "[", 2)
  if(exact){
    x <- gsub("#", "is", x)
    x <- gsub("_", "es", x)
    x <- gsub("(a|e)es", "\\1s", x)
  }
  x
}

#' Chord mapping
#'
#' Helper functions for chord mapping.
#'
#' These functions assist with mapping between different information that
#' define chords.
#'
#' For `gc_is_known()`, a check is done against chords in the `guitarChords`
#' dataset. A simple noteworthy string is permitted, but any single-note entry
#' will automatically yield a `FALSE` result.
#'
#' `gc_info()` returns a tibble data frame containing complete information for
#' the subset of predefined guitar chords specified by `name` and `key`.
#' Any accidentals present in the chord root of `name` (but not in the chord
#' modifier, e.g., `m7_5` or `m7#5`) are converted according to `key` if
#' necessary.
#' `gc_notes()` and `gc_fretboard()` are wrappers around `gc_info()`, which
#' return noteworthy strings of chord notes and a named vector of LilyPond
#' fretboard diagram data, respectively.
#' Note that although the input to these functions can contain multiple chord
#' names, whether as a vector or as a single space-delimited string, the result
#' is not intended to be of equal length.
#' These functions filter `guitarChords`. The result is the set of all
#' chords matched by the supplied input filters.
#'
#' `gc_name_split()` splits a vector or space-delimited set of chord names into
#' a tibble data frame containing separate chord root and chord modifier columns.
#' `gc_name_root()` and `gc_name_mod()` are wrappers around this.
#'
#' @param notes character, a noteworthy string.
#' @param name character, chord name in `tabr` format, e.g., `"bM b_m b_m7#5"`,
#' etc.
#' @param root_octave integer, optional filter for chords whose root note is in
#' a set of octave numbers. May be a vector.
#' @param root_fret integer, optional filter for chords whose root note matches
#' a specific fret. May be a vector.
#' @param min_fret integer, optional filter for chords whose notes are all at
#' or above a specific fret. May be a vector.
#' @param bass_string integer, optional filter for chords whose lowest pitch
#' string matches a specific string, 6, 5, or 4. May be a vector.
#' @param open logical, optional filter for open and movable chords. `NULL`
#' retains both types.
#' @param key character, key signature, used to enforce type of accidentals.
#' @param ignore_octave logical, if `TRUE`, functions like `gc_info()` and
#' `gc_fretboard()` return more results.
#'
#' @return various, see details regarding each function.
#' @export
#' @name chord-mapping
#'
#' @examples
#' gc_is_known("a b_,fb_d'f'")
#'
#' gc_name_root("a aM b_,m7#5")
#' gc_name_mod("a aM b_,m7#5")
#'
#' gc_info("a") # a major chord, not a single note
#' gc_info("ceg a#m7_5") # only second entry is a guitar chord
#' gc_info("ceg a#m7_5", key = "f")
#'
#' gc_info("a,m c d f,")
#' gc_fretboard("a,m c d f,", root_fret = 0:3)
#' gc_notes_to_fb("a,eac'e' cgc'e'g'")
#'
#' x <- gc_notes("a, b,", root_fret = 0:2)
#' summary(x)
#'
gc_info <- function(name, root_octave = NULL, root_fret = NULL, min_fret = NULL,
                    bass_string = NULL, open = NULL, key = "c",
                    ignore_octave = TRUE){
  .keycheck(key)
  sharp <- key_is_sharp(key)
  f <- if(sharp) .flat_to_sharp else .sharp_to_flat
  x <- gc_name_split(name)
  by <- c(id = "mod", root = "root")
  if(!ignore_octave){
    x$octave <- sapply(x$root, .pitch_to_octave)
    by <- c(by, octave = "octave")
  }
  x$root <- as.character(.pitch_to_note(sapply(x$root, f)))
  d <- dplyr::filter(tabr::guitarChords,
                     !grepl(if(sharp) "_" else "#", .data[["notes"]]))
  x$mod <- factor(x$mod, levels = levels(d$id))
  d <- dplyr::inner_join(d, x, by = by)
  if(!any(is.null(root_octave)))
    d <- dplyr::filter(d, .data[["octave"]] %in% !!root_octave)
  if(!any(is.null(root_fret)))
    d <- dplyr::filter(d, .data[["root_fret"]] %in% !!root_fret)
  if(!any(is.null(min_fret)))
    d <- dplyr::filter(d, .data[["min_fret"]] %in% !!min_fret)
  if(!any(is.null(bass_string)))
    d <- dplyr::filter(d, .data[["bass_string"]] %in% !!bass_string)
  if(!is.null(open)) d <- dplyr::filter(d, .data[["open"]] == !!open)
  d
}

#' @export
#' @rdname chord-mapping
gc_fretboard <- function(name, root_octave = NULL, root_fret = NULL,
                         min_fret = NULL, bass_string = NULL, open = NULL,
                         key = "c", ignore_octave = TRUE){
  d <- gc_info(name, root_octave, root_fret, min_fret, bass_string, open, key,
               ignore_octave)
  stats::setNames(d$fretboard, d$lp_name)
}

#' @export
#' @rdname chord-mapping
gc_notes_to_fb <- function(notes, root_octave = NULL, root_fret = NULL,
                           min_fret = NULL, bass_string = NULL, open = NULL){
  .check_noteworthy(notes)
  x <- .octave_to_tick(.uncollapse(notes))

  d <- tabr::guitarChords
  if(!any(is.null(root_octave)))
    d <- dplyr::filter(d, .data[["octave"]] %in% !!root_octave)
  if(!any(is.null(root_fret)))
    d <- dplyr::filter(d, .data[["root_fret"]] %in% !!root_fret)
  if(!any(is.null(min_fret)))
    d <- dplyr::filter(d, .data[["min_fret"]] %in% !!min_fret)
  if(!any(is.null(bass_string)))
    d <- dplyr::filter(d, .data[["bass_string"]] %in% !!bass_string)
  if(!is.null(open)) d <- dplyr::filter(d, .data[["open"]] == !!open)

  rows <- match(x, d$notes)
  idx <- !is.na(rows)
  if(!any(idx)) return(as.character(rows))
  d <- dplyr::slice(d, rows[idx])
  x[idx] <- d$fretboard
  if(any(!idx)) x[!idx] <- NA_character_
  names(x)[idx] <- d$lp_name
  x
}

#' @export
#' @rdname chord-mapping
gc_notes <- function(name, root_octave = NULL, root_fret = NULL,
                     min_fret = NULL, bass_string = NULL, open = NULL,
                     key = "c", ignore_octave = TRUE){
  x <- gc_info(name, root_octave, root_fret, min_fret, bass_string, open, key,
               ignore_octave)$notes
  if(length(name) == 1) x <- paste(x, collapse = " ")
  .asnw(x)
}

#' @export
#' @rdname chord-mapping
gc_is_known <- function(notes){
  .check_noteworthy(notes)
  .octave_to_tick(.uncollapse(untie(notes))) %in% tabr::guitarChords$notes
}

#' @export
#' @rdname chord-mapping
gc_name_split <- function(name){
  x <- .uncollapse(name)
  root <- gsub("(^[a-g])(#|_|)(,|'|).*", "\\1\\2\\3", x)
  mod <- gsub("(^[a-g])(#|_|)(,|'|)(.*)", "\\4", x)
  mod[mod == ""] <- "M"
  idx <- grep("M6", mod)
  if(length(idx)) mod[idx] <- gsub("M6", "6", mod[idx])
  tibble::tibble(root = root, mod = mod)
}

#' @export
#' @rdname chord-mapping
gc_name_root <- function(name){
  gc_name_split(name)$root
}

#' @export
#' @rdname chord-mapping
gc_name_mod <- function(name){
  gc_name_split(name)$mod
}
