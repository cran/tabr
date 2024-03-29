% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/time.R
\name{n_measures}
\alias{n_measures}
\alias{n_beats}
\alias{steps_per_measure}
\alias{bpm}
\alias{seconds}
\alias{seconds_per_measure}
\alias{seconds_per_step}
\alias{steps_start_time}
\title{Summarize rhythm and time of music objects}
\usage{
n_measures(x)

n_beats(x, unit = 4)

steps_per_measure(x)

bpm(x, unit = 4, tempo = NULL)

seconds(x, tempo = NULL)

seconds_per_measure(x, tempo = NULL)

seconds_per_step(x, tempo = NULL)

steps_start_time(x, tempo = NULL)
}
\arguments{
\item{x}{note info or music object.}

\item{unit}{character, or an equivalent integer. A beat unit. See details.}

\item{tempo}{character, LilyPond format tempo, e.g., "4 = 120" is 120
quarter note beats per minute.}
}
\value{
depends on function
}
\description{
These functions assist with summarizing temporal data for music objects.
}
\details{
These functions also work with the simpler \code{noteinfo} class, though some
functions require you to provide additional arguments.

Functions that deal with real time require a known tempo, which music
objects have. The simpler note info object does not contain this information.
You can provide a value to the \code{tempo} argument of such functions. This
overrides the tempo of \code{x} if a music object. But the reason to use
\code{tempo} is to provide one when \code{x} is a note info object.
By default \code{tempo = NULL}, in which case it will derive the value from
the music object or return an error for note info objects.

\code{n_measures()} gives the total number of measures covered by all timesteps.
Functions providing the number of beats and beats per minute both take a
\code{unit}, defaulting to 4 for quarter note beats. The unit can be any even
beat, triplet beat, dotted, or double dotted beat, from \code{"t32"} up to 1.

The number of timesteps starting in each measure is obtained with
\code{steps_per_measure()}.
}
\examples{
a <- notate("t8x", "Start here")
notes <- "a, b, c d e f g# a r ac'e' a c' e' c' r*3 ac'e'~ ac'e'"
info <- paste(a, "t8x t8-. 16 4.. 16- 16 2^ 2 4. 8( 4)( 4) 8*4 1 1")
info <- as_noteinfo(info)
x <- as_music(notes, info)

n_measures(info) # fraction indicates incomplete final measure
n_measures(x)

n_beats(x)
n_beats(x, 1)
n_beats(x, "t16")

bpm(x)
bpm(x, "t8")

seconds(x)
seconds(info, "4 = 120")
seconds(info, "2 = 60")
seconds(x, "4 = 100")

steps_per_measure(x)
seconds_per_measure(x)
seconds_per_step(x)
steps_start_time(x)
}
