function pt2pt0 = mil_std_inlet(M0)

    % Model regimes
    i1 = M0 < 1;
    i2 = M0 < 5 & M0 >= 1;
    i3 = M0 >= 5;
    
    % preallocation
    pt2pt0 = zeros(1,size(M0,2));
    
    % calculation
    pt2pt0(i1) = 1;
    pt2pt0(i2) = 1-0.075*(M0(i2)-1).^1.35;
    pt2pt0(i3) = 800./(M0(i3).^4 + 935);
    
end