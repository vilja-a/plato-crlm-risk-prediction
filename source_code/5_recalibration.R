
# ****************************************************************************************************************************************************** 
#                                             MODEL RECALIBRATION & PERFORMANCE MEASURES (CALIBRATION, NET BENEFIT)
# ****************************************************************************************************************************************************** 


# import data
library(tidyverse)
df_Karo <- read_csv('./output/KaroLiver_complete.csv')
head(df_Karo)

# recurrence status variables after CRLM resection
df_Karo$Recurrence_status_0.5 <- ifelse(df_Karo$RFS<=(365.25/2) & df_Karo$Recurrence_status == 1, 1, 0) # 6 months
df_Karo$Recurrence_status_1 <- ifelse(df_Karo$RFS<=(365.25) & df_Karo$Recurrence_status == 1, 1, 0) # 1 year
df_Karo$Recurrence_status_2 <- ifelse(df_Karo$RFS<=365.25*2 & df_Karo$Recurrence_status == 1, 1, 0) # 2 years
df_Karo$Recurrence_status_3 <- ifelse(df_Karo$RFS<=365.25*3 & df_Karo$Recurrence_status == 1, 1, 0) # 3 years


# function to fit a logistic regression model to predict outcome based on clinical risk score
fitLGM <- function(status, CRscore, d){
  formula <- as.formula(paste(status, "~", CRscore))
  M_lgm <- lrm(formula, data = d, x = TRUE) # no penalty
  d$p <- predict(M_lgm, d, type='fitted') # the actual predicted values (i.e survival probabilities), log transform of linear predictions plogit()
  d$lp <- predict(M_lgm, d, type='lp') # linear predictions
  #summary(M_lgm) # extract the model coefficients
  #print(vcov(M_lgm)) # covariance matrix
  # rename the columns with score name
  colnames(d)[colnames(d) == "p"] <- paste(c("p"),CRscore, status, sep="_") 
  colnames(d)[colnames(d) == "lp"] <- paste(c("lp"),CRscore, status, sep="_")
  return(d)
}


# scoring variables to factor
df_Karo$S_MetCount_3 <- factor(df_Karo$S_MetCount_3, levels = c('0', '1'))
df_Karo$S_preopCEA_200 <- factor(df_Karo$S_preopCEA_200, levels = c('0', '1'))
df_Karo$S_synchronous <- factor(df_Karo$S_synchronous, levels = c('0', '1'))
df_Karo$S_RAS <- factor(df_Karo$S_RAS, levels = c('0', '1'))
df_Karo$S_pN_status <- factor(df_Karo$S_pN_status, levels = c('0', '1'))
df_Karo$S_size <- factor(df_Karo$S_size, levels = c('0', '1'))
df_Karo$S_DFI_12m <- factor(df_Karo$S_DFI_12m, levels = c('0', '1'))
df_Karo$S_MetCount_1 <- factor(df_Karo$S_MetCount_1, levels = c('0', '1'))
df_Karo$S_pT_status_T3_4 <- factor(df_Karo$S_pT_status_T3_4, levels = c('0', '1'))
df_Karo$S_margin_5 <- factor(df_Karo$S_margin_5, levels = c('0', '1'))
df_Karo$S_vitality <- factor(df_Karo$S_vitality, levels = c('0', '1'))
df_Karo$S_VascInv <- factor(df_Karo$S_VascInv, levels = c('0', '1'))
df_Karo$S_BiliaryInv <- factor(df_Karo$S_pT_status_T4, levels = c('0', '1'))
df_Karo$S_pT_status_T4 <- factor(df_Karo$S_pT_status_T4, levels = c('0', '1'))
df_Karo$S_DFI_24m <- factor(df_Karo$S_DFI_24m, levels = c('0', '1'))
df_Karo$S_margin_10 <- factor(df_Karo$S_margin_10, levels = c('0', '1'))
df_Karo$S_Age <- factor(df_Karo$S_Age, levels = c('0', '1'))
df_Karo$S_KRAS <- factor(df_Karo$S_KRAS, levels = c('0', '1'))
df_Karo$S_preopCEA_20 <- factor(df_Karo$S_preopCEA_20, levels = c('0', '1'))
df_Karo$S_TBS <- factor(df_Karo$S_TBS, levels = c('0', '1', '2'))
df_Karo$S_resectiable_extrahepatic_mets <- factor(df_Karo$S_resectiable_extrahepatic_mets, levels = c('0', '1'))

