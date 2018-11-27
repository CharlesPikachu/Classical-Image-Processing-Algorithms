%{
Author:
    Charles
Function:
    Match two images based on sift features.
Input:
    -image1: one of the images.
    -image2: one of the images.
    -show_result: whether show the matched results or not.
Output:
    -matched_points: matched keypoints.
    -distances: the distance of matched keypoints.
%}
function [matched_points, distances] = siftMacth(image1, image2, show_result)
num_points1 = size(image1.descriptors, 1);
num_points2 = size(image2.descriptors, 1);
distances = [];
matched_points = [];
for i = 1: num_points1
    descriptor_1 = image1.descriptors(i, :);
    distance = repmat(descriptor_1, num_points2, 1) - image2.descriptors;
    distance = sqrt(sum(distance.^2, 2));
    [distance_sort, index] = sort(distance');
    if distance_sort(1) / distance_sort(2) < 0.64
        matched_points = [matched_points; [i, index(1)]];
        distances = [distances; distance_sort(1)];
    end
end
if show_result
    image1_size = size(image1.image);
    image2_size = size(image2.image);
    if length(image2_size) == 3
        image_stitch = zeros([max(image1_size(1), image2_size(1)), image1_size(2)+image2_size(2), 3]);
        image_stitch(1: image1_size(1), 1: image1_size(2), :) = image1.image;
        image_stitch(1: image2_size(1), image1_size(2)+1: image1_size(2)+image2_size(2), :) = image2.image;
    else
        image_stitch = zeros([max(image1_size(1), image2_size(1)), image1_size(2)+image2_size(2)]);
        image_stitch(1: image1_size(1), 1: image1_size(2)) = image1.image;
        image_stitch(1: image2_size(1), image1_size(2)+1: image1_size(2)+image2_size(2)) = image2.image;
    end
    figure();
    imshow(uint8(image_stitch));
    for i = 1: size(matched_points, 1)
        hold all;
        point1_coordinate = image1.keypoints(matched_points(i, 1), 1: 2);
        point2_coordinate = image2.keypoints(matched_points(i, 2), 1: 2) + [image1_size(2) 0];
        color = rand(1, 3);
        plot([point1_coordinate(1), point2_coordinate(1)],[point1_coordinate(2), point2_coordinate(2)], 'Color', color);
    end
end
end