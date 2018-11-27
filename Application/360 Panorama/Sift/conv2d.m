%{
Author:
    Charles
Function:
    Compute the 2-D convolution of a image and a kernel.
Input:
    -image: the image need to be convolved.
    -kernel: 2-D convolution kernel(single channel).
Output:
    -I_conv: the image that has been convolved.
%}
function I_conv = conv2d(image, kernel)
image_size = size(image);
if length(image_size) == 2
    image_size = [image_size, 1];
end
kernel_size = size(kernel);
stride = 1;
pad_size = floor((image_size(1: 2) * (stride - 1) + (kernel_size - stride)) / 2);
ys = 1: 2*pad_size(1)+image_size(1);
xs = 1: 2*pad_size(2)+image_size(2);
ys(ys < pad_size(1)+1) = pad_size(1) + 1;
ys(ys > pad_size(1)+image_size(1)) = pad_size(1) + image_size(1);
xs(xs < pad_size(2)+1) = pad_size(2) + 1;
xs(xs > pad_size(2)+image_size(2)) = pad_size(2) + image_size(2);
image_padded = zeros([image_size(1: 2) + 2 * pad_size, image_size(3)]);
image_padded(pad_size(1)+1: pad_size(1)+image_size(1), pad_size(2)+1: pad_size(2)+image_size(2), :) = image;
image_padded = image_padded(ys, xs, :);
for i = 1: image_size(3)
    kernel_expand(:, :, i) = kernel;
end
I_conv = zeros(image_size);
for row = 1: stride: image_size(1)
    for col = 1: stride: image_size(2)
        patch = image_padded((row-1)*stride+1: (row-1)*stride+kernel_size(1), (col-1)*stride+1: (col-1)*stride+kernel_size(2), :);
        I_conv(row, col, :) = sum(sum(patch .* kernel_expand));
    end
end
end