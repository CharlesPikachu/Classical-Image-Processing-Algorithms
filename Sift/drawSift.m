%{
Author:
    Charles
Function:
    Draw the results of sift.
Input:
    -image: the original image.
    -keypoints: the keypoints.
    -keypoint_angle_interval: the interval to divide 2*pi, which is used to compute the main angle of keypoints.
    -show_sift_type: how to show the keypoints.
Output:
    None.
%}
function drawSift(image, keypoints, keypoint_angle_interval, show_sift_type)
figure();
imshow(image);
for point =1:size(keypoints, 1)
    hold all;
    keypoint = keypoints(point, :);
    if strcmp(show_sift_type, 'arrow')
        angle = keypoint(3) * keypoint_angle_interval;
        dx = keypoint(4) * cos(angle) / 20;
        dy = keypoint(4) * sin(angle) / 20;
        end_x = keypoint(1) + round(dx);
        end_y = keypoint(2) + round(dy);
        plot([keypoint(1), end_x], [keypoint(2), end_y], 'Color', 'cyan', 'LineWidth', 2);
        angle1 = pi + angle - pi/6;
        angle2 = pi + angle + pi/6;
        arrow_edge_len = 6;
        arrow_point1_x = end_x + arrow_edge_len * cos(angle1);
        arrow_point1_y = end_y + arrow_edge_len * sin(angle1);
        arrow_point2_x = end_x + arrow_edge_len * cos(angle2);
        arrow_point2_y = end_y + arrow_edge_len * sin(angle2);
        plot([arrow_point1_x, end_x], [arrow_point1_y, end_y], 'Color', 'cyan', 'LineWidth', 2);
        plot([arrow_point2_x, end_x], [arrow_point2_y, end_y], 'Color', 'cyan', 'LineWidth', 2);
    else
        plot(round(keypoint(1)), round(keypoint(2)), show_sift_type, 'Color', 'Cyan', 'markersize', 6);
    end
end