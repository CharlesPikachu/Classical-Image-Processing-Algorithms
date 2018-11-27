%{
Author:
    Charles
Function:
    Detect extreme point in DoG_images.
Input:
    -DoG_images: DoG computed according to gaussian_pyramids.
    -num_sublevels: the number of layers in each octave.
    -num_octaves: the number of octaves.
    -thresh: for threshold suppression.
Output:
    -EP_coordinates: the location information of detected extreme points.
%}
function EP_coordinates = detectEP(DoG_images, num_sublevels, num_octaves, thresh)
EP_coordinates = [];
for octave = 1: num_octaves
    fprintf('[INFO]: Detecting extreme points in %d/%d octave...\n', octave, num_octaves);
    for sublevel = 1 + 1: num_sublevels + 2 - 1
        image_size = size(DoG_images{octave}{sublevel});
        for row = 1 + 1: image_size(1) - 1
            for col = 1 + 1: image_size(2) - 1
                cubic = zeros([3, 3, 3]);
                cubic(:, :, 1) = DoG_images{octave}{sublevel-1}(row-1: row+1, col-1: col+1);
                cubic(:, :, 2) = DoG_images{octave}{sublevel}(row-1: row+1, col-1: col+1);
                cubic(:, :, 3) = DoG_images{octave}{sublevel+1}(row-1:row+1, col-1:col+1);
                if max(max(max(cubic))) == cubic(2, 2, 2) || min(min(min(cubic))) == cubic(2, 2, 2)
                    if abs(cubic(2, 2, 2)) > 0.5 * thresh / sublevel
                        extreme_point = [col, row, octave, sublevel];
                        EP_coordinates = [EP_coordinates; extreme_point];
                    end
                end
            end
        end
    end
end
end