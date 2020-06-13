TIMES = 100; %simulation times

WD_N = 50;
AP_N = 5;
EC_N = 3;

SUM_PG_OA_FLNC = zeros(1,WD_N);
SUM_PG_OA_ILC = zeros(1,WD_N);

SUM_Nic_FLNC_EA = zeros(1,EC_N);
SUM_Nic_FLNC_OA = zeros(1,EC_N);

SUM_Cost_Cloud_FLNC_EA = zeros(WD_N,EC_N);
SUM_Cost_Cloud_FLNC_OA = zeros(WD_N,EC_N);

for i = 1:TIMES
    
    [Ria, FLNC_Oac, Di, Fi_c, Li, Ci_l, P_ia_t] = Data_Generator(WD_N, AP_N, EC_N);
    
    [PG_OA_FLNC, PG_OA_ILC, Nic_EA, Nic_OA, Cost_Cloud_FLNC_EA, Cost_Cloud_FLNC_OA] = Performance_Gain(Ria, FLNC_Oac, Di, Li, Fi_c, Ci_l);
    
    SUM_PG_OA_FLNC = SUM_PG_OA_FLNC + PG_OA_FLNC;
    SUM_PG_OA_ILC = SUM_PG_OA_ILC + PG_OA_ILC;
    
    SUM_Nic_FLNC_EA = SUM_Nic_FLNC_EA + Nic_EA;
    SUM_Nic_FLNC_OA = SUM_Nic_FLNC_OA + Nic_OA;
    
    SUM_Cost_Cloud_FLNC_EA = SUM_Cost_Cloud_FLNC_EA + Cost_Cloud_FLNC_EA;
    SUM_Cost_Cloud_FLNC_OA = SUM_Cost_Cloud_FLNC_OA + Cost_Cloud_FLNC_OA;
   
end

AVE_PG_OA_FLNC = SUM_PG_OA_FLNC/TIMES;
AVE_PG_OA_ILC = SUM_PG_OA_ILC/TIMES;

AVE_Nic_FLNC_EA = SUM_Nic_FLNC_EA/TIMES;
AVE_Nic_FLNC_OA = SUM_Nic_FLNC_OA/TIMES;

AVE_Cost_Cloud_FLNC_EA = SUM_Cost_Cloud_FLNC_EA/TIMES;
AVE_Cost_Cloud_FLNC_OA = SUM_Cost_Cloud_FLNC_OA/TIMES;

WDi = linspace(1,WD_N,WD_N);
figure

%Figure 3


%Figure 4
%Performance gain vs. numbers of WDs for A = 5APs, 
%Heterogenous ECs, Fc,tot = 192GHz

plot(WDi, AVE_PG_OA_FLNC, ...
     WDi, AVE_PG_OA_ILC);

%Figure 5
% plot(WDi, AVE_Nic_FLNC_EA(:,1), '--bs', ...
%      WDi, AVE_Nic_FLNC_EA(:,2), '-.bs', ...
%      WDi, AVE_Nic_FLNC_EA(:,3), '-bs', ...
%      WDi, AVE_Nic_FLNC_OA(:,1), '--o', ...
%      WDi, AVE_Nic_FLNC_OA(:,2), '-.o', ...
%      WDi, AVE_Nic_FLNC_OA(:,3), '-o');


%Figure 6
% plot(WDi, AVE_Cost_Cloud_FLNC_EA(:,1), '--bs', ...
%      WDi, AVE_Cost_Cloud_FLNC_EA(:,2), '-.bs', ...
%      WDi, AVE_Cost_Cloud_FLNC_EA(:,3), '-bs', ...
%      WDi, AVE_Cost_Cloud_FLNC_OA(:,1), '--o', ...
%      WDi, AVE_Cost_Cloud_FLNC_OA(:,2), '-.o', ...
%      WDi, AVE_Cost_Cloud_FLNC_OA(:,3), '-o');








