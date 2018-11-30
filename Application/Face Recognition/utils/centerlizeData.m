%{
Author:
    Charles
Function:
    Minus data by its mean value.
Input:
    -X: the data need to be processed.
Output:
    -X_c: the centerlized data.
    -mu: the mean value of input data X.
%}
function [X_c, mu] = centerlizeData(X)
mu = mean(X, 1);
X_c = bsxfun(@minus, X, mu);
end