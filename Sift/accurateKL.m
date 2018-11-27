%{
Author:
    Charles
Function:
    Accurate keypoint locatization.
Input:
    -EP_coordinates: the location information of detected extreme points.
    -DoG_images: DoG computed according to gaussian_pyramids.
    -max_iter: maximum number of iterations.
Output:
    -accurate_coordinates: accurate keypoint locatization.
%}
function accurate_coordinates = accurateKL(EP_coordinates, DoG_images, max_iter)
stable_thresh = 0.02;
edge_thresh = 10;
accurate_coordinates = [];
for point = 1: size(EP_coordinates, 1)
    coordinate = EP_coordinates(point, :);
    for iter = 1: max_iter
        dx = derivation(coordinate, [0, 1], DoG_images);
        dy = derivation(coordinate, [0, 2], DoG_images);
        dsigma = derivation(coordinate, [0, 3], DoG_images);
        one_order_derivative = [dx, dy, dsigma]';
        dxx = derivation(coordinate, [1, 1], DoG_images);
        dxy = derivation(coordinate, [1, 2], DoG_images);
        dxsigma = derivation(coordinate, [1, 3], DoG_images);
        dyy = derivation(coordinate, [2, 2], DoG_images);
        dysigma = derivation(coordinate, [2, 3], DoG_images);
        dsigmasigma = derivation(coordinate, [3, 3], DoG_images);
        two_order_derivative = [dxx, dxy, dxsigma; dxy, dyy, dysigma; dxsigma, dysigma, dsigmasigma];
        Hessian = [dxx, dxy; dxy, dyy];
        shift = [0, 0, 0]';
        if det(two_order_derivative) ~= 0
            shift = - two_order_derivative^(-1) * one_order_derivative;
        end
        D = DoG_images{coordinate(3)}{coordinate(4)}(coordinate(2), coordinate(1));
        D_hat = D + 0.5 * one_order_derivative' * shift;
        % for rejecting unstable extrema with low contrast
        if abs(D_hat) > stable_thresh
            DoG_image_size = size(DoG_images{coordinate(3)}{1});
            if max(shift) <= 0.5 && min(shift) >= -0.5
                coordinate(1) = coordinate(1) + shift(1);
                coordinate(2) = coordinate(2) + shift(2);
                coordinate(4) = coordinate(4) + shift(3);
                if (coordinate(1) > 1 && coordinate(1) < DoG_image_size(2)-1) && (coordinate(2) > 1 && coordinate(2) < DoG_image_size(1)-1)
                    % for eliminating edge responses
                    % if det(Hessian) > 0 && (trace(Hessian)^2) / det(Hessian) < (edge_thresh + 1)^2 / edge_thresh
                    if (trace(Hessian)^2) / det(Hessian) < (edge_thresh + 1)^2 / edge_thresh
                        accurate_coordinates = [accurate_coordinates; coordinate];
                    end
                end
                break
            else
                shift(shift >= -0.5 & shift <= 0.5) = 0;
                shift(shift > 0.5) = 1;
                shift(shift < -0.5) = -1;
                coordinate(1) = coordinate(1) + shift(1);
                coordinate(2) = coordinate(2) + shift(2);
                coordinate(4) = coordinate(4) + shift(3);
                if (coordinate(1) < 2 || coordinate(1) > DoG_image_size(2) - 1) || (coordinate(2) < 2 || coordinate(2) > DoG_image_size(1) - 1) || (coordinate(4) < 2 || coordinate(4) > size(DoG_images{1}, 2) - 1)
                    break
                end
            end
        end
    end
end
end