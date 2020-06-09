Block <- R6::R6Class("Block",
  public = list(
    txt = character(),
    divs = integer(),
    code = matrix(integer(), nrow = 0, ncol = 2),
    doc = "",
    initialize = function(txt, doc = "^#+'[ ]?") {
      if (length(txt) == 1) {
        txt <- strsplit(txt, "\n")
      }
      tloc <- grepl(glue::glue("{doc}[@]"), txt)
      tags <- sub(glue::glue("{doc}[@]([a-z]+?)$"), "\\1", txt[tloc])
      breaks <- which(tloc)
      names(breaks) <- tags
      self$txt <- txt
      self$divs <- breaks
      self$code <- get_code_boundaries(grepl(doc, txt))
      self$doc <- doc
    },
    transform = function() {
      out <- character(length(self$txt) + (2 * nrow(self$code)) + length(self$div))
      N <- length(self$txt)
      line <- i <- 1
      while (i <= N) {
        txt <- sub(self$doc, "", self$txt[i])
        message(txt)
        ladd <- 1
        if (i %in% self$divs) {
          out[line] <- private$div()
        } else if (i %in% self$code) {
          out[line] <- private$fence(i, txt)
        } else {
          out[line] <- txt
        }
        i <- i + 1
        line <- line + ladd
      }
      out[line] <- private$vid()
      if (length(out) > line) {
        out <- out[-seq(line + 1L, length(out))]
      }
      private$reset()
      out
    }
  ),
  private = list(
    reset = function() {
      private$i_div <- 1L
      private$i_code <- 1L
      private$ndiv <- 0L
    },
    ndiv = 0L,
    i_div = 1L,
    i_code = 1L,
    fence = function(i, x = "") {
      if (i == self$code[private$i_code, 1, drop = TRUE]) {
        x <- glue::glue("\n{x}")
        glue::glue("```{sub('^\n?#+?[+]', '', x)}")
      } else {
        private$i_code <- private$i_code + 1L
        glue::glue("{x}\n```")
      }
    },
    div = function() {
      previous_div <- names(self$divs[private$i_div - 1L])
      should_close <- length(previous_div) && previous_div == "solution"
      what <- names(self$divs[private$i_div])
      the_thing <- glue::glue("<div class='{what}'>")
      if (should_close) {
        increment <- -1L
        the_thing <- if (what == "challenge") "" else the_thing
        open <- private$vid(1L)
      } else {
        increment <- 1L
        open <- "\n"
      }
      private$ndiv <- private$ndiv + increment
      out <- glue::glue("{open}{the_thing}\n\n")
      private$i_div <- private$i_div + 1L
      return(out)
    },
    vid = function(n = private$ndiv) glue::glue("\n{paste(rep('</div>', n), collapse = '')}\n\n")
  )
)
