%{
Author:
    Charles
Function:
    Show images stored in variable<images>.
Input:
    -images: the images need to be showed.
Output:
    -handle: the figure handle.
    -array_showed: the showed array.
%}
function [handle, array_showed] = showImages(images)
colormap(gray);
[num_rows, num_cols] = size(images);
img_width = round(sqrt(num_cols));
img_height = (num_cols / img_width);
num_rows_show = floor(sqrt(num_rows));
num_cols_show = ceil(num_rows / num_rows_show);
pad = 1;
array_showed = -ones(pad + num_rows_show * (img_height + pad), ...
                     pad + num_cols_show * (img_width + pad));
current_img = 1;
for j = 1: num_rows_show
    for i = 1: num_cols_show
        if current_img > num_rows
            break;
        end
        max_value = max(abs(images(current_img, :)));
        array_showed(pad + (j - 1) * (img_height + pad) + (1: img_height), ...
                     pad + (i - 1) * (img_width + pad) + (1: img_width)) = ...
                     reshape(images(current_img, :), img_height, img_width) / max_value;
        current_img = current_img + 1;
    end
    if current_img > num_rows
        break
    end
end
handle = imagesc(array_showed, [-1 1]);
axis image off
drawnow;
end