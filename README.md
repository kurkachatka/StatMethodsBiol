This repository contains code in R that generates data used during statistics courses taught at the University of Gdansk Biology Faculty for master students.

During this course students are taught basic methods, most of which are parametric statistical analyses, therefore a lot of normally distributed data with even variance, and no autocorrelation is needed.
As such data is rare 'in the wild', I have decided to generate it for this teaching assignment. List of analyses performed with those datasets:
1) ANOVA with repeated measurements
2) multifactor ANOVA
3) correlation and regression (linear models)
4) Chi2 test


Metadata:

**species** - species of examined plant (3 levels: _Healianthus, Triticum, Arabidopsis_)
**seeds** - experimental treatment of seeds before the experiment (2 levels: warm and cold)
**N_leaf** - number of leaves counted at the end of the studied period
**steam_growth** - stem growth at the end of experiment, in cm
**light** - intensity of light, in lx
**zinc** - % concentration of zinc in the soil
**H2O_intake** - water intake, studied at the end of each of the 3 experimental weeks, in ml
**pest** - occurrence of spider mice (2 levels: yes, no)
