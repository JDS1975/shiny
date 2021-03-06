% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test-server.R
\name{testServer}
\alias{testServer}
\title{Reactive testing for Shiny server functions and modules}
\usage{
testServer(app = NULL, expr, args = list(), session = MockShinySession$new())
}
\arguments{
\item{app}{The path to an application or module to test. In addition to
paths, applications may be represented by any object suitable for coercion
to an \code{appObj} by \code{\link{as.shiny.appobj}}. Application server functions must
include a \code{session} argument in order to be tested. If \code{app} is \code{NULL} or
not supplied, the nearest enclosing directory that is a Shiny app, starting
with the current directory, is used.}

\item{expr}{Test code containing expectations. The test expression will run
in the server function environment, meaning that the parameters of the
server function (e.g. \code{input}, \code{output}, and \code{session}) will be available
along with any other values created inside of the server function.}

\item{args}{Additional arguments to pass to the module function. If \code{app} is
a module, and no \code{id} argument is provided, one will be generated and
supplied automatically.}

\item{session}{The \code{\link{MockShinySession}} object to use as the \link[shiny:domains]{reactive domain}. The same session object is used as the domain both
during invocation of the server or module under test and during evaluation
of \code{expr}.}
}
\description{
A way to test the reactive interactions in Shiny applications. Reactive
interactions are defined in the server function of applications and in
modules.
}
\examples{
server <- function(id, multiplier = 2, prefix = "I am ") {
  moduleServer(id, function(input, output, session) {
    myreactive <- reactive({
      input$x * multiplier
    })
    output$txt <- renderText({
      paste0(prefix, myreactive())
    })
  })
}

testServer(server, args = list(multiplier = 2), {
  session$setInputs(x = 1)
  # You're also free to use third-party
  # testing packages like testthat:
  #   expect_equal(myreactive(), 2)
  stopifnot(myreactive() == 2)
  stopifnot(output$txt == "I am 2")

  session$setInputs(x = 2)
  stopifnot(myreactive() == 4)
  stopifnot(output$txt == "I am 4")
  # Any additional arguments, below, are passed along to the module.
})
}
