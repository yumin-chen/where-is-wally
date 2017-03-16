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



% Read images
image = im2double(imread('Where.jpg'));
template = im2double(imread('Wally.png'));

[th, tw, ~] = size(template);

% Use Correlation to find where Wally is
[y, x] = correlation(image, template);

figure;
imshow(image);
rectangle('Position', [x, y, tw, th], 'EdgeColor', 'r', 'LineWidth', 2);

% Use color segmentation to find where Wally is 
output = colorSegmentation(image);
figure;
imshow(output);
end



% ------------------------
% Filter
% ------------------------
function output = filter(image, f)
[height, width, ~] = size(image);
output = image;
for x = 2:width - 1
    for y = 2: height - 1
        for i = 1:3
            % Dot multiply the "cookie" area by the filter matrix
            filteredArea = image(y-1:y+1, x-1:x+1, i) .* f;
            % Apply the sum to current position
            output(y, x, i) = sum(filteredArea(:));
        end
    end
end
end

% ------------------------
% Correlation
% ------------------------
function [i_row, i_col] = correlation(image, template)

imageGray = rgb2gray(image);
templateGray = rgb2gray(template);

[ih, iw] = size(imageGray);
[th, tw] = size(templateGray);

output = zeros(ih-th, iw-tw);

for i = 1:ih-th
    for j = 1:iw-tw
        neighbourhood = imageGray(i:i+th-1, j:j+tw-1);
        differences = abs(neighbourhood - templateGray);
        output(i, j) = sum(differences(:))/(th*tw);
        % Replace with actual correlation
        %Find the best match in Output (min sum of differences or max
        %correlation)
        % Make this more efficient by ending the loop once found
    end
end

%Using the 'rectangle' function, show where Wally is on the original image
[~, I] = min(output(:));
[i_row, i_col] = ind2sub(size(output), I);

end






% ------------------------
% Color Segmentation
% ------------------------
function output = colorSegmentation(image)

% Convert to HSV color space 
imageHsv = rgb2hsv(image);
th = imageHsv(:, :, 1);
s = imageHsv(:, :, 2);
v = imageHsv(:, :, 3);

roi = ((th < 0.075) | (th > 0.925)) & (v > 0.20) & (s < 0.9);

r = image(:, :, 1);
g = image(:, :, 2);
b = image(:, :, 3);

roi = bwareaopen(roi, 50);

output = image;
output(:, :, 1) = roi .* r;
output(:, :, 2) = roi .* g;
output(:, :, 3) = roi .* b;

%structElement = strel('square', 3);
%eroded = imerode(output, structElement);


% Apply the Gaussian filter
gauss = [-1 -2 -1;
         0 0 0;
         1 2 1]/4; % The Gaussian filter weighted sum matrix
output = filter(output, gauss);

end



