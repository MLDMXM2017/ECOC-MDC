function cplx = get_complexity_option(c1,c2,train,label,DC_OPTION)
    switch(DC_OPTION)
        case 'F1'
            cplx = get_complexityF1(c1,c2,train,label);
        case 'F2'
            cplx = get_complexityF2(c1,c2,train,label);
        case 'F3'
            cplx = get_complexityF3(c1,c2,train,label);
        case 'N2'
            cplx = get_complexityN2(c1,c2,train,label);
        case 'N3'
            cplx = get_complexityN3(c1,c2,train,label);
        case 'N4'
            cplx = get_complexityN4(c1,c2,train,label);
        case 'L3'
            cplx = get_complexityL3(c1,c2,train,label);
        case 'Cluster'
            cplx = get_complexityCluster(c1,c2,train,label);            
    end        
end