# define formulas

# models with factors
Score_K=c("S_MetCount_3+S_preopCEA_200+S_synchronous")
Score_mCS=c("S_RAS+S_pN_status+S_size")
Score_F=paste("S_pN_status", "S_DFI_12m", "S_MetCount_1", "S_size","S_preopCEA_200", sep="+")
Score_H=paste("S_pN_status", "S_pT_status_T3_4", "S_MetCount_1", "S_margin_5", "S_size", "S_vitality", "S_VascInv", "S_BiliaryInv",sep="+")
Score_No=paste("S_pN_status", "S_pT_status_T4", "S_DFI_24m", "S_MetCount_3", "S_size", "S_margin_10", "S_Age", sep="+")
Score_GAME=paste("S_KRAS", "S_preopCEA_20","S_pN_status","S_TBS","S_resectiable_extrahepatic_mets",  sep="+")


# continuous scores use restricted cubic splines
Score_Na2006 <- "rcs(Score_Na2006,4)"


# risk prediction at 6 months after CRLM resection by GAME score (repeat for all the scores)
library(rms)
set.seed(123456)
df_Karo <- fitLGM("Recurrence_status_0.5", Score_GAME, df_Karo)

# for all the scores at once
formulas <- c(Score_K, Score_mCS, Score_F, Score_H, Score_No, Score_GAME, Score_Na2006)
M_0.5 <- list()

for (i in 1:length(formulas)) {
  M <- fit_M("Progression_status_0.5",formulas[i],df_Karo)
  M_0.5[[i]] <- M
} 

# name the list objects
names <- c('Score_K', 'Score_mCS', 'Score_F', 'Score_H', 'Score_No', 'Score_GAME', 'Score_Na2006')
names(Ms_0.5) <- names

## ----------------------------------------------------------------------- CALIBRATION -----------------------------------------------------------------


# function to compute calibration
CalibrationFrame <- function(time_days, status, predictions, score, timepoint){ #, opt) # with bootstrap optimism correction
  cal_df <- data.frame(cbind(time_days=time_days, status=status, predictions=predictions, score=score)) #, predictions=predictions-opt) # with bootstrap optimism correction
  cal_df <-cal_df%>% 
    mutate(event = ifelse(time_days >timepoint*365.25, 0, status), 
           time = pmin(time_days, 365.25*timepoint), # survival at 6 months 365.25*0.5
           p = pmin(predictions, 1)) %>%
    arrange(p)
  
  # calibration slope and calibration-in-the-large
  eps <- 1e-6
  cal_df$p_adj <- pmin(pmax(cal_df$p, eps), 1 - eps) # solve predictions in case of 0s or 1s
  l <- lrm(as.integer(event)~qlogis(p_adj), data=cal_df)
  
  # calibration
  cal_df$cumev <- cumsum(cal_df$event==1)
  m <- pmin(pmax(floor(max(cal_df$cumev) / 10), 30), 40) #Divide data into groups with similar number of events, aim to 8-12 groups 
  cal_df$set <- cal_df$cumev %/% m
  
  cdf <- cal_df %>% filter(!is.na(p)) %>% group_by(set) %>% 
    summarise(n = length(p),
              ev = sum(event == 1),
              mean_pred = mean(p),
              lower_pred = min(p), 
              upper_pred = max(p),
              mean_score = mean(score))
  cinc <- with(cal_df, cmprsk::cuminc(time, event, set))
  cinc$Tests <- NULL
  
  cinc <- sapply(1:(length(cinc)), function(i) {
    d <- as.data.frame(cinc[[i]])
    d <- unlist(d[nrow(d), ])
  }) %>% t %>% as.data.frame
  
  # collect variables into a table
  cdf$obs <- cinc$est
  cdf$lower <- pmax(cinc$est - 1.96 * sqrt(cinc$var), 0)
  cdf$upper <- pmin(cinc$est + 1.96 * sqrt(cinc$var), 1)
  cdf$year <- year
  
  cdf$citl <- l$coefficients[1]
  cdf$citl_lower <- l$coefficients[1]- 1.96 * sqrt(diag(vcov(l)))[1]
  cdf$citl_upper <- l$coefficients[1]+ 1.96 * sqrt(diag(vcov(l)))[1]
  
  cdf$slope <- l$coefficients[2]
  cdf$slope_lower <- l$coefficients[2]- 1.96 * sqrt(diag(vcov(l)))[2]
  cdf$slope_upper <- l$coefficients[2]+ 1.96 *sqrt(diag(vcov(l)))[2]
  
  return(cdf)
  
}

