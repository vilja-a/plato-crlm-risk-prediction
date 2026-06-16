# ****************************************************************************************************************************************************** 
#                                                                       DISCRIMINATION
# ****************************************************************************************************************************************************** 


# import data
library(tidyverse)
df_Karo <- read_csv('./output/KaroLiver_complete.csv')
head(df_Karo)


## ----------------------------------------------------------------- CALCULATE THE SCORES ---------------------------------------------------------------

# lymphatic spread
df_Karo$S_pN <- ifelse(df_Karo$pN > 0, 1, 0)

# advanced tumor status
df_Karo$S_pT_T3_4 <- ifelse(df_Karo$pT > 2, 1, 0)
df_Karo$S_pT_T4 <- ifelse(df_Karo$pT > 3, 1, 0)

# disease free interval
df_Karo$S_DFI_12m <- ifelse(df_Karo$time_between_CRC_and_LM_months < 12, 1, 0)
df_Karo$S_DFI_24m <- ifelse(df_Karo$time_between_CRC_and_LM_months < 24, 1, 0)

# multiple metastases
df_Karo$S_MetCount_1 <- ifelse(df_Karo$MetCount > 1, 1, 0)
df_Karo$S_MetCount_3 <- ifelse(df_Karo$MetCount > 3, 1, 0)

# size
df_Karo$S_size <- ifelse(df_Karo$LargMetSize_mm > 50, 1, 0)

#tumor burden
df_Karo$TBS <- sqrt(((df_Karo$LargMetSize_mm/10)^2)+(df_Karo$MetCount^2))
summary(df_Karo$TBS)

df_Karo$S_TBS <- ifelse(df_Karo$TBS>=9, 2,
                                  ifelse(df_Karo$TBS>=3 & df_Karo$TBS<9, 1, 0))


# CEA levels (check reference intervals)
df_Karo$S_CEA_200 <- ifelse(df_Karo$CEA_ugL >= 200, 1, 0) #Fong 200 ng/ml => 200 µg/L
df_Karo$S_CEA_20 <- ifelse(df_Karo$CEA_ugL >= 20, 1, 0) #GAME 20ng/ml


# Age
df_Karo$S_Age <- ifelse(df_Karo$Age > 60, 1, 0)

# extrahepatic metastases and synchronous tumors
df_Karo <- df_Karo%>%
  mutate(S_exhep_mets=case_when(LungMets==1 | OtherMets==1~1,
                                                   TRUE~0),
         S_synchronous = case_when(time_between_CRC_and_LM_months<0|time_between_CRC_and_LM_months==0~1,
                                   TRUE~0))


# KRAS status
df_Karo$S_KRAS <- ifelse(df_Karo$KRAS_cat ==1, 1, 0)

# combined RAS & KRAS status 
df_Karo$S_RAS <- ifelse(df_Karo$NRAS_cat ==1|df_Karo$KRAS_cat ==1, 1, 0)


## post-operative vars

#viability
df_Karo$S_viab <- ifelse(df_Karo$MaxVit_percent > 30, 1, 0)

# resection margin
df_Karo$S_margin_5 <- ifelse(df_Karo$ResectionMargin_mm < 5, 1, 0)
df_Karo$S_margin_10 <- ifelse(df_Karo$ResectionMargin_mm < 10, 1, 0)

# vascular invasion
df_Karo$S_VascInv <- ifelse(df_Karo$VascInv >0, 1, 0)

# biliary invasion
df_Karo$S_BiliaryInv <- ifelse(df_Karo$BiliaryInv >0, 1, 0)


# total scores 
df_Karo <- df_Karo %>%
  rowwise()%>%
  mutate(Score_F=sum(S_pN, S_DFI_12m, S_MetCount_1, S_size, S_CEA_200, na.rm = F),
         Score_K=sum(S_MetCount_3, S_CEA_200, S_synchronous, na.rm = F),
         Score_Na=0.60034*S_pN+ 0.54877*S_pT_T4+1.35657*S_size+1.19430*S_exhep_mets+0.67838*S_DFI_12m+0.85412*S_MetCount_1,
         Score_H=sum(S_pN, S_pT_T3_4, S_MetCount_1, S_margin_5, S_size, S_viab, S_VascInv, S_BiliaryInv, na.rm = F),
         Score_No=sum(S_pN, S_pT_T4, S_DFI_24m, S_MetCount_3, S_size, S_margin_10, S_Age, na.rm = F),
         Score_GAME=sum(S_KRAS, S_CEA_20,S_pN+S_TBS,S_exhep_mets*2, na.rm = F),
         Score_mCS=sum(S_RAS,S_pN,S_size, na.rm = F))%>%
  data.frame()


