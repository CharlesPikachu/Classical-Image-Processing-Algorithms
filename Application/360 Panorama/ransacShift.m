%{
Author:
    Charles
Function:
    Compute the shift of neighbouring images.
Input:
    -matched_points: matched keypoints.
    -image_sift_pre: structure which has three domains(image, keypoints and descriptor).
    -image_sift: structure which has three domains(image, keypoints and descriptor).
Output:
    -x_shift: the shift between two images in x axis.
    -y_shift: the shift between two images in y axis.
%}
function [x_shift, y_shift] = ransacShift(matched_points, image_sift_pre, image_sift)
image_size_pre = size(image_sift_pre.image);
num_matches = size(matched_points, 1);
best_matches = [];
threshold_ransac = 8;
max_inliers = 0;
max_iters = 400;
for iter = 1: max_iters
    random_match_idxs = randperm(num_matches, ceil(0.15 * num_matches));
    random_matches = matched_points(random_match_idxs, :);
    x1_points = image_sift_pre.keypoints(random_matches(:, 1), 1);
    y1_points = image_sift_pre.keypoints(random_matches(:, 1), 2);
    x2_points = image_sift.keypoints(random_matches(:, 2), 1) + image_size_pre(2);
    y2_points = image_sift.keypoints(random_matches(:, 2), 2);
    x_shift = round(mean(x2_points - x1_points));
    y_shift = round(mean(y2_points - y1_points));
    inliers = 0;
    for mp = 1: num_matches
        % point1 = image_sift_pre.keypoints(matched_points(mp), 1:2);
        point1 = image_sift_pre.keypoints(mp, 1:2);
        % point2 = image_sift.keypoints(matched_points(mp), 1:2) + [image_size_pre(2), 0];
        point2 = image_sift.keypoints(mp, 1:2) + [image_size_pre(2), 0];
        point2_shift = point2 - [x_shift, y_shift];
        error = point2_shift - point1;
        if error(1) < threshold_ransac && error(2) < threshold_ransac
            inliers = inliers + 1;
        end
    end
    if inliers >= max_inliers
        max_inliers = inliers;
        best_matches = random_matches;
    end
    if inliers > floor(0.6 * num_matches)
        fprintf('[INFO]: Align neighboring pairs using RANSAC successfully...\n');
        break;
    elseif iter == max_iters
        fprintf('[INFO]: Fail to align neighboring pairs using RANSAC...\n');
    end
end
x1_points = image_sift_pre.keypoints(best_matches(:, 1), 1);
y1_points = image_sift_pre.keypoints(best_matches(:, 1), 2);
x2_points = image_sift.keypoints(best_matches(:, 2), 1) + image_size_pre(2);
y2_points = image_sift.keypoints(best_matches(:, 2), 2);
x_shift = round(mean(x2_points - x1_points));
y_shift = round(mean(y2_points - y1_points));
end