# calibration at 6 months after CRLM resection (without bootstrap-optimism correction)
#  // example with GAME score // repeat similarly for all scores

year <- 0.5
cdf_G<-CalibrationFrame(df_Karo$RFS, # time days
                          df_Karo$Recurrence_status, # status variable
                          df_Karo$p_Score_GAME_0.5, # risk predictions at 6 months
                          df_Karo$Score_GAME, # total score points
                          year) # time point of interest (years)


## ---------------------------------------------------------------- OBSERVED:EXPECTED RATIO --------------------------------------------------------------

# function to compute calibration measures
ObservedExpectedRatio <- function(time, event, p, timepoint, score){
  cinc <- as.data.frame(cmprsk::cuminc(time/365.25, event)[[1]])
  observed <- cinc[which(cinc$time > timepoint)[1] - 1, ] # survival at the time point of interest
  expected <- mean(p[time/365.25 <= timepoint]) # mean of the predicted events by the time point of interest
  
  oe <- c(score, round(timepoint, digits=1), observed$est, expected, 
          exp(log(observed$est) - log(expected) +
                c(0, -1, 1) * 1.96 * sqrt(var(p) / length(p) / expected ^ 2 +
                                            observed$var / observed$est ^ 2)))
  names(oe) <- c("Score","Years","Observed", "Expected", "OE_ratio", "Lower95", "Upper95")
  
  return(oe)
}


# calibration measures at 6 months after CRLM resection (without bootstrap-optimism correction)
#  // example with GAME score // repeat similarly for all scores

year <- 0.5
OE_G <- ObservedExpectedRatio(df_Karo$RFS, # time days
                          df_Karo$Recurrence_status, # status variable
                          df_Karo$p_Score_GAME_0.5, # risk predictions at 6 months
                          year, # time point of interest (years)
                          'GAME') # score name


## --------------------------------------------------------------------- NET BENEFIT ---------------------------------------------------------------------

# function to compute net benefit
NetBenefit <- function(risk, time, status, t_pred=year*365.25, event = 1, p_max = 1) { # p_max: risk threshold, 1: all are treated correctly.
  d <- data.frame(t = pmin(time, t_pred), 
                  s = ifelse(time > t_pred, 0, status), 
                  r = risk)
  N <- nrow(d)
  ev <- paste(1, event)
  
  compCI <- with(d, as.data.frame(cmprsk::cuminc(t, s)[[ev]]))
  compCI <- compCI[nrow(compCI), ]
  compCI$tp <- compCI$est * N
  compCI$fp <- (1 - compCI$est) * N
  
  p_max <- min(max(d$r[which(d$s == event)]), p_max)
  p_t <- c(seq(0, 0.01, by = 0.002), 
           seq(0.015, 0.1, by = 0.005), 
           seq(0.11, p_max, by = 0.01))
  
  w <- p_t / (1 - p_t)
  
  all_dc <- (compCI$tp - w * compCI$fp) / N
  all_dc
  model_dc <- sapply(1:length(p_t), function(i) {
    p <- p_t[i]
    ix <- which(d$r >= p)
    ci <- with(d[ix, ], as.data.frame(cmprsk::cuminc(t, s)[[ev]]))
    ci <- ci[nrow(ci), 2]
    m <- length(ix)
    tp <- ci * m
    fp <- (1 - ci) * m
    nb <- (tp - w[i] * fp) / N
    nb
  }) 
  data.frame(p_t = p_t, all = all_dc, model = model_dc)
}

# Net benefit at 6 months after CRLM resection (without bootstrap-optimism correction)
#  // example with GAME score // repeat similarly for all scores

year <- 0.5
NB_G <- NetBenefit(df_Karo$p_Score_GAME_0.5, # risk predictions at 6 months
                    df_Karo$RFS, # time days
                    df_Karo$Recurrence_status) # status variable

## --------------------------------------------------------------- BOOTSRAP INTERNAL VALIDATION ---------------------------------------------------------------

#  // example at 6 months, repeat similarly for all time points of interest (change time point accordingly)

d <- df_Karo

# predictions at 6 months
p <- df_Karo%>% select(starts_with('p_')& ends_with('_0.5')) %>%colnames()
n <- names(M_0.5) # score names
m <- M_0.5 # scoring models
#control that the order of the models is same in vectors p, n and m)
p
n
m

