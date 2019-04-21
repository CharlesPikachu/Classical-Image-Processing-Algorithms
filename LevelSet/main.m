%{
Function:
        图像分割
Author:
         Zhenchao Jin
%}
% 初始化
clear;
close all;
clc;
addpath ./CV_code_Sample

%读入测试图像
% img=imread('CV_code_Sample/three.bmp'); 
img = imread('CV_code_Sample/twocells.bmp'); 
img=imread('CV_code_Sample/vessel.bmp'); 

%预处理
U = img(:, :, 1);
I = double(U);
[nrow, ncol]  = size(U);
c0 = 3;
initialLSF = c0 * ones(size(U));
initialLSF(5: nrow-5, 5: ncol-5) = -c0;  
phi_0 = initialLSF;
figure; mesh(phi_0); title('Signed Distance Function')

% 一些超参数
delta_t = 5;
mu = 0.2 / delta_t;
nu = 1.5;
lambda = 5; 
epsilon = 1.5;
sigma = 1.5;

%边缘检测及其梯度
g = edgeDetector(I, sigma);
[gx, gy] = gradient(g);

% 开始迭代
phi = phi_0;
figure(2);
imagesc(uint8(I)); colormap(gray)
hold on;
plotLevelSet(phi, 0, 'r');
numIter = 1;
for k=1:240,
    phi = evolutionCV(I, phi,g,gx, gy, mu, nu, lambda, delta_t, epsilon, numIter);
    if mod(k,4)==0
        pause(0.05);
        figure(2);
        imagesc(uint8(I));colormap(gray)
        hold on;
        plotLevelSet(phi,0,'r');
    end    
end;