# count strata
df_Karo <- df_Karo %>%
  mutate(ScoreH_strata = case_when(Score_H <= 2~'0-2',
                                   Score_H > 2 & Score_H <= 4~'3-4',
                                   Score_H>4~'5-8'),
         ScoreF_strata = case_when(Score_F<= 2~'0-2',
                                   Score_F > 2 & Score_F <= 4~'3-4',
                                   Score_F>4~'5'),
         ScoreNo_strata = case_when(Score_No<= 2~'0-2',
                                    Score_No > 2 & Score_No <= 4~'3-4',
                                    Score_No>4~'5-7'),
         ScoreK_strata = case_when(Score_K==0~'Low',
                                   Score_K==1~'Intermediate',
                                   Score_K>=2~'High'),
         ScoreNa_strata = case_when(Score_Na<= 3~'Grade A',
                                    Score_Na > 3 & Score_Na <= 5~'Grade B',
                                    Score_Na>5~'Grade C'),
         ScoreGAME_strata = case_when(Score_GAME <= 1~'0-1',
                                      Score_GAME > 1 & Score_GAME <= 3~'2-3',
                                      Score_GAME>3~'4-7'),
         ScoremCS_strata = case_when(Score_mCS==0~'Low',
                                     Score_mCS==1~'Intermediate',
                                     Score_mCS==2~'Moderate',
                                     Score_mCS>=3~'High'))%>%
  data.frame()

## ---------------------------------------------------------------------- DISCRIMINATION -----------------------------------------------------------------

#  // example with GAME score // repeat similarly for all scores


library(survival)
library(survminer)

# Multivariable analysis // recurrence-free survival
fit.coxph <- coxph(Surv(time = RFS, event = Recurrence_status) ~ S_KRAS +
                     S_pN +
                     S_CEA_20+
                     S_exhep_mets+
                     S_TBS,
                   data = df_Karo)
summary(fit.coxph)
ggforest(fit.coxph, data = df_Karo, main = "RFS - GAME Score Risk Factors", fontsize=1.5)

# Survival analysis of risk categories // recurrence-free survival
formula <- as.formula(paste("Surv(RFS, Recurrence_status) ~", "ScoreGAME_strata"))
cox_model <- surv_fit(formula, data = df_Karo)

# summary from the model
summary(cox_model)

# Kaplan-Meier curve
ggsurv_plot <- ggsurvplot(cox_model,
                          data = df_Karo,
                          xlab = "Years from resection",
                          break.time.by = 365.25,
                          pval = TRUE,
                          ggtheme = theme_bw(),
                          risk.table = TRUE,
                          risk.table.y.text.col = T,
                          risk.table.y.text = FALSE,
                          ncensor.plot = T,
                          surv.median.line = "hv",
                          xscale = 'd_y',
                          palette= c("#F0E442","#0072B2", "#CC79A7"),
                          title="Cox mMdel for GAME Score (RFS)")


# Time-dependent AUC
TimeDependentROC <- function(time, event, p){
  auc <- timeROC::timeROC(time/365.25, event, p, cause = 1, times = c(0.5, 1:3, 5, 7), ROC = TRUE)
  return(auc)
}


# ROC analysis at 6 months // repeat similarly for all time points
S_GAME_auc <- TimeDependentROC(df_Karo$RFS, df_Karo$Recurrence_status, df_Karo$Score_GAME)
ROC_frame <- data_frame(FP=S_GAME_auc$FP[,'t=0.5'], TP=S_GAME_auc$TP[,'t=0.5'],
                                 Score = rep('Score_GAME', nrow(S_GAME_auc$FP)), auc= round(S_GAME_auc$AUC['t=0.5'],3),
                                 time = rep('t=0.5', nrow(S_GAME_auc$FP)))

# AUC over time
auc_data <- data.frame(AUC=S_GAME_auc$AUC)
auc_data$time <- gsub('t=', '', rownames(auc_data))
auc_data$Score <- rep('GAME', nrow(auc_data))


# ROC curve
ggplot(ROC_frame,aes(x=FP, y=TP,colour=Score)) + 
  geom_line() +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, linetype = 2)+
  coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
  scale_color_manual(values=palette.colors())+
  theme_clean()+
  labs(x="sensitivity",
       y="1-specificity")+
  facet_grid(~time)


# AUC over time
ggplot(auc_data, aes(as.numeric(time), AUC,group=Score,color = Score)) + 
  geom_line() + geom_hline(yintercept = 0, linetype = 2) +
  scale_color_manual(values=rev(palette.colors()))+
  theme_clean()+
  scale_x_continuous("Years After CRLM Resection", limits = c(0.5,7), breaks = c(0.5, 1:7))+
  scale_y_continuous("AUC", limits = c(0.55, 1))

## -----------------------------------------------------------------------------------------------------------------------------------------------------------
