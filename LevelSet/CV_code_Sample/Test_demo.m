%   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
%   This method works well for bimodal images, for example the image 'three.bmp'


clear;
close all;
clc;

Img=imread('three.bmp');     % example that CV model works well
% Img=imread('vessel.bmp');    % example that CV model does NOT work well
% Img=imread('twoCells.bmp');  % example that CV model does NOT work well
U=Img(:,:,1);

% get the size
[nrow,ncol] =size(U);

ic=nrow/2;
jc=ncol/2;
r=20;
phi_0 = sdf2circle(nrow,ncol,ic,jc,r);
figure; mesh(phi_0); title('Signed Distance Function')

delta_t = 0.1;
lambda_1=1;
lambda_2=1;
nu=0;
h = 1;
epsilon=1;
mu = 0.01*255*255;

I=double(U);
% iteration should begin from here
phi=phi_0;
figure(2);
imagesc(uint8(I));colormap(gray)
hold on;
plotLevelSet(phi,0,'r');

numIter = 1;
for k=1:50,
    phi = evolution_cv(I, phi, mu, nu, lambda_1, lambda_2, delta_t, epsilon, numIter);   % update level set function
    if mod(k,2)==0
        pause(.5);
        title(sprintf('Itertion times: %d', k));
        imagesc(uint8(I));colormap(gray)
        figure(2); hold on;
        plotLevelSet(phi,0,'r');
    end    
end;
