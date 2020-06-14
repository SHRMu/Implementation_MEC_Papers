function [Nic_ILC_OA, Cost_ILC_OA, Cost_Cloud_ILC_OA] = ILC_OA(Ria, Di, Li, Fi_c, Ci_l)

    [WD_N, AP_N] = size(Ria);
    [~,EC_N] = size(Fi_c);
    
    Dia_ILC_OA = zeros(WD_N, WD_N);
    Nia_ILC_OA = zeros(WD_N, AP_N);
    Dic_ILC_OA = zeros(WD_N, WD_N);
    Nic_ILC_OA = zeros(WD_N, EC_N);
    
    Ci_ILC_OA = zeros(WD_N, WD_N);
    
    % increasing numbers of WDs
    for xi = 1:WD_N
        
        dia = Dia_ILC_OA(xi,1:xi);
        nia = Nia_ILC_OA(xi,:);
        
        dic = Dic_ILC_OA(xi,1:xi);
        nic = Nic_ILC_OA(xi,:);
        
        cost = Ci_ILC_OA(xi,1:xi);
        [~, index] = sort(Li(1,1:xi),"descend");
        for i = index
            [wia, ai, wic, ei] = find_AP_EC(i, Ria, Di, Li, Fi_c, dia, dic);
            Ci_ac = wia + wic;
            if Ci_ac < Ci_l(1,i)
                % phase 1 offloading 
                dia(1,i) = ai;
                dic(1,i) = ei;
                nia(1,ai) = nia(1,ai) + 1;
                nic(1,ei) = nic(1,ei) + 1;
                cost(1,i) = Ci_ac;
                % phase 2 update
                check = 1;
                while check ~= 0
                    check = 0;
                    for pre_i = index(1,1:find(index==i))
                        pre_ai = dia(1,pre_i);
                        pre_ei = dic(1,pre_i);
                        if pre_ai ~= 0 && pre_ei ~= 0
                            [wia, ai, wic, ei] = update_AP_EC(pre_i, Ria, Di, Li, Fi_c, dia, pre_ai, dic, pre_ei);
                            if ai ~= pre_ai || ei ~= pre_ei
                                dia(1,pre_i) = ai;
                                dic(1,pre_i) = ei;
                                check = 1;
                                break
                            end                   
                            cost(1,pre_i) = wia + wic;
                        end
                    end
                end
            else
                cost(1,i) = Ci_l(1,i);
            end           
        end
        Dia_ILC_OA(xi,1:xi) = dia;
        Nia_ILC_OA(xi,:) = nia;
        
        Dic_ILC_OA(xi,1:xi) = dic;
        Nic_ILC_OA(xi,:) = nic;
        
        Ci_ILC_OA(xi,1:xi) = cost;
    end
    
    Cost_ILC_OA = zeros(1,WD_N);
    for xi = 1:WD_N
        Cost_ILC_OA(1,xi) = sum(Ci_ILC_OA(xi,:));
    end
    
    Cost_Cloud_ILC_OA = zeros(WD_N,EC_N);
    for xi=1:WD_N
        dic = Dic_ILC_OA(xi,1:xi);
        for di = 1:xi
            ei = dic(1,di);
            if ei ~= 0
                Cost_Cloud_ILC_OA(xi,ei) = Cost_Cloud_ILC_OA(xi,ei) + Ci_ILC_OA(xi,di); 
            end
        end
    end
    
end

function [wia, ai, wic, ei] = find_AP_EC(xi, Ria, Di, Li, Fi_c, dia, dic)
    [~, AP_N] = size(Ria);
    [~, EC_N] = size(Fi_c);
    wia_list = zeros(1,AP_N);
    wic_list = zeros(1,EC_N);
    for ai = 1:AP_N
        wia = sqrt(Di(1,xi)/Ria(xi,ai));
        wia = wia*(wia + sum_wia(ai, Di, Ria, dia));
        wia_list(1,ai) = wia;  
    end
    
    for ei = 1:EC_N
        wic = sqrt(Li(1,xi)/Fi_c(1,ei));
        wic = wic*(wic+sum_wic(ei, Li, Fi_c, dic));
        wic_list(1,ei) = wic;
    end
    
    [wia, ai] = min(wia_list);
    [wic, ei] = min(wic_list);
    
end

function [wia, ai, wic, ei] = update_AP_EC(xi, Ria, Di, Li, Fi_c, dia, pre_ai, dic, pre_ei)
    [~, AP_N] = size(Ria);
    [~, EC_N] = size(Fi_c);
    wia_list = zeros(1,AP_N);
    wic_list = zeros(1,EC_N);
    for ai = 1:AP_N
        wia = sqrt(Di(1,xi)/Ria(xi,ai));
        if ai ~= pre_ai
            wia = wia*(wia + sum_wia(ai, Di, Ria, dia));
        else
            wia = wia*(sum_wia(ai, Di, Ria, dia));
        end
        wia_list(1,ai) = wia;  
    end
    
    for ei = 1:EC_N
        wic = sqrt(Li(1,xi)/Fi_c(1,ei));
        if ei ~= pre_ei
            wic = wic*(wic + sum_wic(ei, Li, Fi_c, dic));
        else
            wic = wic*(sum_wic(ei, Li, Fi_c, dic));
        end
        wic_list(1,ei) = wic;
    end
    
    [wia, ai] = min(wia_list);
    [wic, ei] = min(wic_list);
    
end

function sum = sum_wia(ai, Di, Ria, dia)
    sum = 0;
    [~,num] = size(dia);
    for xi = 1:num
        if dia(1,xi) == ai
            sum = sum + sqrt(Di(1,xi)/Ria(xi,ai));
        end
    end
end

function sum = sum_wic(ei, Li, Fi_c, dic)
    sum = 0;
    [~,num] = size(dic);
    for xi = 1:num
        if dic(1,xi) == ei
            sum = sum + sqrt(Li(1,xi)/Fi_c(1,ei));
        end
    end 
end