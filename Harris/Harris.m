%{
Author:
    Charles
Function:
    The main function of Interest Point Detector - Harris.
%}
image_path = '';
image = imread(image_path);
% [x, y, scores, Ix, Iy] = extractPoints1_1(image);
[x, y, scores, Ix, Iy] = extractPoints3_3(image);
figure;
imshow(image);
hold on;
fprintf('Point number: %d\n', size(scores, 2));
for i = 1: size(scores, 2)
    plot(x(i), y(i), 'ro', 'MarkerSize', scores(i) * 5);
end
saveas(gcf, 'harris_results.jpg');
hold off;