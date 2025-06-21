## utility functions
library(rjags)
library(coda)
library(foreach)
add.mcmc = function(x, y)
{  
  nChains = length(x)
  n.var = nvar(x)
  newobjects = vector("list", length = nChains)
  
  for(i in 1:nChains)
  {
    newobjects[[i]] = matrix(NA, nrow = 0, ncol = n.var, dimnames = list(NULL, dimnames(x[[1]])[[2]]))
    newobjects[[i]] = rbind(x[[i]], y[[i]])
    newobjects[[i]] = mcmc(newobjects[[i]])
  }
  mcmc.list(newobjects)
}


transform.mcmc = function(x)
{  
  nChains = length(x)
  n.var = nvar(x)
  newobjects = vector("list", length = nChains)
  
  for(i in 1:nChains)
  {
    newobjects[[i]] = matrix(NA, nrow = 0, ncol = n.var, dimnames = list(NULL, dimnames(x[[1]])[[2]]))
    newobjects[[i]] = cbind(logRR=log(x[[i]][,'RR_y']), logOR=log(x[[i]][,'OR_y']))
    newobjects[[i]] = mcmc(newobjects[[i]])
  }
  mcmc.list(newobjects)
}


subset.mcmc <-  function(x, select.pars){  
  nChains = length(x)
  n.var = nvar(x)
  newobjects = vector("list", length = nChains)
  
  for(i in 1:nChains)
  {
    newobjects[[i]] = matrix(NA, nrow = 0, ncol = n.var, dimnames = list(NULL, dimnames(x[[1]])[[2]]))
    newobjects[[i]] = x[[i]][,select.pars]
    newobjects[[i]] = mcmc(newobjects[[i]])
  }
  mcmc.list(newobjects)
}
