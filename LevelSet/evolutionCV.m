%{
Function:
        实现level-set function 的迭代
Author:
         Zhenchao Jin
%}
function phi = evolutionCV(I, phi0, g, gx, gy, mu, nu, lambda, delta_t, epsilon, numIter)
I = BoundMirrorExpand(I);
phi = BoundMirrorExpand(phi0);
[phix, phiy] = gradient(phi);
eps = 1e-10;
phix = phix ./ sqrt(phix.^2 + phiy.^2 + eps);
phiy = phiy ./ sqrt(phix.^2 + phiy.^2 + eps);
for k = 1 : numIter
    phi = BoundMirrorEnsure(phi);
    delta_h = Delta(phi, epsilon);
    Curv = curvature(phi);
    distRictTerm = mu * (4 * del2(phi) - Curv);
    lengthTrem = lambda * delta_h .*( phix.*gx + phiy.*gy + g.*Curv);
    areaTerm = nu * g .* delta_h;
    new_term = distRictTerm + lengthTrem + areaTerm;
    phi = phi + delta_t * new_term;
end
phi = BoundMirrorShrink(phi);