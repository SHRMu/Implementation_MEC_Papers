function [PG_OA_FLNC, PG_OA_ILC, Nic_EA, Nic_OA, Cost_Cloud_FLNC_EA, Cost_Cloud_FLNC_OA] = Performance_Gain(Ria, FLNC_Oac, Di, Li, Fi_c, Ci_l)
    [WD_N, ~] = size(Ria);
    
    [Dia_FLNC_EA, Dic_FLNC_EA, Nia_EA, Nic_EA, Cost_FLNC_EA, Cost_Cloud_FLNC_EA] = FLNC_EA(Ria, FLNC_Oac, Di, Li, Fi_c, Ci_l);
    [Dia_FLNC_OA, Dic_FLNC_OA, Nia_OA, Nic_OA, Cost_FLNC_OA, Cost_Cloud_FLNC_OA] = FLNC_OA(Ria, FLNC_Oac, Di, Li, Fi_c, Ci_l);
    [Dia_ILC_OA, Dic_ILC_OA, Cost_ILC_OA] = ILC_OA(Ria, Di, Li, Fi_c, Ci_l);

    PG_OA_FLNC = zeros(1,WD_N);
    PG_OA_ILC = zeros(1,WD_N);
    
    for xi = 1:WD_N
        PG_OA_FLNC(1,xi) = Cost_FLNC_EA(1,xi)/Cost_FLNC_OA(1,xi);
        PG_OA_ILC(1,xi) = Cost_FLNC_EA(1,xi)/Cost_ILC_OA(1,xi);
    end
    
end