%{
Author:
    Charles
Function:
    Show the results of face detection and recognition.
%}
close all;
clear;
OUTPATH = './results/';
TRAINDATA = 'nonsmiling';
addpath('./utils');
iou_thresh = 0.5;
num = 7;
for img_idx = 1: num
    img_path = [OUTPATH TRAINDATA '/' num2str(img_idx) '.jpg'];
    img = imread(img_path);
    figure();
    imshow(img);
    load([OUTPATH TRAINDATA '/' num2str(img_idx) '_face_coordinates.mat']);
    load([OUTPATH TRAINDATA '/' num2str(img_idx) '_dists_det.mat']);
    load([OUTPATH TRAINDATA '/' num2str(img_idx) '_dists_rec.mat']);
    [face_coordinates, dists_det, dists_rec] = filterFace(face_coordinates, dists_det, dists_rec);
    coordinates = {};
    count = 0;
    for i = 1: size(face_coordinates, 1)
        hold on;
        color = 'green';
        if isempty(coordinates)
            rectangle('Position', face_coordinates(i, :), 'edgecolor', color);
            text(face_coordinates(i, 1) - 5, face_coordinates(i, 2) - 5, num2str(dists_rec(i, 1)), 'color', color);
            coordinates = [coordinates, face_coordinates(i, :)];
            count = count + 1;
        else
            flag = true;
            for j = 1: length(coordinates)
                if bboxIoU(coordinates{j}, face_coordinates(i, :)) > iou_thresh
                    flag = false;
                    break
                end
            end
            if flag
                rectangle('Position', face_coordinates(i, :), 'edgecolor', color);
                text(face_coordinates(i, 1) - 5, face_coordinates(i, 2) - 5, num2str(dists_rec(i, 1)), 'color', color);
                coordinates = [coordinates, face_coordinates(i, :)];
                count = count + 1;
            end
        end
        if count == 3
            break
        end
    end
end