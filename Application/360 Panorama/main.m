%{
Author:
    Charles
Function:
    Main function of 360 Panorama.
%}
%{
Step1: Initialization.
%}
clear;
close all;
addpath('./Sift');
ROOTDIR = './pictures1/';
OUTPUTDIR = './results/pictures1/';
images_path = dir([ROOTDIR '*JPG']);
rotate_angle = 90;
% rotate_angle = 0;
Wccd = 4.8;
% Wccd = 6.4;
images_pro = {};
shifts = [];
%{
Step2: Warp images to spherical coordinates;
       Extract features;
       Align neighboring pairs using RANSAC;
       Write out list of neighboring translations.
%}
for i = length(images_path): -1: 1
    image_path = [ROOTDIR images_path(i).name];
    if i == length(images_path)
        [~, image_pro] = cylinderProjection(image_path, rotate_angle, Wccd);
        images_pro = [images_pro, {image_pro}];
        image_sift = Sift(image_pro);
        image_sift_pre = image_sift;
    else
        [~, image_pro] = cylinderProjection(image_path, rotate_angle, Wccd);
        images_pro = [images_pro, {image_pro}];
        image_sift = Sift(image_pro);
        [matched_points, distances] = siftMacth(image_sift_pre, image_sift, 1);
        [x_shift, y_shift] = ransacShift(matched_points, image_sift_pre, image_sift);
        shifts = [shifts; [x_shift, y_shift]];
        image_sift_pre = image_sift;
    end
end
if ~exist(OUTPUTDIR)
    mkdir(OUTPUTDIR);
end
save([OUTPUTDIR 'images_pro,mat'], 'images_pro');
save([OUTPUTDIR 'shifts.mat', 'shifts']);
%{
Step3: Correct for drift;
       Read in warped images and blend them;
       Crop the result and import into a viewer.
%}
shifts_correct = correctDrift(images_pro, shifts);
for image_pro_idx = length(images_pro): -1: 1
    if image_pro_idx == length(images_pro)
        stitch_image = images_pro{image_pro_idx};
    else
        image_pro_pre = images_pro{image_pro_idx};
        shift = shifts_correct(image_pro_idx, :);
        stitch_image = stitchImages(image_pro_pre, stitch_image, shift);
    end
end
imwrite(stitch_image, [OUTPUTDIR 'stitch_image.JPG']);
figure();
imshow(stitch_image);
stitch_image_crop = stitch_image(70: (size(stitch_image, 1) - 60), :, :);
imwrite(stitch_image_crop, [OUTPUTDIR 'stitch_image_cropped.JPG']);
figure();
imshow(stitch_image_crop);