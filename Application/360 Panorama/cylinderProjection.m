%{
Author:
    Charles
Function:
    Project an image to cylinder surface.
Input:
    -image_path: the image path.
    -rotate_angle: rotate the original image rotate_angle degrees.
    -Wccd: hyperparameter.
Output:
    -image_ori: original image.
    -image_pro: projected image.
%}
function [image_ori, image_pro] = cylinderProjection(image_path, rotate_angle, Wccd)
image_ori = imread(image_path);
image_ori = imrotate(image_ori, rotate_angle);
image_ori_size = size(image_ori);
image_ori_h = image_ori_size(1);
image_ori_w = image_ori_size(2);
pad = 2;
if length(size(image_ori)) == 3
    image_pad = zeros(image_ori_h + 2 * pad, image_ori_w + 2 * pad, 3);
else
    image_pad = zeros(image_ori_h + 2 * pad, image_ori_w + 2 * pad);
end
image_pad(pad+1: pad+image_ori_h, pad+1: pad+image_ori_w, :) = image_ori;
image_info = imfinfo(image_path);
image_focal_length = image_info.DigitalCamera.FocalLength;
cylinder_r = image_ori_h * image_focal_length / Wccd;
theta = 2 * atan(image_ori_w / (2 * cylinder_r));
image_pro_w = round(2 * cylinder_r * sin(theta/2));
image_pro_h = image_ori_h;
if length(size(image_ori)) == 3
    image_pro = zeros([image_pro_h, image_pro_w, 3]);
else
    image_pro = zeros([image_pro_h, image_pro_w]);
end
for col = 1: image_pro_w
    for row = 1: image_pro_h
        x = image_ori_w/2 + cylinder_r * tan(asin((col - cylinder_r * sin(theta/2)) / cylinder_r));
        y = image_ori_h/2 + (row - image_ori_h/2) * sqrt(cylinder_r^2 + (image_ori_w/2 - x)^2) / cylinder_r;
        if x >= 0 && x <= image_ori_w + 1 && y >= 0 && y <= image_ori_h + 1
            if mod(x, 1) == 0 || mod(y, 1) == 0
                if mod(x,1) == 0 && mod(y,1) == 0
                    image_pro(row, collum, :) = image_pad(y, x, :);
                elseif mod(x,1) == 0 && mod(y,1) ~= 0
                    y1 = floor(y);
                    y2 = ceil(y);
                    pixel1 = image_pad(y1+pad, x+pad, :) * (y2-y) / (y2-y1);
                    pixel2 = image_pad(y2+pad, x+pad, :) * (y-y1) / (y2-y1);
                    image_pro(row, col, :) = pixel1 + pixel2;
                elseif mod(x,1) ~= 0 && mod(y,1) == 0
                    x1 = floor(x);
                    x2 = ceil(x);
                    pixel1 = image_pad(y+pad, x1+pad, :) * (x2-x) / (x2-x1);
                    pixel2 = image_pad(y+pad, x2+pad, :) * (x-x1) / (x2-x1);
                    image_pro(row, col, :) = pixel1 + pixel2;
                end
            else
                x1 = floor(x);
                x2 = ceil(x);
                y1 = floor(y);
                y2 = ceil(y);
                pixel11 = image_pad(y1+pad, x1+pad, :) * ((x2-x) * (y2-y)) / ((x2-x1) * (y2-y1));
                pixel21 = image_pad(y1+pad, x2+pad, :) * ((x-x1) * (y2-y)) / ((x2-x1) * (y2-y1));
                pixel12 = image_pad(y2+pad, x1+pad, :) * ((x2-x) * (y-y1)) / ((x2-x1) * (y2-y1));
                pixel22 = image_pad(y2+pad, x2+pad, :) * ((x-x1) * (y-y1)) / ((x2-x1) * (y2-y1));
                image_pro(row, col, :) = pixel11 + pixel21 + pixel12 + pixel22;
            end
        end
    end
end
image_pro = uint8(image_pro);
end