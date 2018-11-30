%{
Author:
    Charles
Function:
    The main function of <Face Recognition via Eigenface>.
%}
%{
Step1:
    Preprocessing.
%}
clear;
close all;
addpath('./utils');
OUTPATH = './results/';
TRAINDATA = 'smiling';
TESTDATA = 'smiling';
FACESIZE = [50, 50];
FACESPATH = ['./class_images/' TRAINDATA '_cropped/'];
PEOPLEPATH = ['./class_images/group/' TESTDATA '/'];
faces_matrix = faces2matrix(FACESPATH, FACESIZE);
[handle, faces_showed_ori] = showImages(faces_matrix);
if ~ exist([OUTPATH TRAINDATA])
    mkdir([OUTPATH TRAINDATA]);
end
imwrite(faces_showed_ori, [OUTPATH TRAINDATA '/origin_face.jpg']);
[faces_matrix_center, faces_matrix_mu] = centerlizeData(faces_matrix);
%{
Step2:
    PCA to compute eigenface, show eigenface images.
%}
[eigenfaces, ~, engivalue] = pca(faces_matrix_center);
[~, faces_showed_eigen] = showImages(abs(eigenfaces)');
imwrite(faces_showed_eigen, [OUTPATH TRAINDATA '/eigenfaces.jpg']);
%{
Step3:
    Project a face image into the face space, show the reconstructed face.
%}
faces_project = faces_matrix_center * eigenfaces;
faces_rec = faces_project * eigenfaces';
faces_rec = bsxfun(@plus, faces_rec, faces_matrix_mu);
[~, faces_showed_rec] = showImages(faces_rec);
imwrite(faces_showed_rec, [OUTPATH TRAINDATA '/reconstructedfaces.jpg']);
%{
Step4:
    Face Detection: finding the size and position of a face in an image
%}
image_names = dir([PEOPLEPATH, '*tga']);
for img_idx = 1: length(image_names)
    fprintf('[INFO]: Start to process %dth images...\n', img_idx);
    image_path = [PEOPLEPATH image_names(img_idx).name];
    image = readTgaImage(image_path);
    [face_coordinates, dists_det, dists_rec] = detector(image, faces_matrix, eigenfaces, FACESIZE);
    imwrite(image, [OUTPATH TRAINDATA '/' num2str(img_idx) '.jpg']);
    save([OUTPATH TRAINDATA '/' num2str(img_idx) '_face_coordinates.mat'], 'face_coordinates');
    save([OUTPATH TRAINDATA '/' num2str(img_idx) '_dists_det.mat'], 'dists_det');
    save([OUTPATH TRAINDATA '/' num2str(img_idx) '_dists_rec.mat'], 'dists_rec');
end