%{
Function:
        实现公式中的g, 边缘检测子
Author:
         Zhenchao Jin
%}
function g = edgeDetector(I, sigma)
I = BoundMirrorExpand(I);
G = fspecial('gaussian', 15, sigma);
X = conv2(I, G, 'same');
[Ix, Iy] = gradient(X);
g = 1 ./ (1 + Ix.^2 + Iy.^2);
end
