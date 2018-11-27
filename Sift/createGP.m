%{
Author:
    Charles
Function:
    Create gaussian pyramids.
Input:
    -image: the image to be processed.
    -num_sublevels: the number of layers in each octave.
    -num_octaves: the number of octaves.
    -sigma: the standard devation of the first layer in the first octave.
    -octave_start: decide up/downsampling the image of the first layer in the first octave.
Output:
    -gaussian_pyramids: the created gaussian pyramids.
%}
function gaussian_pyramids = createGP(image, num_sublevels, num_octaves, sigma, octave_start)
if numel(size(image)) == 3
    I_gray = rgb2gray(image);
else
    I_gray = image;
end
gaussian_pyramids = {};
I_gray_size = size(I_gray);
I_now = imresize(I_gray, floor(I_gray_size*2^-octave_start));
for octave = 0: num_octaves - 1
    octave_images = {};
    for sublevel = 0: num_sublevels - 1 + 3
        fprintf('[INFO]: Computing %d/%d gaussian blur in octave %d/%d...\n', sublevel+1, num_sublevels+3, octave+1, num_octaves);
        kernel = getGK(sigma * 2^(sublevel/num_sublevels) * 2^octave);
        I_conv = conv2d(I_now, kernel);
        octave_images = [octave_images, {I_conv}];
    end
    gaussian_pyramids = [gaussian_pyramids, {octave_images}];
    I_downsampling = octave_images{num_sublevels-2};
    I_downsampling_size = size(I_downsampling);
    I_now = imresize(I_downsampling, floor(I_downsampling_size/2));
end
end