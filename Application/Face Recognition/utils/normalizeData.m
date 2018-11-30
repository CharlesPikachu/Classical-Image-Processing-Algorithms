%{
Author:
    Charles
Function:
    Normalize the features in X.
Input:
    -X: the data need to be processed.
Output:
    -X_norm: the normalized data.
    -mu: the mean of X.
    -sigma: the standard deviation of X.
%}
function [X_norm, mu, sigma] = normalizeData(X)
mu = mean(X);
X_norm = bsxfun(@minus, X, mu);
sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);
end