
# ****************************************************************************************************************************************************** 
#                                                          EXTERNAL VALIDATION OF RECALIBRATED MODELS
# ****************************************************************************************************************************************************** 

# import the validation data, impute the missing data like shown in notebook "3_missing_data_imputation" if necessary
df_CM <- read_csv('./OSLO_COMET_complete_data.csv')
head(df_CM)

# calculate score factors and total score points for validation data like shown in notebook "4_discrimination"


## ----------------------------------------------------------------- MODEL PARAMETERS -----------------------------------------------------------------


# // See eTable 6 in the publication for Helsinki and Nordlinger score estimates
# // Here only shown for the scores that could be counted for OSLO-COMET cohort

########## m-CS ##########

#mCS
# 6 months
mCS_coef_b0.5 <- -1.5807
mCS_RAS_0.5 <- 0.2153
mCS_pN_0.5 <- 0.6054
mCS_size_0.5 <- 0.1270

#1 year
mCS_coef_b1 <- -0.6323
mCS_RAS_1 <- 0.0909
mCS_pN_1 <- 0.7303
mCS_size_1 <- 0.1700

#2 year
mCS_coef_b2 <- -0.1098
mCS_RAS_2 <- 0.2067
mCS_pN_2 <- 0.6546
mCS_size_2 <- 0.1486

#3 year
mCS_coef_b3 <- 0.1435
mCS_RAS_3 <- 0.1911
mCS_pN_3 <- 0.6476
mCS_size_3 <- 0.1449


########## Fong ##########

# 6 months
F_coef_b0.5 <- -2.4674
F_pN_0.5 <- 0.5193
F_dfi12m_0.5 <- 0.7504
F_mcount_0.5 <- 0.7139
F_size_0.5 <-0.0677
F_cea_0.5 <- -0.1351

#1 year
F_coef_b1 <--1.3617
F_pN_1 <- 0.6639
F_dfi12m_1 <- 0.4970
F_mcount_1 <- 0.7321
F_size_1 <-0.1261
F_cea_1<- -0.1354

#2 year
F_coef_b2 <--0.5731
F_pN_2 <-0.6150
F_dfi12m_2 <-0.2825
F_mcount_2 <-0.6512
F_size_2 <-0.0996
F_cea_2<--0.0917

#3 year
F_coef_b3 <--0.3897
F_pN_3 <-0.5960
F_dfi12m_3 <-0.3703
F_mcount_3 <-0.6678
F_size_3 <-0.1161
F_cea_3<--0.0854


######## Nagashima ########
# 6 months
Na06_coef_b0.5 <--3.0837
Na06_coef_0.5_1 <- 1.0047
Na06_coef_0.5_2 <- 0.4911
Na06_coef_0.5_3 <- -4.0317

#1 year
Na06_coef_b1 <--1.5362
Na06_coef_1_1 <- 0.7895
Na06_coef_1_2 <- 0.0228
Na06_coef_1_3 <- -1.5500

#2 year
Na06_coef_b2 <- -1.0354
Na06_coef_2_1 <- 0.9860
Na06_coef_2_2 <- -1.6170
Na06_coef_2_3 <- 4.2896

#3 year
Na06_coef_b3 <--0.9323
Na06_coef_3_1 <- 1.1368
Na06_coef_3_2 <- -2.1984
Na06_coef_3_3 <- 5.9848


########## GAME ##########
# 6 months
G_coef_b0.5 <- -2.2698
G_kras_0.5 <- 0.3281
G_cea_0.5<- 0.2676
G_pN_0.5<- 0.6581
G_tbs1_0.5<- 0.2165
G_tbs2_0.5<- 1.4392
G_eheps_0.5<- 0.8799

#1 year
G_coef_b1 <--1.3878
G_kras_1 <- 0.2255
G_cea_1 <- 0.3401
G_pN_1 <- 0.7891
G_tbs1_1 <- 0.4788
G_tbs2_1 <- 1.4248
G_eheps_1 <- 0.7408

#2 year
G_coef_b2 <--0.7997
G_kras_2 <- 0.3599
G_cea_2 <- 0.3588
G_pN_2 <- 0.7028
G_tbs1_2 <- 0.3424
G_tbs2_2 <-1.4856
G_eheps_2 <- 1.0371

#3 year
G_coef_b3 <--0.5858
G_kras_3 <- 0.3880
G_cea_3 <- 0.2063
G_pN_3 <- 0.6862
G_tbs1_3 <- 0.4537
G_tbs2_3 <- 1.5930
G_eheps_3 <- 1.0428

######### Konopke #########
# 6 months
K_coef_b0.5 <- -1.7025
K_mcount_0.5 <- 0.9349
K_cea_0.5 <- -0.0678
K_sync_0.5 <- 0.5888

