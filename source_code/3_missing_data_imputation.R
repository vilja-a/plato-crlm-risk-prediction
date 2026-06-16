
# ****************************************************************************************************************************************************** 
#                                                                     MISSING DATA IMPUTATION
# ****************************************************************************************************************************************************** 

# import data
library(tidyverse)
df_Karo <- read_csv('./KaroLiver_data.csv')
head(df_Karo)


library(mice)

# add baseline hazard
bhaz <- survival::basehaz(survival::coxph(survival::Surv(RFS, Recurrence_status==1) ~ 1, df_Karo))
df_Karo$haz <- approx(lowess(bhaz[, 2], bhaz[, 1], f = 1/20), xout = df_Karo$RFS)$y



# collect variables of interest
vars <- df_Karo%>%
  dplyr::select(ID,pN,pT,time_between_CRC_and_LM_months,LargMetSize_mm, MetCount,CEA_ugL,NRAS_cat, KRAS_cat,Age,
         LungMets,OtherMets,ResectionMargin_mm,MaxVit_percent,BiliaryInv,VascInv,
         Recurrence_status,Death_status, RFS, OS, Sex, haz)

# missingness pattern all variables
md.pattern(vars,rotate.names = TRUE)

# Run mice
imp <- mice::mice(
  vars,
  m = 5,
  formulas = formulas, # define formula to include complete variables with potential info on the missing vars, including the baseline hazard
  maxit = 10,
  seed = 123,
  print = F
)

## -------------------------------------------------------------------- QUALITY CONTROL ---------------------------------------------------------------

# Diagnostics
plot(imp)
imp$loggedEvents

# one example of each variable type (continuous, binary, ordinal) is shown below:

stripplot(imp, LargMetSize_mm~.imp, pch=20, cex=2) # repeat for all the imputed variables

# continuous data
#collect the variables
continuous <- c("LargMetSize_mm", "CEA_ugL", "MaxVit_percent", "ResectionMargin_mm")
vars_continuous <- vars%>%
  dplyr::select(continuous)

# compare the original data to the imputed sets
original <- vars_continuous #original data
set1 <- complete(imp, action = 1L)[continuous] #imputed set #1  (repeat for all sets [set #2-5])

# descriptive stats for each imputed data set and compare to the original with box plot
original <- as.data.frame(summary(vars_continuous, na.rm=T)) #original data
original$Var1 <- rep('original', nrow(original))
set1 <- as.data.frame(summary(complete(imp, action = 1L)[continuous])) #set 1
set1$Var1 <- rep('set1', nrow(set1))

sets <- rbind(original, set1) # collect all the sets in one table

# clean-up 
sets <- separate(sets,  col=Freq, into=c('Descriptor', 'Value'), sep=':')
sets$Value <- as.numeric(sets$Value)
colnames(sets) <- c('Dataset', 'Variable', 'Descriptor', 'Value')


# relative difference between descriptive stats
sets_wide <- sets %>%
  pivot_wider(names_from = Dataset, values_from = Value)%>%
  filter(Descriptor!="NA's   ")%>%
  mutate(imp_set1 = (original-set1)/original*100)%>% 
         #imp_set2 = (original-set2)/original*100,
         #imp_set3=(original-set3)/original*100,
         #imp_set4 = (original-set4)/original*100,
         #imp_set5 = (original-set5)/original*100)%>%
  dplyr::select(Variable, Descriptor, starts_with('imp'))%>%
  data.frame()

sets_long <- sets_wide%>%
  pivot_longer(cols=starts_with('imp_') , names_to = 'Dataset', values_to = 'Value')%>%
  data_frame()

sets_long$Value <- ifelse(is.na(sets_long$Value), 0,sets_long$Value) # in case the change is 0 (divided by 0 => NA)


# boxplot
library(ggthemes)
library(ggplot2)

sets_long%>%
  ggplot(aes(x = Descriptor, y = Value))+
  geom_boxplot(position = position_dodge2(preserve = 'single'), width = 0.37, outlier.shape = NA) +
  geom_jitter(aes(color = Dataset), alpha = 1, size = 2.8, position=position_jitter(0.18))+
  scale_color_manual(values = rev(palette.colors()[c(1:3,5,7)]))+
  labs(x = '', y = '(original values - imputed values) / original values*100')+
  theme_clean()+
  theme(legend.position = "right", axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        axis.ticks = element_blank())+
  geom_hline(mapping = aes(yintercept = 0))+
  #ylim(-20,20)+
  facet_wrap(~Variable, scales = 'free_y', ncol=4)


# histograms
original <- vars_continuous #original data
set1 <- complete(imp, action = 1L)[continuous] #set1