# time point (6 months, in years)
year <- 0.5

# Perform Bootstrap validation
set.seed(123456)
bs_out <- list()
bs_out2 <- list()

for (j in 1:length(m)) {
  d <- d[order(d[,p[j]]), ] # order predictions in increasing order
  B <- 500 # bootstrap sample size
  
  for (i in 1:B) {
    # Create new BS sample and fit model
    bd <- d[sample(1:nrow(d), nrow(d), replace = TRUE), ]
    bm <- update(m[[j]], data=bd)
    
    
    # Generate prediction in both the BS sample and the original sample
    bd$blp <- predict(bm, bd, type = "lp")
    d$vlp <- predict(bm, d, type = "lp")
    bp <- plogis(bd$blp)
    vp <- plogis(d$vlp)
    
    # Calibration error
    cdf_b <- CalibrationFrame(bd$RFS, bd$Progression_status, bp, bd[,n[j]], year)
    cdf_v <- CalibrationFrame(d$RFS, d$Progression_status, vp, d[,n[j]], year)
    cer_b <- cdf_b$obs - d[,p[j]]
    cer_v <- cdf_v$obs - d[,p[j]]
    cdf_opt <- cer_b - cer_v
    
    # calibration slope and calibration-in-the-large
    cal_weak_b <- cbind(unique(cdf_b$citl), unique(cdf_b$slope)) 
    cal_weak_v <- cbind(unique(cdf_v$citl), unique(cdf_v$slope))
    
    
    # O:E Ratio
    oe_b <- ObservedExpectedRatio(bd$RFS, bd$Progression_status, bd[,p[j]], year, n[j])
    oe_v <- ObservedExpectedRatio(d$RFS, d$Progression_status, d[,p[j]], year, n[j])
    
    # Decision curves
    nb_b <- NetBenefit(bp, bd$RFS, bd$Progression_status)
    nb_v <- NetBenefit(vp, d$RFS, d$Progression_status)
    
    nb_opt <- nb_b$model - nb_v$model
    
    
    bs_out[[i]] <- list(bp = bp, vp = vp,
                        cal_weak_b = cal_weak_b, 
                        cal_weak_v = cal_weak_v,
                        oe_b = oe_b, oe_v = oe_v, 
                        cer_b=cer_b, cdf_opt=cdf_opt,
                        cdf_b=cdf_b, cdf_v=cdf_v,
                        nb_b = nb_b, nb_opt = nb_opt,
                        score=n[j])
  }
  
  bs_out2 <- append(bs_out2,bs_out)
}
#  // example with GAME score // repeat similarly for all scores

bs_G <- bs_out2[3001:3500] # select correct output from the list (in this example, GAME score is the 6th object of the vectors m, n and p)
unique(sapply(bs_G, function(lst) {lst$score})) # control the presence of only one score

cdf_opt_G <- do.call(rbind, lapply(bs_G, function(lst) {lst$cdf_opt})) %>% colMeans(na.rm = T)
cdf_G <- CalibrationFrame(d$RFS, d$Recurrence_status, d$p_Score_GAME_0.5, d$Score_GAME, year, cdf_opt_G) #note, opt included


#calibration slope and calibration in the large
slope_G <- CalibrationFrame(d$RFS, d$Recurrence_status, d$p_Score_GAME_0.5, d$Score_G, year)
slope_G <- slope_G[, c('year', 'citl', 'citl_lower', 'citl_upper', 'slope', 'slope_lower', 'slope_upper')]
slope_G <- slope_G[!duplicated(slope_G), ]

weak_bs <- sapply(bs_G, function(lst) lst$cal_weak_b)
weak_opt <- (weak_bs - sapply(bs_G, function(lst) lst$cal_weak_v)) %>% rowMeans

#conf <- weak_bs %>% apply(1, function(row) quantile(row, c(0.025, 0.975))) %>% t

slope_G$citl_cor <- slope_G$citl-weak_opt[1]
slope_G$citl_cor_lower <- conf[1,1]
slope_G$citl_cor_upper <- conf[1,2]

slope_G$slope_cor <- slope_G$slope-weak_opt[2]
slope_G$slope_cor_lower <- conf[2,1]
slope_G$slope_cor_upper <- conf[2,2]

slope_G$score <- "GAME"

