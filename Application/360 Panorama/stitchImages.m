%{
Author:
    Charles
Function:
    Stitch image.
Input:
    -image_pre: the image that need to be stitched on the left.
    -image: the image need to be stitched on the right.
    -shift: the shift between 'image_pre' and 'image'.
Output:
    -stitch_image: the image that stitched based on 'image_pre' and 'image'.
%}
function stitch_image = stitchImages(image_pre, image, shift)
image_pre_size = size(image_pre);
image_size = size(image);
x_shift = round(shift(1));
if image_pre_size(2) - x_shift > 0
    x_shift = round(shift(1));
else
    x_shift = image_pre_size(2);
end
y_shift = round(shift(2));
stitch_image_w = image_pre_size(2) + image_size(2) - x_shift;
stitch_image_h = max(image_size(1) - min(0, y_shift), image_pre_size(1) + max(0, y_shift));
if length(image_pre_size) == 3
    stitch_image1 = zeros(stitch_image_h, stitch_image_w, 3);
else
    stitch_image1 = zeros(stitch_image_h, stitch_image_w);
end
stitch_image2 = stitch_image1;
x_range = 1: image_pre_size(2);
y_range = (1: image_pre_size(1)) + max(0, y_shift);
stitch_image1(y_range, x_range, :) = image_pre;
x_range = (1: image_size(2)) + image_pre_size(2) - x_shift;
y_range = (1: image_size(1)) - min(0, y_shift);
stitch_image2(y_range, x_range, :) = image;
weight1 = ones(size(stitch_image1));
weight2 = ones(size(stitch_image2));
overlap_weight = 1: x_shift;
overlap_weight = overlap_weight ./ x_shift;
overlap_weight = repmat(overlap_weight, stitch_image_h, 1, size(stitch_image1, 3));
overlap_collum = image_pre_size(2) - x_shift + 1: image_pre_size(2);
weight1(:, overlap_collum, :) = 1 - overlap_weight;
weight2(:, overlap_collum, :) = overlap_weight;
stitch_image = weight1 .* stitch_image1 + weight2 .* stitch_image2;
stitch_image = uint8(stitch_image);
end