#1 year
K_coef_b1 <--0.5814
K_mcount_1 <- 0.9654
K_cea_1 <- -0.0529
K_sync_1 <- 0.4151

#2 year
K_coef_b2 <--0.0012
K_mcount_2 <- 0.9913
K_cea_2 <- -0.0128
K_sync_2 <- 0.3276

#3 year
K_coef_b3 <-0.1960
K_mcount_3 <- 1.0741
K_cea_3 <- -0.0112
K_sync_3 <- 0.3824

## ----------------------------------------------------------------- RISK PREDICTIONS  -----------------------------------------------------------------

#predicted risks at 6 months, 1 year, 2 years or 3 years after CRLM resection by the re-calibrated models in independent cohort
# probability formula: plogis(b0+b1*total_score_points)

########## m-CS ##########
# 6 months
df_CM$p_Score_mCS_0.5 <-plogis(mCS_coef_b0.5+mCS_RAS_0.5*df_CM$S_RAS+mCS_pN_0.5*df_CM$S_pN_status+mCS_size_0.5*df_CM$S_size)
#1 year
df_CM$p_Score_mCS_1 <- plogis(mCS_coef_b1+mCS_RAS_1*df_CM$S_RAS+mCS_pN_1*df_CM$S_pN_status+mCS_size_1*df_CM$S_size)
#2 year
df_CM$p_Score_mCS_2 <- plogis(mCS_coef_b2+mCS_RAS_2*df_CM$S_RAS+mCS_pN_2*df_CM$S_pN_status+mCS_size_2*df_CM$S_size)
#3 year
df_CM$p_Score_mCS_3 <- plogis(mCS_coef_b3+mCS_RAS_3*df_CM$S_RAS+mCS_pN_3*df_CM$S_pN_status+mCS_size_3*df_CM$S_size)

########## Fong ########## 
# 6 months
df_CM$p_Score_F_0.5 <- plogis(F_coef_b0.5+F_pN_0.5*df_CM$S_pN_status+F_dfi12m_0.5*df_CM$S_synchronous+ F_mcount_0.5*df_CM$S_MetCount_1+F_size_0.5*df_CM$S_size+F_cea_0.5*df_CM$S_preopCEA_200)
#1 year
df_CM$p_Score_F_1 <- plogis(F_coef_b1+F_pN_1*df_CM$S_pN_status+F_dfi12m_1*df_CM$S_synchronous+ F_mcount_1*df_CM$S_MetCount_1+F_size_1*df_CM$S_size+F_cea_1*df_CM$S_preopCEA_200)
#2 year
df_CM$p_Score_F_2 <- plogis(F_coef_b2+F_pN_2*df_CM$S_pN_status+F_dfi12m_2*df_CM$S_synchronous+ F_mcount_2*df_CM$S_MetCount_1+F_size_2*df_CM$S_size+F_cea_2*df_CM$S_preopCEA_200)
#3 year
df_CM$p_Score_F_3 <- plogis(F_coef_b3+F_pN_3*df_CM$S_pN_status+F_dfi12m_3*df_CM$S_synchronous+ F_mcount_3*df_CM$S_MetCount_1+F_size_3*df_CM$S_size+F_cea_3*df_CM$S_preopCEA_200)

######## Nagashima ########
# knots
t1 <- 0.60034
t2 <- 1.53250
t3 <- 2.13284
t4 <- 3.87591

scale <- (t4 - t1)^2

# First spline term (Score_Na2006')
pos <- function(x) ifelse(x > 0, x, 0)


Na_sp1 <- pos(df_CM$Score_Na2006 - t1)^3 - pos(df_CM$Score_Na2006 - t3)^3 * (t4 - t1) / (t4 - t3) + pos(df_CM$Score_Na2006 - t4)^3 * (t3 - t1) / (t4 - t3)
Na_sp1_sc <- Na_sp1/scale

# Second spline term (Score_Na2006'')
Na_sp2 <- pos(df_CM$Score_Na2006 - t2)^3 -
  pos(df_CM$Score_Na2006 - t3)^3 * (t4 - t2) / (t4 - t3) +
  pos(df_CM$Score_Na2006 - t4)^3 * (t3 - t2) / (t4 - t3)

Na_sp2_sc <- Na_sp2/scale

