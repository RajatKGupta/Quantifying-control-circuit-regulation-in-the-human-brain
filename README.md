# Control-in-Human-Brain
Repository containing code for Quantifying control circuit regulation in the human brain

Manuscript: https://www.biorxiv.org/content/10.1101/2021.03.30.437729v2

Steps for using the code (requires SPM mounted on path):

1. Extract eigenvariates for each brain-region (as in the example file ts.mat) and store it in a .mat file. 
2. Run import_ts.m 
3. Run specify_dcm.m
4. Run estimate_dcm.m
5. Using the esimated dcm, form a .mat file containing parents (as in example file parents.mat).
6. Run sys_id_analysis.m (Note - the manuscript shows a certain procedure for system identification which was originally scripted in python but now has been adapted to a simpler code in this script. Be careful to select the N4weighing to be SSARX to take feedback into account to replicate manuscript's results). 
