function [w1,w2] = trivec(A,B,C,p)
%%
% This code is part of the work entitled "Contextual automated template alignment for 2D group type separations with univariate detection"
% by Nino B. L. Milani, Ferry de Kruijff, Alan R. Garcia Cicourel, Rob Edam, Tijmen S. Bos, and Bob W. J. Pirok.
%%
%vector definition of p relative to points A,B,C
Ax = A(1);
Ay = A(2);
Bx = B(1);
By = B(2);
Cx = C(1);
Cy = C(2);
px = p(1);
py = p(2);

w1 = (Ax*(Cy-Ay) + (py-Ay)*(Cx-Ax)-px*(Cy-Ay))  /  ((By-Ay)*(Cx-Ax) - (Bx-Ax)*(Cy-Ay));
w2 = (py-Ay-w1*(By-Ay))  /  (Cy- Ay);
end

