%{
Author:
    Charles
Function:
    Calculate the one order or second partial derivative.
Input:
    -coordinate: the location information of detected extreme points,
                 [col, row, octave, sublevel].
    -arguments: [0 1/2/3] -> calculate dx/dy/dsigma
                [1 1/2/3] -> calculate dxx/dxy/dxsigma
                [2 2/3] -> calculate dyy/dysigma
                [3 3] -> calculate dsigmasigma
    -images: DoG computed according to gaussian_pyramids.
Output:
    -derivative: the one order or second partial derivative.
%}
function derivative = derivation(coordinate, arguments, images)
first_derivative_scale = 1;
second_derivative_scale = 1;
cross_derivative_scale = 1;
switch arguments(1)
    case 0
        switch arguments(2)
            case 1
                image_DoG = images{coordinate(3)}{coordinate(4)};
                derivative = (image_DoG(coordinate(2), coordinate(1)+1) - image_DoG(coordinate(2), coordinate(1)-1)) / 2;
                derivative = derivative * first_derivative_scale;
            case 2
                image_DoG = images{coordinate(3)}{coordinate(4)};
                derivative = (image_DoG(coordinate(2)+1, coordinate(1)) - image_DoG(coordinate(2)-1, coordinate(1))) / 2;
                derivative = derivative * first_derivative_scale;
            case 3
                image_DoG_pre = images{coordinate(3)}{coordinate(4) - 1};
                image_DoG_next = images{coordinate(3)}{coordinate(4) + 1};
                derivative = (image_DoG_next(coordinate(2), coordinate(1)) - image_DoG_pre(coordinate(2), coordinate(1))) / 2;
                derivative = derivative * first_derivative_scale;
            otherwise
                error('Illegal input for <derivation>...');
        end
    case 1
        switch arguments(2)
            case 1
                image_DoG = images{coordinate(3)}{coordinate(4)};
                derivative = image_DoG(coordinate(2), coordinate(1)+1) + image_DoG(coordinate(2), coordinate(1)-1) - 2 * image_DoG(coordinate(2), coordinate(1));
                derivative = derivative * second_derivative_scale;
            case 2
                image_DoG = images{coordinate(3)}{coordinate(4)};
                derivative = (image_DoG(coordinate(2)+1, coordinate(1)+1) + image_DoG(coordinate(2)-1, coordinate(1)-1) - image_DoG(coordinate(2)-1, coordinate(1)+1) - image_DoG(coordinate(2)+1, coordinate(1)-1)) / 4;
                derivative = derivative * cross_derivative_scale;
            case 3
                image_DoG_pre = images{coordinate(3)}{coordinate(4) - 1};
                image_DoG_next = images{coordinate(3)}{coordinate(4) + 1};
                derivative = (image_DoG_next(coordinate(2), coordinate(1)+1) + image_DoG_pre(coordinate(2), coordinate(1)-1) - image_DoG_next(coordinate(2), coordinate(1)-1) - image_DoG_pre(coordinate(2), coordinate(1)+1)) / 4;
                derivative = derivative * cross_derivative_scale;
            otherwise
                error('Illegal input for <derivation>...');
        end
    case 2
        switch arguments(2)
            case 2
                image_DoG = images{coordinate(3)}{coordinate(4)};
                derivative = image_DoG(coordinate(2)+1, coordinate(1)) + image_DoG(coordinate(2)-1, coordinate(1)) - 2 * image_DoG(coordinate(2), coordinate(1));
                derivative = derivative * second_derivative_scale;
            case 3
                image_DoG_pre = images{coordinate(3)}{coordinate(4) - 1};
                image_DoG_next = images{coordinate(3)}{coordinate(4) + 1};
                derivative = (image_DoG_next(coordinate(2)+1, coordinate(1)) + image_DoG_pre(coordinate(2)-1, coordinate(1)) - image_DoG_next(coordinate(2)-1, coordinate(1)) - image_DoG_pre(coordinate(2)+1, coordinate(1))) / 4;
                derivative = derivative * cross_derivative_scale;
            otherwise
                error('Illegal input for <derivation>...');
        end
    case 3
        switch arguments(2)
            case 3
                image_DoG_pre = images{coordinate(3)}{coordinate(4) - 1};
                image_DoG_next = images{coordinate(3)}{coordinate(4) + 1};
                image_DoG = images{coordinate(3)}{coordinate(4)};
                derivative = image_DoG_pre(coordinate(2), coordinate(1)) + image_DoG_next(coordinate(2), coordinate(1)) - 2 * image_DoG(coordinate(2), coordinate(1));
                derivative = derivative * second_derivative_scale;
            otherwise
                error('Illegal input for <derivation>...');
        end
    otherwise
        error('Illegal input for <derivation>...');
end
end