clear all;

spm('Defaults','fMRI');
spm_jobman('initcfg');

clear DCM;

nsubjects = 107
% ROIs
matdir = 'DCM/'; %DCM directory from import ts script
savedir = 'DCM/DCM_allsubs'; %Save directory
listing_matdir = dir(matdir);
TR = 2;

for i=1:nsubjects       % we have 107 subjects
    
    clear DCM;

    voidir = strcat(matdir,listing_matdir(4+i).name);
    listing_voidir = dir(voidir)
    
    for j=1:31
        tempvar = load(fullfile(voidir,listing_voidir(3+j).name));
        DCM.xY(j) = tempvar.xY;
    end
    
    % Metadata
    v = length(DCM.xY(1).u); % number of time points
    n = length(DCM.xY);      % number of regions

    DCM.v = v;
    DCM.n = n;
    
    % Timeseries
    DCM.Y.dt  = TR;
    DCM.Y.Q   = spm_Ce(ones(1,n)*v);
    DCM.Y.X0  = DCM.xY(1).X0;
    for p = 1:DCM.n
        DCM.Y.y(:,p)  = double(DCM.xY(p).u);
        DCM.Y.name{p} = DCM.xY(p).name;
    end
   

    % Task inputs
    DCM.U.u    = zeros(v,1);
    DCM.U.name = {'null'};         

    % Connectivity
    DCM.a  = ones(n,n);
    DCM.b  = zeros(n,n,0);
    DCM.c  = zeros(n,0);
    DCM.d  = zeros(n,n,0);

    % Timing
    DCM.TE     = 0.03;
    DCM.delays = repmat(TR,DCM.n,1);

    % Options
    DCM.options.nonlinear  = 0;
    DCM.options.two_state  = 0;
    DCM.options.stochastic = 0;
    DCM.options.analysis   = 'CSD';
    DCM.options.induced   = 1;
    DCM.options.nnodes   = 8; 

    str = strcat('DCM_',listing_matdir(4+i).name);
    DCM.name = str;
    save(fullfile(savedir,str),'DCM');
end






