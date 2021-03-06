#' @importFrom stats pnorm
#' @title One Sample Test of Proportion
#' @description  \code{prop_test} compares proportion in one group to a
#' specified population proportion.
#' @param n number of observations
#' @param prob hypothesised proportion
#' @param phat observed proportion
#' @param alternative a character string specifying the alternative hypothesis,
#' must be one of "both" (default), "greater", "less" or "all". You can specify
#' just the initial letter.
#' @param ... other arguments
#' @return \code{prop_test} returns an object of class \code{"prop_test"}.
#' An object of class \code{"prop_test"} is a list containing the
#' following components:
#'
#' \item{n}{number of observations}
#' \item{phat}{proportion of 1's}
#' \item{p}{assumed probability of success}
#' \item{z}{z statistic}
#' \item{sig}{p-value for z statistic}
#' \item{alt}{alternative hypothesis}
#' \item{obs}{observed number of 0's and 1's}
#' \item{exp}{expected number of 0's and 1's}
#' \item{deviation}{deviation of observed from expected}
#' \item{std}{standardized resiudals}
#'
#' @references Sheskin, D. J. 2007. Handbook of Parametric and Nonparametric
#' Statistical Procedures, 4th edition. : Chapman & Hall/CRC.
#' @seealso \code{\link[stats]{prop.test}} \code{\link[stats]{binom.test}}
#' @examples
#' # use as a calculator
#' prop_test(200, prob = 0.5, phat = 0.3)
#'
#' # using data set
#' prop_test(as.factor(hsb$female), prob = 0.5)
#' @export
#'
prop_test <- function(n, prob = 0.5, alternative = c('both', 'less',
  'greater', 'all'),...) UseMethod('prop_test')

#' @export
#' @rdname prop_test
#'
prop_test.default <- function(n, prob = 0.5,
                      alternative = c('both', 'less', 'greater', 'all'), phat, ...) {


  if (!is.numeric(n)) {
    stop('n must be numeric')
  }

  if (!is.numeric(phat)) {
    stop('phat must be numeric')
  }

  if (phat < 0 | phat > 1) {
    stop('phat must be between 0 and 1')
  }

  if (!is.numeric(prob)) {
    stop('prob must be numeric')
  }

  if (prob < 0 | prob > 1) {
    stop('prob must be between 0 and 1')
  }

  method <- match.arg(alternative)
  k <- prop_comp(n, prob, method, phat)
	
  result <- list(n = k$n, phat = k$phat, p = k$p, z = k$z, sig = k$sig, 
      alt = k$alt, obs = k$obs, exp = k$exp, deviation = k$deviation, 
            std = k$std)

    class(result) <- 'prop_test'
    return(result)

}

#' @export
#'
print.prop_test <- function(x, ...) {
  print_prop_test(x)
}


#' @export
#' @rdname prop_test
#'
prop_test.factor <- function(n, prob = 0.5,
  alternative = c('both', 'less', 'greater', 'all'), ...) {

  if (!is.numeric(prob)) {
    stop('prob must be numeric')
  }

  if((prob < 0) | (prob > 1)) {
    stop('prob must be between 0 and 1')
  }


	if (nlevels(n) > 2) {
		stop('Please specify a categorical variable with only 2 levels.')
	}

  n1 <- length(n)
	n2 <- table(n)[[2]]
	phat <- round(n2 / n1, 4)
  prob <- prob
  alternative <- alternative

  prop_test.default(n1, prob, alternative, phat)

}
