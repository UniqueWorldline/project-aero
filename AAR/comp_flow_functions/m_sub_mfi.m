function [ M ] = m_sub_mfi( mfi,g )

ml = 0;
mh = 1.01;
mg = (ml+mh)/2;

g1 = (g^2)/(g-1);
g2 = (g-1)/2;

stop = false;
while stop == false
    
    mfi_calc = (g1*mg^2)*(1+g2*mg^2)/(1+g*mg^2)^2;
    
    if abs(mfi_calc-mfi) > 0.00001
        if mfi < mfi_calc
            mh = mg;
        else
            ml = mg;
        end
        
        mg = (ml+mh)/2;
        
    else
        M = mg;
        stop = true;
    end

end