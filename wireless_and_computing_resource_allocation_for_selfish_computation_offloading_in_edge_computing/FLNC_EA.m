function [Nic_off, Cost_FLNC_EA, Cost_Cloud_FLNC_EA] = FLNC_EA(Ria, FLNC_Oac, Di, Li, Fi_c, Ci_l)

    [WD_N,AP_N] = size(Ria);
    [~,EC_N] = size(Fi_c);
    
    Dia_FLNC_EA = zeros(WD_N, WD_N);
    Dic_FLNC_EA = zeros(WD_N, WD_N);
    Nia_off = zeros(WD_N, AP_N);
    Nic_off = zeros(WD_N, EC_N);
    
    Ci_FLNC_EA = zeros(WD_N, WD_N);
    Cost_FLNC_EA = zeros(1,WD_N);
    
    for xi = 1:WD_N
        [wia, ai] = FLNC_EA_findAP(Ria(xi,:), Nia_off(xi,:));
        ei = FLNC_Oac(1,ai);
        wic = Fi_c(1,ei)/(Nic_off(xi,ei)+1);
        Cia = Di(1,xi)/wia + Li(1,xi)/wic;
        if Cia < Ci_l(1,xi)
            %offload
            Dia_FLNC_EA(xi:WD_N,xi) = ai;
            Dic_FLNC_EA(xi:WD_N,xi) = ei;
            Nia_off(xi:WD_N,ai) = Nia_off(xi,ai) + 1;
            Nic_off(xi:WD_N,ei) = Nic_off(xi,ei) + 1;
            Ci_FLNC_EA(xi:WD_N,xi) = Cia;
            % update previous Ci
            for pre_i = 1:xi-1
                pre_ai = Dia_FLNC_EA(xi,pre_i);
                pre_ei = Dic_FLNC_EA(xi,pre_i);
                if pre_ai == ai || pre_ei == ei
                    pre_ci = Di(1,pre_i)/(Ria(pre_i,pre_ai)/Nia_off(xi,pre_ai)) + Li(1,pre_i)/(Fi_c(1,pre_ei)/Nic_off(xi,pre_ei));
                    Ci_FLNC_EA(xi:WD_N,pre_i) = pre_ci;
                end
            end
        else
            Ci_FLNC_EA(xi:WD_N,xi) = Ci_l(1,xi);
        end
        Cost_FLNC_EA(1,xi) = sum(Ci_FLNC_EA(xi,:));
    end
    
    Cost_Cloud_FLNC_EA = zeros(WD_N,EC_N);
    for xi=1:WD_N
        dic = Dic_FLNC_EA(xi,1:xi);
        for di = 1:xi
            ei = dic(1,di);
            if ei ~= 0
                Cost_Cloud_FLNC_EA(xi,ei) = Cost_Cloud_FLNC_EA(xi,ei) + Ci_FLNC_EA(xi,di); 
            end
        end
    end
end

function [wia_max, ai] = FLNC_EA_findAP(Ria_xi, Nia_off_xi)
    [~, AP_N] = size(Ria_xi);  
    % offload to AP with max wia
    wia_list = zeros(1,AP_N);
    for ai = 1:AP_N
        wia = Ria_xi(1,ai);
        if Nia_off_xi(1,ai) ~= 0
            % share uplink equally
            wia = wia/(Nia_off_xi(1,ai)+1); 
        end  
        wia_list(1,ai) = wia;
    end
    
    [wia_max, ai] = max(wia_list);
    
end