# O:E ratio
oe_opt_G <- mean(sapply(bs_G, function(lst) as.numeric(lst$oe_b[['OE_ratio']])) - sapply(bs_G, function(lst) as.numeric(lst$oe_v[['OE_ratio']])))
oeL_opt_G <- mean(sapply(bs_G, function(lst) as.numeric(lst$oe_b[['Lower95']])) - sapply(bs_G, function(lst) as.numeric(lst$oe_v[['Lower95']])))
oeU_opt_G <- mean(sapply(bs_G, function(lst) as.numeric(lst$oe_b[['Upper95']])) - sapply(bs_G, function(lst) as.numeric(lst$oe_v[['Upper95']])))

oe_G <- ObservedExpectedRatio(d$RFS, d$Recurrence_status, d$p_Score_GAME_0.5, year,  'Score_G')
oe_G['OE_cor'] <- as.numeric(oe_G['OE_ratio'])-oe_opt_G
oe_G['Lower95_cor'] <- as.numeric(oe_G['Lower95'])-oeL_opt_G
oe_G['Upper95_cor'] <- as.numeric(oe_G['Upper95'])-oeU_opt_G

# calibration measures
slope_G # slope and calibration-in-the-large
oe_G # O:E ratio

# Net benefit
nb_G <- NetBenefit(d$p_Score_GAME_0.5, d$RFS, d$Recurrence_status)
nb_opt_G <- rowMeans(sapply(bs_G, function(lst) {lst$nb_opt}), na.rm = TRUE)
nb_G$model_c <- nb_G$model-abs(nb_opt_G)



# collect the data for plots
cdf_GAME <- cdf_G%>%
  mutate(strata=case_when(mean_score<=1~'0-1',
                          mean_score>1&mean_score<=3~'2-3',
                          mean_score>3~'4-7'),
         Risk=case_when(strata=='0-1'~'Low',
                        strata=='2-3'~'Intermediate',
                        strata=='4-7'~'High'),
         score=c(rep('GAME', nrow(cdf_G))))


library(ggplot2)
library(ggthemes)

# Calibration plot
cal_plots <- ggplot(cdf_GAME, aes(mean_pred, obs, color=Risk)) + 
  geom_point() + 
  #geom_smooth(aes(mean_pred))+
  geom_errorbar(aes(ymin = lower, ymax = upper, width = 0)) + 
  #xlim(0, 1.2) + ylim(0, 1.2) +
  scale_x_continuous(limits = c(0, 1.1),
                     breaks = c(0, 0.25, 0.5, 0.75, 1),
                     labels = c("0", "0.25", "0.5",  "0.75", "1")) +
  scale_y_continuous(limits = c(0, 1.1),
                     breaks = c(0, 0.25, 0.5, 0.75, 1),
                     labels = c("0", "0.25", "0.5",  "0.75", "1")) +
  geom_abline(intercept = 0, slope = 1, linetype = 3)+
  geom_segment(aes(x = lower_pred, xend = upper_pred, y = lower, yend = lower)) + 
  geom_segment(aes(x = lower_pred, xend = upper_pred, y = upper, yend = upper)) + 
  theme_clean()+
  theme(legend.position = 'none')+
  scale_color_manual(values=c("#D55E00","#0072B2", "#CC79A7"))+
  facet_wrap(score~year, nrow = 8, ncol = 4)

cal_plots


# Net benefit plot
nb_long_game <- pivot_longer(nb_G, c("all", "model", "model_c"))
nb_long_game <- rbind(nb_long_game, data.frame(p_t = nb_G$all[1], name = "all", value = 0))
nb_long_game$score <- c(rep('Game', nrow(nb_long_game)))

# plot
nb_long_game$score <- ifelse(nb_long_game$name=='all', 'all', nb_long_game$score)

ggplot(nb_long_game, aes(p_t * 100, value,group=score,color = score)) + 
  geom_line() + geom_hline(yintercept = 0, linetype = 2) +
  scale_color_manual(values=palette.colors())+
  theme_clean()+
  theme(legend.position = c(0.8, 0.8)) + 
  scale_x_continuous("Risk Threshold (%)", breaks = c(10 * (0:10)), limits = c(10,100))+
  scale_y_continuous("Net Benefit", limits = c(-0.0001, nb_long_game[nb_long_game$name=='all',]$value[1]+0.0001))

## -----------------------------------------------------------------------------------------------------------------------------------------------------------
