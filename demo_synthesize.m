% =======================================================================
% ====================== 'demo_syntesize.m'==============================
% You can see the difference between two composite models.
% Rain noise parametters are randomly adjusted.
% =======================================================================

%% Input image
clean_image = im2single(imread('image/synthetic/1original.jpg'));

%% Synthetic rainy image
% Output random rain noise
rain_noise = output_rain_noise(clean_image); 

% Linear additive composite model
rainy_image_add = clean_image + rain_noise;
% Screen blen composite model
rainy_image_blend = 1 - (1 - clean_image) .* (1 - rain_noise);

%% Show results
set(figure(1), 'Name', 'Comparison of rain composite model');
imshow([clean_image, rainy_image_add, rainy_image_blend]);
title('Clean image                  Linear additive model                  Screen blend model');