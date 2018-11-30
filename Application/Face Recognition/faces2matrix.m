%{
Author:
    Charles
Function:
    Organizes faces into a matrix.
Input:
    -FACESPATH: the path of the data of faces.
    -FACESIZE: all face images will be resized to FACESIZE.
Output:
    -faces_matrix: the matrix of faces. Each row contains the data of a face.
%}
function faces_matrix = faces2matrix(FACESPATH, FACESIZE)
faces_matrix = [];
face_names = dir([FACESPATH, '*tga']);
num_faces = length(face_names);
faces_matrix_tmp = zeros(num_faces, FACESIZE(1)*FACESIZE(2));
for i = 1: num_faces
    face_path = [FACESPATH face_names(i).name];
    face_data = readTgaImage(face_path);
    face_data = rgb2gray(face_data);
    face_data = imresize(face_data, FACESIZE);
    faces_matrix_tmp(i, :) = face_data(:)';
end
faces_matrix = [faces_matrix; faces_matrix_tmp];
end