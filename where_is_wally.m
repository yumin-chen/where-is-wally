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
% This is a hack that allows function definition in a script

% Clear and clean enviroment
clc;        % Clear command line
clear all;  % Clear all variables
close all;  % Close all sub-windows


% Read images
image = im2double(imread('Where.jpg'));
imageLarge = im2double(imread('WhereLarge.jpg'));
template = im2double(imread('Wally.png'));

% Get image size
[ih, iw, ~] = size(image);
[ilh, ilw, ~] = size(imageLarge);
r = ilw / iw;

% Use Correlation to find where Wally is
[x, y, w, h] = correlation(image, template);
figure, imshow(image), title('Correlation Matching');
rectangle('Position', [x, y, w, h], 'EdgeColor', 'r', 'LineWidth', 2);

% Use color segmentation to find where Wally is 
output = colorSegmentation(imageLarge);
figure; imshow(output), title('Color Segmentation');
rectangle('Position', [x*r, y*r, w*r, h*r], 'EdgeColor', 'r', 'LineWidth', 2);
end



% ------------------------
% Correlation Matching
% ------------------------
function [x, y, w, h] = correlation(image, template)
% This function uses correlation matching to find Wally's position. 
% It returns the x, y coordinates of the found object, and its width and
% height.

imageGray = rgb2gray(image);
templateGray = rgb2gray(template);

[ih, iw] = size(imageGray);
[h, w] = size(templateGray);

% Use a 2-dimensional array to record the difference of each position
diffs = zeros(ih-h, iw-w);

for i = 1:ih-h
    for j = 1:iw-w
        neighborhood = imageGray(i:i+h-1, j:j+w-1);
        difference = abs(neighborhood - templateGray);
        diffs(i, j) = sum(difference(:)) / (w*h);
        
        % If difference nearly zero, this is the exact match
        if diffs(i, j) < 0.001
            y = i;
            x = j;
            % Return the position found to improve efficiency
            fprintf('An exact match is found. Return.')
            return;
        end
    end
end

% Find the minimum difference value and its position
[~, i] = min(diffs(:));
[y, x] = ind2sub(size(diffs), i);

end



% ------------------------
% Color Segmentation
% ------------------------
function output = colorSegmentation(image)
% This function uses color segmentation to find Wally's position. It first
% converts the image to HSV color space and use the Hue and Saturation to
% segment the red and write stripes. Then a vertical linear structruring
% element is used to dilate the stripes and find their overlapped area so
% the result will be only connected red and white area.

[ih, iw, ~] = size(image);

% Convert to HSV color space 
imageHsv = rgb2hsv(image);
h = imageHsv(:, :, 1);
s = imageHsv(:, :, 2);
v = imageHsv(:, :, 3);

% Segment using color
redStripes = ((h < 0.05) | (h > 0.95)) & (s > 0.4) & (v > 0.4);
whiteStripes = (s < 0.2) & (v > 0.9);

% Create vertical (90 degree) linear structuring element
se = strel('line', ih * 0.01, 90); 

% Dilate the stripes vertically 
redDilated = imdilate(redStripes, se);
whiteDilated = imdilate(whiteStripes, se);

% Get their overlapped area
roi = redDilated & whiteDilated;

% Remove smaller or bigger components that are not Wally
roi = bwareaopen(roi, floor((iw/108) * (ih/108)));
bigger = bwareaopen(roi, floor((iw/50) * (ih/50)));
roi = roi - bigger;

% Purify Wally
roi = roi & (redStripes | whiteStripes);
roi = imdilate(roi, se);
roi = bwareaopen(roi, 10);

% Restore to RGB colored image
r = image(:, :, 1);
g = image(:, :, 2);
b = image(:, :, 3);

output = image;
output(:, :, 1) = roi .* r;
output(:, :, 2) = roi .* g;
output(:, :, 3) = roi .* b;

%structElement = strel('square', 3);
%eroded = imerode(output, structElement);

%output = imfilter(output, fspecial('prewitt'), 'replicate');

end



