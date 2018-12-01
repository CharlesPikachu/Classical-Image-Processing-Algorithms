%{
Author:
    Charles
Function:
    Choose one of the rois that matched to the same face according to their match distance.
Input:
    -face_coordinates: unfiltered face_coordinates.
    -dists_det: unfiltered dists_det.
    -dists_rec: unfiltered dists_rec.
Output:
    -face_coordinates: filtered face_coordinates.
    -dists_det: filtered dists_det.
    -dists_rec: filtered dists_rec.
%}
function [face_coordinates_new, dists_det_new, dists_rec_new] = filterFace(face_coordinates, dists_det, dists_rec)
face_coordinates_new = [];
dists_det_new = [];
dists_rec_new = [];
reco_labels = unique(dists_rec(:, 1));
for i = 1: length(reco_labels)
    index = find(dists_rec(:, 1) == reco_labels(i)); 
    face_coordinate = face_coordinates(index, :);
    dist_det = dists_det(index, :);
    dist_rec = dists_rec(index, 2);
    dist_rec2 = dists_rec(index, :);
    index = find(dist_rec == min(dist_rec));
    face_coordinates_new = [face_coordinates_new; face_coordinate(index, :)];
    dists_det_new = [dists_det_new; dist_det(index, :)];
    dists_rec_new = [dists_rec_new; dist_rec2(index, :)];
end
[~, index] = sort(dists_rec_new(:, 2));
face_coordinates_new = face_coordinates_new(index, :);
dists_det_new = dists_det_new(index, :);
dists_rec_new = dists_rec_new(index, :);
end