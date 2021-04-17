clear all;

dcm_dir = '/Volumes/Rajat_Thesis_Files/Poldrack_Data/DCM_Spectral/DCM/DCM_allsubs/';
savedir = '/Volumes/Rajat_Thesis_Files/Poldrack_Data/DCM_Spectral/DCM/';

listing = dir(dcm_dir);
GCM = {listing.name};
GCM = GCM(4:110);
GCM = strcat(dcm_dir,GCM)';
GCM = spm_dcm_fit(GCM); 

save(fullfile(savedir,'GCM.mat'),'GCM');