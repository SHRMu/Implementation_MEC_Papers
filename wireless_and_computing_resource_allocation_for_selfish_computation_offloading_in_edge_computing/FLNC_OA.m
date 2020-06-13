function [Dia_FLNC_OA, Dic_FLNC_OA, Nia_off, Nic_off, Cost_FLNC_OA, Cost_Cloud_FLNC_OA] = FLNC_OA(Ria, FLNC_Oac, Di, Li, Fi_c, Ci_l)
    [WD_N,AP_N] = size(Ria);
    [~,EC_N] = size(Fi_c);
    
    Dia_FLNC_OA = zeros(WD_N, WD_N);
    Dic_FLNC_OA = zeros(WD_N, WD_N);
    Nia_off = zeros(WD_N, AP_N);
    Nic_off = zeros(WD_N, EC_N);
    
    Ci_FLNC_OA = zeros(WD_N, WD_N);
    
    for xi = 1:WD_N
        [wia_max, ai] = FLNC_OA_findAP(Ria, Nia_off(xi,:), xi, Dia_FLNC_OA(xi,:), Di);
        ei = FLNC_Oac(1,ai);    
        wic = Fi_c(1,ei);
        if Nic_off(xi,ei) ~= 0
            wic = wic*sqrt(Li(1,xi)/wic)/(sqrt(Li(1,xi)/wic)+Sum_Wjc(Dic_FLNC_OA(xi,:), ei, Li, Fi_c));
        end
        Cia = Di(1,xi)/wia_max + Li(1,xi)/wic;
        if Cia < Ci_l(1,xi)
            Dia_FLNC_OA(xi:WD_N,xi) = ai;
            Dic_FLNC_OA(xi:WD_N,xi) = ei;
            Nia_off(xi:WD_N,ai) = Nia_off(xi,ai) + 1;
            Nic_off(xi:WD_N,ei) = Nic_off(xi,ei) + 1;
            Ci_FLNC_OA(xi:WD_N,xi) = Cia;
            % update previous Ci
            for pre_i = 1:xi
                pre_ai = Dia_FLNC_OA(xi,pre_i);
                pre_ei = Dic_FLNC_OA(xi,pre_i);
                if pre_ai == ai ||  pre_ei == ei
                    pre_wia = Ria(pre_i,pre_ai)*sqrt(Di(1,pre_i)/Ria(pre_i,pre_ai))/Sum_Rja(Dia_FLNC_OA(xi,:),pre_ai,Ria,Di);
                    pre_wic = Fi_c(1,pre_ei)*sqrt(Li(1,pre_i)/Fi_c(1,pre_ei))/Sum_Wjc(Dic_FLNC_OA(xi,:),pre_ei,Li,Fi_c);
                    ci_pre = Di(1,pre_i)/pre_wia + Li(1,pre_i)/pre_wic;
                    Ci_FLNC_OA(xi:WD_N,pre_i) = ci_pre; 
                end
            end
        else
            Ci_FLNC_OA(xi:WD_N,xi) = Ci_l(1,xi);
        end 
    end
    
    Cost_FLNC_OA = zeros(1,WD_N);
    for i = 1:WD_N
        Cost_FLNC_OA(1,i) = sum(Ci_FLNC_OA(i,:));
    end
    
    Cost_Cloud_FLNC_OA = zeros(WD_N,EC_N);
    for xi=1:WD_N
        dic = Dic_FLNC_OA(xi,1:xi);
        for di = 1:xi
            ei = dic(1,di);
            if ei ~= 0
                Cost_Cloud_FLNC_OA(xi,ei) = Cost_Cloud_FLNC_OA(xi,ei) + Ci_FLNC_OA(xi,di); 
            end
        end
    end
end

function [wia_max, ai] = FLNC_OA_findAP(Ria, Nia_off_xi, xi, dia, Di)
    [~ , AP_N] = size(Ria);
    % offload to max uplink rate
    wia_list = zeros(1,AP_N);
    for ai = 1:AP_N
        wia = Ria(xi,ai);
        if Nia_off_xi(1,ai) ~= 0
            wia = wia*sqrt(Di(1,xi)/wia)/(sqrt(Di(1,xi)/wia)+Sum_Rja(dia, ai, Ria, Di)); 
        end
        wia_list(1,ai) = wia;
    end
    
    [wia_max,ai] = max(wia_list);
     
end

function sum = Sum_Rja(dia, ai, Ria, Di)
    sum = 0;
    [WD_N, ~] = size(Ria);
    for i = 1:WD_N
        if dia(1,i) == ai
            sum = sum + sqrt(Di(1,i)/Ria(i,ai));
        end
    end
end

function sum = Sum_Wjc(dic, ei, Li, Fi_c)
    sum = 0;
    [~,WD_N] = size(dic);
    for xi = 1:WD_N
        if dic(1,xi) == ei
            sum = sum + sqrt(Li(1,xi)/Fi_c(1,ei));
        end
    end
end

