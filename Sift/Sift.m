%{
Author:
    Charles
Function:
    The main function of Interest Point Descriptor - SIFT.
Input:
    -image_path: the image path.
Output:
    -result: structure which has three domains(image, keypoints, descriptor).
%}
function result = Sift(image_path)
%{
Step1: Preprocessing.
%}
image = imread(image_path);
image = imresize(image, [512, 512]);
if numel(size(image)) == 3
    I_gray = rgb2gray(image);
else
    I_gray = image;
end
image_size = size(I_gray);
I_gray = im2double(I_gray);
%{
Step2: Set hyperparameter.
%}
sigma = 1.6;
num_sublevels = 3;
num_octaves = floor(log2(min(image_size))) - 3;
max_iter = 5;
octave_start = -1;
%{
Step3: Implement sift.
%}
gaussian_pyramids = createGP(I_gray, num_sublevels, num_octaves, sigma, octave_start);
DoG_images = createDoG(gaussian_pyramids, num_sublevels, num_octaves);
thresh = 0.1;
EP_coordinates = detectEP(DoG_images, num_sublevels, num_octaves, thresh);
fprintf('Number of extreme points: %d...\n', size(EP_coordinates, 1));
% figure;
% imshow(image);
% hold on;
% for i = 1: size(EP_coordinates, 1)
%     coordinate = EP_coordinates(i, 1: 2) * 2^(EP_coordinates(i, 3) - 1 + octave_start);
%     plot(coordinate(1), coordinate(2), 'r+', 'MarkerSize', 5);
% end
% saveas(gcf, 'sift_results1.jpg');
% hold off;
accurate_coordinates = accurateKL(EP_coordinates, DoG_images, max_iter);
fprintf('Number of accurate points: %d...\n', size(accurate_coordinates, 1));
% figure;
% imshow(image);
% hold on;
% for i = 1: size(accurate_coordinates, 1)
%     coordinate = accurate_coordinates(i, 1: 2) * 2^(accurate_coordinates(i, 3) - 1 + octave_start);
%     plot(coordinate(1), coordinate(2), 'g+', 'MarkerSize', 10);
% end
% saveas(gcf, 'sift_results2.jpg');
% hold off;
keypoint_angle_interval = 2 * pi / 36;
descriptor_angle_interval = 2 * pi / 8;
[keypoints, descriptors] = generateDescriptor(accurate_coordinates, gaussian_pyramids, sigma, num_sublevels, keypoint_angle_interval, descriptor_angle_interval, octave_start);
drawSift(image, keypoints, keypoint_angle_interval, 'arrow');
result.image = image;
result.keypoints = keypoints;
result.descriptors = descriptors;