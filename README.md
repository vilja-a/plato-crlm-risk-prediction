# plato-crlm-risk-prediction

## Individualized Recurrence Prediction After Colorectal Cancer Liver Metastasis Resection

This repository contains source code and supplementary information for the evaluation of clinical risk scores predicting recurrence after colorectal cancer liver metastasis resection, including:

1. Set-up and read-in the data
2. Data description: summary table, survival descriptions, cumulative incidence plots, competing risks
3. Missing data imputations
4. Discrimination analysis
5. Model recalibrations including net benefit and calibration with bootstrapping
6. External validation of recalibrated models in independent cohort
7. Table 1: Example of clinical variables required for running all the code.

The web calculator **PLATO** is available at www.plato-calc.org
The source code for PLATO is available at https://github.com/vilja-a/PLATO

#

**Evaluated risk scores:**
- Fong score, Fong et al. 1999: https://doi.org/10.1097/00000658-199909000-00004
- GAME score, Margonis et al. 2018 https://doi.org/10.1002/bjs.10838
- Helsinki score, Reijoinen et al. 2023 https://doi.org/10.1111/apm.13305
- Konopke score, Konople et al. 2008: https://doi.org/10.1111/j.1478-3231.2008.01845.x
- m-CS, Brudvik et al. 2019: https://doi.org/10.1097/sla.0000000000002319
- Nagashima score, Nagashima et al. 2006: https://doi.org/10.3748/wjg.v12.i39.6305
- Nordlinger score, Nordlinger et al. 1996: http://www.ncbi.nlm.nih.gov/pubmed/8608500
