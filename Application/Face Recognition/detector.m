%{
Author:
    Charles
Function:
    Detect and recognize faces in a image.
Input:
    -image: the image need to be detected.
    -faces_matrix: the face dataset.
    -eigenfaces: the eigenface of 'dataset' obtained by PCA.
    -FACESIZE: all roi will be resize to FACESIZE.
Output:
    -face_coordinates: the coordinate and size of a detected face.
    -dist_det: the distance between the croped roi and its reconstruct 'face'.
    -dist_rec: the matched face in the dataset and the corresponding distance.
%}
function [face_coordinates, dists_det, dists_rec] = detector(image, faces_matrix, eigenfaces, FACESIZE)
face_coordinates = [];
dists_det = [];
dists_rec = [];
search_window_init = [35, 35];
step_size = 5;
stride = 4;
thresh_det = 0.24;
thresh_rec = 0.21;
[faces_matrix_center, faces_matrix_mu] = centerlizeData(faces_matrix);
faces_matrix_reconstruct = faces_matrix_center * eigenfaces * eigenfaces';
if length(size(image)) == 3
    image = rgb2gray(image);
end
image = double(image);
image_size = size(image);
for i = 1: 7
    search_window = search_window_init + (i - 1) * [step_size step_size];
    fprintf('  Search window size: [%d, %d]\n', search_window(1), search_window(2));
    x = 1;
    while x + search_window(1) - 1 < image_size(2)
        y = 1;
        while y + search_window(2) - 1 < image_size(1)
            x_range = x: x+search_window(1) - 1;
            y_range = y: y+search_window(2) - 1;
            roi_origin = image(y_range, x_range);
            roi_resize = imresize(roi_origin, FACESIZE);
            roi_vector = roi_resize(:)';
            roi_center = bsxfun(@minus, roi_vector, faces_matrix_mu);
            roi_project = roi_center * eigenfaces;
            roi_reconstruct = roi_project * eigenfaces';
            dist_det = sum(abs(roi_reconstruct - roi_center)) / sum(roi_vector);
            if dist_det < thresh_det
                dist_rec = bsxfun(@minus, faces_matrix_reconstruct, roi_reconstruct);
                dist_rec = sum(abs(dist_rec), 2) / sum(roi_vector);
                [dist_rec, dist_rec_idx] = sort(dist_rec);
                if dist_rec(1) < thresh_rec
                    face_coordinate = [x_range(1), y_range(1), search_window(1), search_window(2)];
                    face_coordinates = [face_coordinates; face_coordinate];
                    dists_det = [dists_det; dist_det];
                    dists_rec = [dists_rec; [dist_rec_idx(1), dist_rec(1)]];
                end
            end
            y = y + stride;
        end
        x = x + stride;
    end
end
[~, index] = sort(dists_det);
dists_rec = dists_rec(index, :);
dists_det = dists_det(index, :);
face_coordinates = face_coordinates(index, :);
end