clear;
function H = Lw_kernel(k)
      if k<1 || 9<k
        error("k is not between 1 and 9");
      end
        L = 1/6 * [1; 2; 1];
        E = 1/2 * [1; 0; -1];
        S = 1/2 * [1; -2; 1];

        H1 = L * L.';
        
        H2 = L * E.';
       
        H3 = L * S.';
       
        H4 = E * L.';
       
        H5 = E * E.';
        
        H6 = E * S.';
        
        H7 = S * L.';
    
        H8 = S * E.';    
     
        H9 = S * S.';
    
        l_kernel =cat(H1,H2,H3,H4,H5,H6,H7,H8,H9);
        H = squeeze(l_kernel(:,:,k));
    
end



