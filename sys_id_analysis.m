clc;
clear;

data = load('ts.mat');
train = data.data;

parents = load('parents.mat');
parents = parents.parents;

Ts = 2.2; % TR

for i=1:length(parents)
    temp_p = parents{i}+1;
    temp_u = train(:,temp_p);
    field = strcat('idd_',num2str(i));
    idd.(field) = iddata(train(:,i),temp_u,Ts);
end

% System Identification 

opt = n4sidOptions('Focus','simulation','Display','on','EnforceStability',1,'N4Weight','SSARX','Maxsize',100000000,'InitialState','estimate');

for i=1:length(parents)
    system = strcat('idn_',num2str(i));
    temp = strcat('idd_',num2str(i));
    idn.(system) = n4sid(idd.(temp),10,'Ts',2.2,opt);
end


%Damping Ratio using system poles 
Damp = [];
for i=1:length(parents)
    field = strcat('idn.idn_',num2str(i));
    tempvar = eval(field);
    [d1,d2] = damp(tempvar);
    Damp = horzcat(Damp,d2);
end

%Natural Frequency using system poles
Freq = [];
for i=1:length(parents)
    field = strcat('idn.idn_',num2str(i));
    tempvar = eval(field);
    [d1,d2] = damp(tempvar);
    Freq = horzcat(Freq,d1);
end

% Steady-State Error EI 
EI = []
for i=1:length(parents)
    field = strcat('idn.idn_',num2str(i));
    tempvar = eval(field);
    trfn = tf(tempvar);
    s = size(trfn);
    coef = [];
    for j=1:s(2)
        coef = vertcat(coef,sum(trfn.Numerator{1,j})/sum(trfn.Denominator{1,j}));
    end
    EI = horzcat(EI,sum(coef));
    
end

