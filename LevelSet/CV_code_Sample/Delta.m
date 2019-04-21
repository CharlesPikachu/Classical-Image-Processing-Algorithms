function Delta_h = Delta(phi, epsilon)
%   Delta(phi, epsilon) compute the smooth Dirac function
%  
%   created on 04/26/2004
%   author: Chunming Li
%   email: li_chunming@hotmail.com
%   Copyright (c) 2004-2006 by Chunming Li

% Delta_h=(epsilon/pi)./(epsilon^2+ phi.^2);

Delta_h = (1 / 2 / epsilon) * (1 + cos(pi * phi / epsilon));
b = (phi<=epsilon) & (phi>=-epsilon);
Delta_h = Delta_h .* b;