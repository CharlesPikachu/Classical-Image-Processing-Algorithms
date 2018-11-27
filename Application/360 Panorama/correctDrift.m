%{
Author:
    Charles
Function:
    Correct for drift.
Input:
    -images_pro: projected image.
    -shifts: the shift between the neighbouring images.
Output:
    -shifts_correct: the corrected shift between the neighbouring images.
%}
function shifts_correct = correctDrift(images_pro, shifts)
image_pro_pre = images_pro{end};
image_pro = images_pro{1};
image_pro_pre_sift = Sift(image_pro_pre);
image_pro_sift = Sift(image_pro);
[matched_points, distances] = siftMacth(image_pro_pre_sift, image_pro_sift, 0);
[x_shift, y_shift] = ransacShift(matched_points, image_pro_pre_sift, image_pro_sift);
shifts_correct = shifts;
for shift_idx = size(shifts, 1)-1: -1: 1
    shift = shifts_correct(shift_idx+1, :);
    shift_adjust = [0, max(0, shift(2))];
    shifts_correct(shift_idx, :) = shifts(shift_idx, :) + shift_adjust;
end
drift = sum(shifts_correct(:, 2)) + y_shift;
shifts_correct(:, 2) = shifts(:, 2) + drift / length(images_pro);
end