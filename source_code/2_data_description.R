
# ****************************************************************************************************************************************************** 
#                                                                       DATA CHARACTHERISTICS
# ****************************************************************************************************************************************************** 

# Import data
library(tidyverse)
df_Karo <- read_csv('./KaroLiver_data.csv')
head(df_Karo)

df_CM <- read_csv('./OSLO_COMET_data.csv')
head(df_CM)


# summary table
library(gtsummary)
df_Karo %>%
  tbl_summary(type = all_dichotomous() ~ "categorical")


# survival characteristics (repeat for both cohorts)
library(survival)
library(survminer)

# median follow-up in months
fit <- survfit(Surv(RFS/30.44, 1 - Recurrence_status) ~ 1, data = df_Karo)
print(fit)

# median time to recurrence in months
fit <- survfit(Surv(RFS/30.44, Recurrence_status) ~ 1, data = df_Karo[df_Karo$Recurrence_status==1,])
print(fit)

# median recurrence free survival in months
fit <- survfit(Surv(RFS/30.44, Recurrence_status) ~ 1, data = df_Karo) 
print(fit)
summary(fit, times = c(44.9)) # recurrence at median follow-up which is 44.9 in this cohort

# median recurrence free survival in years
fit <- survfit(Surv(RFS/365.25, Recurrence_status) ~ 1, data = df_Karo)
summary(fit, times = c(0.5, 1:10))

# cumulative incidence plot of recurrence-free survival
library(ggplot2)
library(ggthemes)
library(ggsurvfit)

df_CM$Cohort <- c(rep('CoMet', nrow(df_CM))) 
df_Karo$Cohort <- c(rep('KaroLiver', nrow(df_Karo))) 

cuminc_plot <- rbind(df_CM[, c('RFS','Recurrence_status', 'Cohort')], df_Karo[, c('RFS','Recurrence_status', 'Cohort')])


fit <- survfit(Surv(RFS/365.25, Recurrence_status) ~ Cohort, data = cuminc_plot) # in years
surv_pvalue(fit)
summary(fit, times = c(0.5, 1:10))

ggsurvfit(fit, type = "risk")+
  add_risktable()+
  theme_bw()+
  scale_color_manual(values=c("Cohort=CoMet" = "#56B4E9", "Cohort=KaroLiver"= "#D55E00"))+
  add_censor_mark(size = 2, alpha = 0.2, values=c("Cohort=CoMet" ="#56B4E9","Cohort=KaroLiver"= "#D55E00")) +
  add_quantile(y_value = 0.5, color = "#999999", linewidth = 0.8) +
  labs(
    y = "Cumulative incidence (RFS)",
    x = "Years"
  )+
  ylim(0,1)+
  scale_x_continuous(breaks = c(0:9), limits = c(0,9))


# compare the cohorts (example of each variable class is given)

# Continous variable -age 
# test for normality 
shapiro.test(df_Karo$Age) 
shapiro.test(df_CM$Age)
# no normal distribution => non-parametric test
wt <- wilcox.test(df_Karo$Age, df_CM$Age)
p.adjust(wt$p.value, method = 'BH')

# Binary variables - sex
t <- rbind(df_CM[c('Cohort','Sex')],df_Karo[,c('Cohort','Sex')])

ct <- chisq.test(table(t))
p.adjust(ct$p.value, method = 'BH')


# Ordinal variables - T stage
t1 <- df_CM[c('Cohort','pT_cat')]
t2 <- df_Karo[,c('Cohort','pT_cat')]

t1 <- t1[order(t1$pT_cat, decreasing = F), ]
t2 <- t2[order(t2$pT_cat, decreasing = F), ]

t <- rbind(t1, t2)

wt <- kruskal.test(as.numeric(pT_cat)~Cohort, data = t)
p.adjust(wt$p.value, method = 'BH')



# Quality control for model re-calibration cohort

# association between RFS and OS
conc <- concordance(Surv(OS, Death_status) ~ RFS, data = df_Karo)
c_idx <- conc$concordance
se <- sqrt(conc$var)
tau <- 2*c_idx-1
tau_se <- 2*se
tau_lower  <- tau-1.96*tau_se
tau_upper  <- tau+1.96*tau_se
z <- (c_idx - 0.5) / se
p_val <- 2 * pnorm(-abs(z)) # wald test

cbind(tau, tau_se, tau_lower, tau_upper, c_idx, se, p_val)

# lost ot follow-up
df_Karo%>%
  filter(Death_status==0  & Progression_status == 0 & OS <= 3*365.25)

# death before relapse
df_Karo%>%
  filter(Death_status==1 & Progression_status == 0 & OS < 3*365.25)

# evaluate competing risks
df_Karo <- df_Karo%>%
  mutate(competing_risks=case_when(Recurrence_status==0&Death_status==0~0,
                                   Recurrence_status==1&Death_status==0~1,
                                   Recurrence_status==1&Death_status==1~1, # Recurrence before death
                                   Recurrence_status==0&Death_status==1~2))

cmprsk::timepoints(cmprsk::cuminc(df_Karo$OS/365.25, df_Karo$competing_risks == 1), c(1:10)) # not adjusting for competing events
cmprsk::timepoints(cmprsk::cuminc(df_Karo$OS/365.25, df_Karo$competing_risks), c(1:10)) # adjusting

## -------------------------------------------------------------------------------------------------------------------------------------------------
