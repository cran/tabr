% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{lilypond_root}
\alias{lilypond_root}
\alias{lilypond_version}
\alias{tabr_lilypond_api}
\title{LilyPond installation information}
\usage{
lilypond_root()

lilypond_version()

tabr_lilypond_api()
}
\value{
a message or system standard output.
}
\description{
Details about local LilyPond installation and package API.
}
\details{
Version information and installation directory are returned if the
installation can be found. The LilyPond API references the currently loaded
version of \code{tabr}.
}
\examples{
lilypond_root()
lilypond_version()
tabr_lilypond_api()
}
