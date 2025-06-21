source("utility_functions.R")
run_jags_nof1_iv <- function(model.file = 'nof1_carryover_model.txt',
                             input, # input data dimension: TJ x 3 : Y (outcome), X (treatment selection), R (treatment assignment)
                             model.inits = list(beta0 = c(-2,0,2),
                                                 beta1 = c(-2,0,2),
                                                 beta2 = c(-2,0,2),
                                                 alpha0 = c(-2,0,2),
                                                 alpha1 = c(-2,0,2),
                                                 alpha2 = c(-2,0,2)),
                             # MCMC set up
                             nruns = 5000,
                             n.chains= 3,
                             conv.limit = 1.01,
                             niters = 500000,
                             setsize = 1000,
                             # check specified parameters for convergence
                             conv.pars = c('beta0', 'beta1','beta2',
                                            'alpha0','alpha1','sigma_e','rho_w','rhoxy',
                                            'log_CAE','log_CRR','log_COR','CAE') , 
                             # save posterior samples for specified parameters
                             sample.pars = c('p_x0','p_x1','p_y0','p_y1','log_CRR','log_COR','rhoxy'),
                             # save summary stats for specified parameters
                             stats.pars = unique(c(conv.pars,sample.pars)), 
                             output.folder = 'Output',
                             output.name = 'Test',
                             #specify priors
                             alpha0_mean = NA,
                             alpha1_mean = NA,
                             beta0_mean =NA,
                             coef.var = 1,
                             trunc.var = 100  #truncate extreme values to optimize computation,
                             
){
  if( is.na(alpha0_mean)) alpha0_mean = qnorm(mean(input$X[input$R==0]))
  if(is.na(alpha1_mean)) alpha1_mean = qnorm(mean(input$X[input$R==1]))-qnorm(mean(input$X[input$R==0]))
  if(is.na(beta0_mean)) {
    rate = ifelse(mean(input$Y[input$R==0])==0,-2,mean(input$Y[input$R==0]))
    beta0_mean = qnorm(rate)
  }
  # input for MCMC
  data.input = list(Y  = matrix(input$Y,nrow=1),
                    R  = matrix(input$R,nrow=1),
                    X = matrix(input$X,nrow=1),
                    N=1,
                    J = length(input$Y),
                    coef.var = coef.var,
                    trunc.var = trunc.var,
                    alpha0_mean_prior=alpha0_mean,
                    alpha1_mean_prior=alpha1_mean,
                    beta0_mean_prior=beta0_mean)
  
  model.fit <- jags.model(file=model.file,
                          data=data.input, n.chains = n.chains,quiet = TRUE)
  done.adapt = adapt(model.fit, n.iter = 2000, end.adaptation = FALSE)
  print('done.adapt')
  print(done.adapt)
  while (!done.adapt) done.adapt = adapt(mod, n.iter = 2000, end.adaptation = FALSE, quiet = TRUE)
  
  update(model.fit, 2000)
  
  ########## check for convergence ########
  summ.all.sim <- coda.samples(model.fit, stats.pars, n.iter = nruns)
  GRstat = gelman.diag(summ.all.sim, multivariate = FALSE)[[1]][,1]
  max_gr = max(GRstat[names(GRstat) %in% conv.pars])
  check = ifelse(max_gr > conv.limit|is.nan(max_gr),T,F)
  count=NULL
  if(check) {
    count = 1
    progress = 100 * count / (niters / setsize)
    while (check & progress < 100) 
    {   
      samples_add = coda.samples(model.fit, stats.pars, n.iter = setsize,thin=1)
      samples_add_n = summ.all.sim[[1]][1] + setsize
      count = count + 1
      summ.all.sim = add.mcmc(summ.all.sim, samples_add)
      GRstat = gelman.diag(summ.all.sim, multivariate = FALSE)[[1]][,1]
      GRstat.sub = GRstat[names(GRstat) %in% conv.pars]
      print(GRstat.sub)
      max_gr = max(GRstat.sub)
      check = ifelse(max_gr > conv.limit|is.nan(max_gr),T,F)
      progress = 100 * count / (niters / setsize)
      cat(max_gr, "\t \t", progress, "\n")
      print(GRstat.sub[GRstat.sub > conv.limit])     
    }
  }  
  
  if(check == TRUE){
    print(paste0("Fail to Converge_Model"))
    fileConn<-file(paste0(output.folder,'/Fail_to_converge/', output.name,'_fail.txt'))
    writeLines(c("fail"), fileConn)
    close(fileConn)
  }

  if (check != TRUE){
    stats.all.sim <-  summary(window(summ.all.sim))
    samples.name = paste0(output.folder,'/Samples/',output.name,'.RData')
    stats.name = paste0(output.folder,'/Stats/',output.name,'.RData')
    save(summ.all.sim,file = samples.name)
    save(stats.all.sim,file = stats.name)
  }
}

