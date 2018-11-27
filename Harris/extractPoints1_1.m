%{
Author:
    Charles
Function:
    Extract interest points, filters size is 1*1.
Input:
    -image: image matrix.
Output:
    -x: x locations of detected keypoints;
    -y: y locations of detected keypoints;
    -scores: store the R(Harris values > threshold);
    -Ix: store the gradients in the x-direction at each pixel;
    -Iy: store the gradients in the y-direction at each pixel.
%}
function [x, y, scores, I_x, I_y] = extractPoints1_1(image)
%{
Step1: Preprocessing.
%}
if numel(size(image)) == 3
    I_gray = rgb2gray(image);
else
    I_gray = image;
end
I_gray_d = im2double(I_gray);
%{
Step2: Set filters.
%}
w_horizontal = [1 0 -1];
w_vertical = [1; 0; -1];
%{
Step3: Get the gradient in each direction using the filters.
%}
filtered_x = imfilter(I_gray_d, w_horizontal);
filtered_y = imfilter(I_gray_d, w_vertical);
I_x = filtered_x;
I_y = filtered_y;
%{
Step4: Compute the values we need (I_x^2, I_y^2 and I_x*I_y).
%}
f_gaussian = fspecial('gaussian');
I_x2 = imfilter(I_x.^2, f_gaussian);
I_y2 = imfilter(I_y.^2, f_gaussian);
I_xy = imfilter(I_x.*I_y, f_gaussian);
%{
Step5: Compute the Harris values.
%}
% empirical constant.
k = 0.04;
% for saving Harris values.
H = zeros(size(image, 1), size(image, 2));
for y = 1: size(image, 1)
    for x = 1: size(image, 2)
        M = [I_x2(y, x), I_xy(y, x);
             I_xy(y, x), I_y2(y, x)];
        R = det(M) - (k * trace(M)^2);
        H(y, x) = R;
    end
end
% set threshold
threshold = abs(5 * mean(mean(H)));
[row, col] = find(H > threshold);
scores = [];
for idx = 1: size(row, 1)
    r_idx = row(idx);
    c_idx = col(idx);
    scores = cat(2, scores, H(r_idx, c_idx));
end
y = row;
x = col;
end