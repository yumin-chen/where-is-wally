%-------------------------------------------------------------------------
% ========================
% Where's Wally
% ========================
%
% Copyright (C): Yumin Chen  D16123341
%
% 04/Mar/2017
%
% Introduction
% ------------------------
% This is an assignment from Image Processing module. The purpose of this
% program is to find a desired object from an image. In this example, the
% cartoon character Wally is our desired object. 
% -------------------------------------------------------------------------

function where_is_wally
% This is a hack that allows function definition in a script, this is used
% so the code could be used for different images 

% Clear and clean enviroment
clc;        % Clear command line
clear all;  % Clear all variables
close all;  % Close all sub-windows

% Read image
image = im2double(imread('Where.jpg'));
%image = im2double(imread('Wally.png'));
grayImage = rgb2gray(image); 

% Convert to HSV color space 
imageHsv = rgb2hsv(image);
h = imageHsv(:, :, 1);
s = imageHsv(:, :, 2);
v = imageHsv(:, :, 3);

roi = ((h < 0.075) | (h > 0.940)) & (v > 0.20) & (s < 0.9);

r = image(:, :, 1);
g = image(:, :, 2);
b = image(:, :, 3);

output = image;
output(:, :, 1) = roi .* r;
output(:, :, 2) = roi .* g;
output(:, :, 3) = roi .* b;


figure;
imshow(output);
figure;

end


