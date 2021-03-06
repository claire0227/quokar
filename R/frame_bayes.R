globalVariables(c("variable", "value"))
#'@title Mean probability of posterior distribution and
#'Kullback-Leibler divergence for observations in Bayesian
#'quantile regression model
#'@description
#'This function give the dataframe to plot the mean
#'probability of posterior and Kullback-leibler divergence
#'of quantile regression model with asymmetric laplace
#'distribution based on bayes estimation procedure.
#'@param y vector, dependent variable in quantile regression
#'@param x matrix, design matrix for quantile regression. For quantile regression
#' model with intercept, the firt column of x is 1.
#'@param tau sigular or vector, quantiles
#'@param M the iteration frequancy for MCMC used in Baysian estimation
#'@param burn burned MCMC draw
#'@param method the diagnostic method for outlier detection
#'@return Mean probability or Kullback-Leibler divergence for observations
#'in Bayesian quantile regression model
#' @export
#' @author Wenjing Wang \email{wenjingwangr@gmail.com}
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ais_female <- subset(ais, Sex == 1)
#' y <- ais_female$BMI
#' x <- ais_female$LBM
#' tau <- c(0.1, 0.5, 0.9)
#' case <- rep(1:length(y), length(tau))
#' prob <- frame_bayes(y, x, tau, M =  5000, burn = 1000,
#'                  method = 'bayes.prob')
#' prob_m <- cbind(case, prob)
#' ggplot(prob_m, aes(x = case, y = value )) +
#'   geom_point() +
#'   geom_text(aes(label = case)) +
#'   facet_wrap(~variable, scale = 'free') +
#'   xlab("case number") +
#'   ylab("Mean probability of posterior distribution")
#'
#' kl <- frame_bayes(y, x, tau, M = 5000, burn = 1000,
#'                 method = 'bayes.kl')
#' kl_m <- cbind(case, kl)
#' ggplot(kl_m, aes(x = case, y = value)) +
#'   geom_point() +
#'   geom_text(aes(label = case)) +
#'   facet_wrap(~variable, scale = 'free')+
#'   xlab('case number') +
#'   ylab('Kullback-Leibler')
#'}
#'
frame_bayes <- function(y, x, tau, M, burn,
                        method = c("bayes.prob", "bayes.kl")){
  if(!is.vector(y)){
    stop("y should be vector")
  }
  if(!is.matrix(x)){
    stop("x should be matrix")
  }
  method <- match.arg(method)
    ntau <- length(tau)
    if(method == 'bayes.prob'){
        distances <- qrod_bayes(y, x, tau, M, burn, method = 'bayes.prob')
    }else if(method == 'bayes.kl'){
        distances <- qrod_bayes(y, x, tau, M, burn, method = 'bayes.kl')
    }
    distance_m <- matrix(Reduce(c, distances),
                         ncol = ntau, byrow = FALSE)
    distance_f <- data.frame(distance_m)
    colnames(distance_f) <- paste('tau=', tau, sep = "")
    distance_g <- distance_f %>% gather(variable, value)
}
