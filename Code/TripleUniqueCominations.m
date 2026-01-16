function c123 = TripleUniqueCominations(n)
%%
% This code is part of the work entitled "Contextual automated template alignment for 2D group type separations with univariate detection"
% by Nino B. L. Milani, Ferry de Kruijff, Alan R. Garcia Cicourel, Rob Edam, Tijmen S. Bos, and Bob W. J. Pirok.
%%    
%function returns only unique combinations 
    l = 2;
    mint = 2;
    c123 = [];
        
    while l <= n
        c23 = []; 
        m = mint + l - 1;
        while m <= n
            c3 = (m:n)';
            c2 = repmat(m-1,size(c3));
            c23 = [c23;[c2,c3]];
            m = m + 1;
        end
        c1 = repmat(l-1, size(c23,1),1);
        c123 = [c123;[c1,c23]];
        l = l + 1;
    end
end
