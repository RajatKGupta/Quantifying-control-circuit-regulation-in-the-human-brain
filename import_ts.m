

path = ''; %Storing the output
path_mat_flies = 'DCM_Data/'; %Input .mat files containing time series for each region
listing = dir(path_mat_flies);
roinames = load('') % .mat file containing names for each region
nsubjects = 107; %number of subjects
ntime = 152;  %no of time points in each ts
TR = 2; 

for i = 1:nsubjects
    sub_dir = fullfile(path, listing(3+i).name(1:length(listing(3+i).name)-4)); % adding 3 here as first four directories were useless like .DS_Store. Check this before running the code and change if required!
    mkdir(sub_dir);
    
    temp_data = load(fullfile(path_mat_flies,listing(3+i).name)); % subject's data
    
    %Prepare VOIs
    
   for regions=1:31
        
       % Get timeseries
            Y= temp_data.data(:,regions);
            temp_name = roinames.names(regions,:);
            temp_name =  temp_name(find(~isspace(temp_name)));
            
            % Make spm compatible stucture
            xY    = struct();
            xY.u  = Y;  
            xY.X0 = repelem(ones(ntime,1),1);
            xY.Sess = 1;
            xY.name = temp_name;
            str   = sprintf(strcat('VOI_',temp_name));  
            save(fullfile(sub_dir,str),'xY');
   end
    
      % Prepare SPM
        SPM = struct();
        SPM.Sess(1).U(1).dt = TR/16;
        SPM.Sess(1).U(1).u  = ['resting_state']; 
        SPM.Sess(1).U(1).name = {'resting_state'};
        SPM.xY.RT   = TR;
        save(fullfile(sub_dir,'SPM.mat'),'SPM');
end
    
