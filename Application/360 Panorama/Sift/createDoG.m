%{
Author:
    Charles
Function:
    Create DOG(Difference of Gaussian).
Input:
    -gaussian_pyramids: the created gaussian pyramids.
    -num_sublevels: the number of layers in each octave.
    -num_octaves: the number of octaves.
Output:
    -DoG_images: DoG computed according to gaussian_pyramids.
%}
function DoG_images = createDoG(gaussian_pyramids, num_sublevels, num_octaves)
DoG_images = {};
for octave = 1: num_octaves
    octave_images = gaussian_pyramids{octave};
    octave_DoGs = {};
    for sublevel = 1: num_sublevels+2
        fprintf('[INFO]: Computing %d/%d DoG image in octave %d/%d...\n', sublevel, num_sublevels+2, octave, num_octaves);
        I_diff = octave_images{sublevel+1} - octave_images{sublevel};
        octave_DoGs = [octave_DoGs, {I_diff}];
    end
    DoG_images = [DoG_images, {octave_DoGs}];
end
end