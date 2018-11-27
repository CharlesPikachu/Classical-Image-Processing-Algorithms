%{
Author:
    Charles
Function:
    Generate keypoints and descriptors.
Input:
    -coordinates: accurate keypoint locatization.
    -gaussian_pyramids: the created gaussian pyramids.
    -sigma: the standard devation of the first layer in the first octave.
    -num_sublevels: the number of layers in each octave.
    -keypoint_angle_interval: the interval to divide 2*pi, which is used to compute the main angle of keypoints.
    -descriptor_angle_interval: the interval to divide 2*pi, which is used to generate descriptor.
    -octave_start: decide up/downsampling the image of the first layer in the first octave.
Output:
    -keypoints: the keypoints.
    -descriptors: the descriptors.
%}
function [keypoints, descriptors] = generateDescriptor(coordinates, gaussian_pyramids, sigma, num_sublevels, keypoint_angle_interval, descriptor_angle_interval, octave_start)
subpatch_sidelen = 4;
keypoints = zeros(size(coordinates));
descriptors = zeros(size(coordinates, 1), subpatch_sidelen^2 * (2*pi / descriptor_angle_interval));
for point = 1: size(coordinates, 1)
    coordinate = round(coordinates(point, :));
    sigma_now = sigma * 2^((coordinate(4)-1)/num_sublevels) * 2^(coordinate(3)-1);
    patch_size = 3 * 1.5 * sigma_now * 2;
    patch_size = floor(patch_size);
    if mod(patch_size, subpatch_sidelen) ~= 0
        patch_size = patch_size + subpatch_sidelen - mod(patch_size, subpatch_sidelen);
    end
    subpatch_size = patch_size / subpatch_sidelen;
    GP_image = gaussian_pyramids{coordinate(3)}{coordinate(4)};
    GP_image_size = size(GP_image);
    pad = 3;
    histogram_keypoint = zeros(1, 2*pi/keypoint_angle_interval);
    [xs, ys] = meshgrid(-(patch_size+2*pad)/2: (patch_size+2*pad)/2-1);
    xs_crop = xs + coordinate(1);
    ys_crop = ys + coordinate(2);
    xs_crop(xs_crop>GP_image_size(2)-1) = GP_image_size(2) - 1;
    ys_crop(ys_crop>GP_image_size(1)-1) = GP_image_size(1) - 1;
    xs_crop(xs_crop<2) = 2;
    ys_crop(ys_crop<2) = 2;
    for col = 1: patch_size
        for row = 1: patch_size
            dy = (GP_image(ys_crop(row+pad+1, col+pad), xs_crop(row+pad+1, col+pad)) - GP_image(ys_crop(row+pad-1, col+pad), xs_crop(row+pad-1, col+pad))) / 2;
            dx = (GP_image(ys_crop(row+pad, col+pad+1), xs_crop(row+pad, col+pad+1)) - GP_image(ys_crop(row+pad, col+pad-1), xs_crop(row+pad, col+pad-1))) / 2;
            dy = dy * exp(-(ys(row+pad, col+pad)^2 + xs(row+pad, col+pad)^2) / (60 * sigma_now));
            dx = dx * exp(-(ys(row+pad, col+pad)^2 + xs(row+pad, col+pad)^2) / (60 * sigma_now));
            angle = atan(dy / dx);
            if isnan(angle)
                angle = 0;
                dy = 0;
                dx = 0;
            end
            if angle < 0
                angle = angle + 2*pi;
            end
            if angle == 2*pi
                angle = 0;
            end
            angle = floor(angle / keypoint_angle_interval) + 1;
            magnitude = sqrt(dy^2 + dx^2);
            histogram_keypoint(angle) = histogram_keypoint(angle) + magnitude;
        end
    end
    histogram_keypoint = smoothHistogram(histogram_keypoint, 1);
    main_magnitude = max(histogram_keypoint);
    main_angle = find(histogram_keypoint == main_magnitude);
    angle_rotate = keypoint_angle_interval * main_angle;
    xs_rotate = round(xs.*cos(angle_rotate) - ys.*sin(angle_rotate));
    ys_rotate = round(xs.*sin(angle_rotate) + ys.*cos(angle_rotate));
    xs_rotate_crop = xs_rotate + coordinate(1);
    ys_rotate_crop = ys_rotate + coordinate(2);
    xs_rotate_crop(xs_rotate_crop>GP_image_size(2)-1) = GP_image_size(2) - 1;
    ys_rotate_crop(ys_rotate_crop>GP_image_size(1)-1) = GP_image_size(1) - 1;
    xs_rotate_crop(xs_rotate_crop<2) = 2;
    ys_rotate_crop(ys_rotate_crop<2) = 2;
    one_descriptor = zeros(subpatch_sidelen^2, 2*pi/descriptor_angle_interval);
    for col = 1: patch_size
        for row = 1: patch_size
            dy = (GP_image(ys_rotate_crop(row+pad+1, col+pad), xs_rotate_crop(row+pad+1, col+pad)) - GP_image(ys_rotate_crop(row+pad-1, col+pad), xs_rotate_crop(row+pad-1, col+pad))) / 2;
            dx = (GP_image(ys_rotate_crop(row+pad, col+pad+1), xs_rotate_crop(row+pad, col+pad+1)) - GP_image(ys_rotate_crop(row+pad, col+pad-1), xs_rotate_crop(row+pad, col+pad-1))) / 2;
            dy = dy * exp(-(ys_rotate(row+pad, col+pad)^2 + xs_rotate(row+pad, col+pad)^2) / (60 * sigma_now));
            dx = dx * exp(-(ys_rotate(row+pad, col+pad)^2 + xs_rotate(row+pad, col+pad)^2) / (60 * sigma_now));
            angle = atan(dy / dx);
            if isnan(angle)
                angle = 0;
                dy = 0;
                dx = 0;
            end
            if angle < 0
                angle = angle + 2*pi;
            end
            if angle == 2*pi
                angle = 0;
            end
            angle = floor(angle / descriptor_angle_interval) + 1;
            magnitude = sqrt(dy^2 + dx^2);
            if mod(col, subpatch_size) ~= 0
                if mod(row, subpatch_size) ~= 0
                    seed_index = subpatch_sidelen * floor(row/subpatch_size) + floor(col/subpatch_size) + 1;
                else
                    seed_index = subpatch_sidelen * (floor(row/subpatch_size) - 1) + floor(col/subpatch_size) + 1;
                end
            else
                if mod(row, subpatch_size) ~= 0
                    seed_index = subpatch_sidelen * floor(row/subpatch_size) + floor(col/subpatch_size);
                else
                    seed_index = subpatch_sidelen * (floor(row/subpatch_size) - 1) + floor(col/subpatch_size);
                end
            end
            one_descriptor(seed_index, angle) = one_descriptor(seed_index, angle) + magnitude;
        end
    end
    one_descriptor = one_descriptor/sqrt(sum(sum(one_descriptor.^2)));
    for hist_idx = 1: size(one_descriptor, 1)
        one_descriptor(hist_idx, :) = smoothHistogram(one_descriptor(hist_idx, :), 1);
    end
    one_descriptor(one_descriptor > 0.2) = 0.2;
    keypoints(point, :) = [coordinates(point, 1: 2) * (2^(coordinates(point, 3) - 1 + octave_start)), main_angle, main_magnitude];
    one_descriptor = one_descriptor';
    one_descriptor = one_descriptor(:);
    one_descriptor = one_descriptor';
    descriptors(point, :)= one_descriptor;
end
end