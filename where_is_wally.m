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
template = im2double(imread('Wally.png'));

% Use Correlation to find where Wally is
[x, y, w, h] = correlation(image, template);

figure;
imshow(image);
rectangle('Position', [x, y, w, h], 'EdgeColor', 'r', 'LineWidth', 2);

% Use color segmentation to find where Wally is 
output = colorSegmentation(im2double(imread('WhereLarge.jpg')));
figure;
imshow(output);
end



% ------------------------
% Correlation Matching
% ------------------------
function [x, y, w, h] = correlation(image, template)

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

% Convert to HSV color space 
imageHsv = rgb2hsv(image);
h = imageHsv(:, :, 1);
s = imageHsv(:, :, 2);
v = imageHsv(:, :, 3);

% Segment using color
redStripes = ((h < 0.05) | (h > 0.95)) & (s > 0.5) & (v > 0.5);
whiteStripes = (s < 0.2) & (v > 0.8);

% Dilate the red stripe vertically 
se = strel('line', 11, 90);
redStripes = imdilate(redStripes, se);

roi = redStripes & whiteStripes;
roi = imdilate(roi, se);

roi = bwareaopen(roi, 50);





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