# with ggplot
original <- pivot_longer(original,
                         cols=c(colnames(original)),
                         names_to = 'variable',
                         values_to = 'values')

original$set <- rep('original', nrow(original))

set1 <- pivot_longer(set1,
                     cols=c(colnames(set1)),
                     names_to = 'variable',
                     values_to = 'values')

set1$set <- rep('set1', nrow(set1))
comparison <- rbind(original, set1)

#table of descriptive values
descrip <- comparison %>%
  group_by(set, variable)%>%
  summarise(min = min(values, na.rm = T),
            med = median(values, na.rm = T),
            mean = mean(values, na.rm = T),
            max=max(values, na.rm = T))%>%
  data.frame()


ggplot(comparison, aes(x = values))+
  geom_histogram(na.rm = T, bins = 20)+
  theme_classic()+
  geom_vline(data = descrip, mapping = aes(xintercept = med, color = 'Median'), size = 1.5)+
  geom_vline(data = descrip, mapping = aes(xintercept = mean, color = 'Mean'), size = 1.5)+
  geom_vline(data = descrip, mapping = aes(xintercept = min, color = 'Min'), size = 1.5)+
  geom_vline(data = descrip, mapping = aes(xintercept = max, color = 'Max'), size = 1.5)+
  facet_wrap(variable~factor(set, levels = c('original', 'set1', 'set2', 'set3',
                                             'set4', 'set5')), scales = 'free', ncol = 6)


# statistical tests
library(rstatix)
# Wilcoxon test
comparison %>%
  group_by(variable) %>%
  wilcox_test(data =., values ~ set, ref.group = 'original') %>%
  adjust_pvalue(method = "BH") %>%
  add_significance("p.adj")


## binary and ordinal variables
# bar plot of score proportions across different data sets
categorical <- c('pN', 'pT','LungMets', 'NRAS_cat', 'KRAS_cat', 'BiliaryInv', 'VascInv')
vars_categorical <- vars%>%
  dplyr::select(categorical)

set1 <- complete(imp, action = 1L)[categorical] #set1

# binary
original1 <- prop.table(table(vars_categorical$BiliaryInv, useNA = "always"))
imp1 <- prop.table(table(set1$BiliaryInv, useNA = "always"))

# test if proportions differ between data sets
pr_test <- cbind(original1, imp1) #... imp2-5
pr_test <- pr_test[!is.na(rownames(pr_test)),]
BiliaryInv_test <- pairwise_prop_test(pr_test, p.adjust.method = "BH")
BiliaryInv_test$Variable <- rep('BiliaryInv', nrow(BiliaryInv_test))


# ordinal
# N status
original1 <- prop.table(table(vars$pN, useNA = "always"))
imp1 <- prop.table(table(set1$pN, useNA = "always"))

# test if there are relationship between two ordinal values
chis_test <- cbind(original1, imp1)
chis_test <- chis_test[!is.na(rownames(chis_test)),]
pN_test <- chisq_test(chis_test)
pN_test$Variable <- rep('pN', nrow(pN_test))

# stacked bar plots
original <- vars_categorical
original$data_set <- c(rep('original', nrow(original)))

imp1 <- set1[,categorical]
imp1$data_set <- c(rep('set1', nrow(imp1)))

stacked_data <- rbind(original, imp1) #..imp5

stacked <- pivot_longer(stacked_data,
                        cols=c(1:length(categorical)),
                        names_to = 'variable',
                        values_to = 'value')

stacked$value <- ifelse(is.na(stacked$value), 'missing', stacked$value)



stacked$data_set <- factor(stacked$data_set, levels=c('original', 'set1', 'set2', 'set3', 'set4', 'set5')) 
stacked$value <- factor(stacked$value, levels = as.character(c('0', '1', '2', '3', '4', 'missing')))

ggplot(data=stacked, aes(x=data_set, fill=value)) +
  geom_bar(position = 'fill')+
  labs(x = 'Data sets', y='fraction of score values')+
  scale_fill_manual(values = c("#56B4E9","#E69F00","#009E73","#CC79A7", "#0072B2","#000000"))+
  theme_classic()+
  facet_wrap(~variable, ncol =3, scales = 'free_y')

## ---------------------------------------------------------------------- SAVE THE DATA ----------------------------------------------------------------------

# select the data set with highest similarity to the original data
df_Karo_complete <- complete(imp, action = 2L)

# save the data with imputed values
write_csv(df_Karo_complete, "./output/KaroLiver_complete.csv")

## -----------------------------------------------------------------------------------------------------------------------------------------------------------