# 6 months
df_CM$p_Score_Na06_0.5 <- plogis(Na06_coef_b0.5+Na06_coef_0.5_1*df_CM$Score_Na2006+Na06_coef_0.5_2*Na_sp1_sc+Na06_coef_0.5_3*Na_sp2_sc)
#1 year
df_CM$p_Score_Na06_1 <- plogis(Na06_coef_b1+Na06_coef_1_1*df_CM$Score_Na2006+Na06_coef_1_2*Na_sp1_sc+Na06_coef_1_3*Na_sp2_sc)
#2 year
df_CM$p_Score_Na06_2 <- plogis(Na06_coef_b2+Na06_coef_2_1*df_CM$Score_Na2006+Na06_coef_2_2*Na_sp1_sc+Na06_coef_2_3*Na_sp2_sc)
#3 year
df_CM$p_Score_Na06_3 <- plogis(Na06_coef_b3+Na06_coef_3_1*df_CM$Score_Na2006+Na06_coef_3_2*Na_sp1_sc+Na06_coef_3_3*Na_sp2_sc)

########## GAME ##########
# 6 months
df_CM$p_Score_G_0.5 <- plogis(G_coef_b0.5+G_kras_0.5*df_CM$S_KRAS+ G_cea_0.5*df_CM$S_preopCEA_20+G_pN_0.5*df_CM$S_pN_status+
                                 ifelse(df_CM$S_TBS==1, G_tbs1_0.5*df_CM$S_TBS, G_tbs2_0.5*df_CM$S_TBS)+
                                 G_eheps_0.5*df_CM$S_resectiable_extrahepatic_mets)
#1 year
df_CM$p_Score_G_1 <- plogis(G_coef_b1+G_kras_1*df_CM$S_KRAS+ G_cea_1*df_CM$S_preopCEA_20+G_pN_1*df_CM$S_pN_status+
                               ifelse(df_CM$S_TBS==1, G_tbs1_1*df_CM$S_TBS, G_tbs2_1*df_CM$S_TBS)+
                               G_eheps_1*df_CM$S_resectiable_extrahepatic_mets)
#2 year
df_CM$p_Score_G_2 <- plogis(G_coef_b2+G_kras_2*df_CM$S_KRAS+ G_cea_2*df_CM$S_preopCEA_20+G_pN_2*df_CM$S_pN_status+
                               ifelse(df_CM$S_TBS==1, G_tbs1_2*df_CM$S_TBS, G_tbs2_2*df_CM$S_TBS)+
                               G_eheps_2*df_CM$S_resectiable_extrahepatic_mets)
#3 year
df_CM$p_Score_G_3 <- plogis(G_coef_b3+G_kras_3*df_CM$S_KRAS+ G_cea_3*df_CM$S_preopCEA_20+G_pN_3*df_CM$S_pN_status+
                               ifelse(df_CM$S_TBS==1, G_tbs1_3*df_CM$S_TBS, G_tbs2_3*df_CM$S_TBS)+
                               G_eheps_3*df_CM$S_resectiable_extrahepatic_mets)

######### Konopke #########
# 6 months
df_CM$p_Score_K_0.5 <- plogis(K_coef_b0.5+K_mcount_0.5*df_CM$S_MetCount_3+K_cea_0.5*df_CM$S_preopCEA_200+K_sync_0.5*df_CM$S_synchronous)
#1 year
df_CM$p_Score_K_1 <- plogis(K_coef_b1+K_mcount_1*df_CM$S_MetCount_3+K_cea_1*df_CM$S_preopCEA_200+K_sync_1*df_CM$S_synchronous)
#2 year
df_CM$p_Score_K_2 <- plogis(K_coef_b2+K_mcount_2*df_CM$S_MetCount_3+K_cea_2*df_CM$S_preopCEA_200+K_sync_2*df_CM$S_synchronous)
#3 year
df_CM$p_Score_K_3 <- plogis(K_coef_b3+K_mcount_3*df_CM$S_MetCount_3+K_cea_3*df_CM$S_preopCEA_200+K_sync_3*df_CM$S_synchronous)


## ------------------------------------------------------------- PERFORMANCE EVALUATIONS  -------------------------------------------------------------

# functions and plotting described in notebook "5_recalibration"
#  // example at 6 months after CRLM resection //repeat similarly for all time points
#  // example with GAME score // repeat similarly for all scores

year <- 0.5

# calibration
cdf_G<-CalibrationFrame(df_CM$RFS, # time days
                        df_CM$Recurrence_status, # status variable
                        df_CM$p_Score_GAME_0.5, # risk predictions at 6 months
                        df_CM$Score_GAME, # total score points
                        year) # time point of interest (years)

# calibration measures
OE_G <- ObservedExpectedRatio(df_CM$RFS, # time days
                              df_CM$Recurrence_status, # status variable
                              df_CM$p_Score_GAME_0.5, # risk predictions at 6 months
                              year, # time point of interest (years)
                              'GAME') # score name

# Net benefit
NB_G <- NetBenefit(df_CM$p_Score_GAME_0.5, # risk predictions at 6 months
                   df_CM$RFS, # time days
                   df_CM$Recurrence_status) # status variable

## ---------------------------------------------------------------------------------------------------------------------------------------------------

