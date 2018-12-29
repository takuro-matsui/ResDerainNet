function rain_noise = output_rain_noise(image, rain_number)
% =========================================================
% Rain noise size of input image is generated.
% 1st integerÅFclean image
% 2nd integerÅFrain number (1 to 14)
% If no 2nd integer is input, random noise is generated.
% =========================================================

if nargin == 0 % sample implementation
    sample_generate_rain;
    rain_noise = [];
    return;
end

if nargin == 1 || isempty(rain_number) % random rain noise
    % parameters
    motion_length = 15 + (randi(6) - randi(7) + 1); %length (default: 15)
    motion_angle = 90 + 40 * (rand - rand); % angle
    range_min = 0.58 + 0.04 * (rand - rand); % default: (0.55 or 0.6)
    scale = 1.3 + 0.2 * (rand - rand); %intensity of rain noise (default: 1.2)
    range_max = 0.9; %default: 0.9
    uniform_noise_amount = 1.2 + 0.1 * (rand - rand); %rain noise amount (default: 1.2)
    gauss_radius = 0.5 + 0.2 * (rand - rand); %radius (default: 0.5)

    % implementation
    rain_noise = generate_rain(image, motion_length, motion_angle, scale, ...
                range_min, range_max, uniform_noise_amount, gauss_radius);
end
if nargin == 2
    if rain_number < 1 || rain_number > 14
        error('ERROR: Rain numner must be between 1 to 14.');
    end
    % parameters
    motion_length = 15; %length (default: 15)
    motion_angle = 60 + 10 * (floor((rain_number + 1)/2) - 1); % funtion of rain_number
    range_min = 0.6 + 0.05 * (-1)^rain_number; % function of rain_numnber
    scale = 1.2; %intensity of rain noise (default: 1.2)
    range_max = 0.9; %default: 0.8
    uniform_noise_amount = 1.2; % rain noise amount(default: 1.5)
    gauss_radius = 0.5; %radius(default: 0.5)

    % implementation
    rain_noise = generate_rain(image, motion_length, motion_angle, scale, ...
                range_min, range_max, uniform_noise_amount, gauss_radius);
end

end

%% Generate rain noise. 
% You can adjust all parameters.
function rain_noise = generate_rain(img, motion_length, motion_angle, scale, ...
    range_min, range_max, uniform_noise_amount, gauss_radius)

% Parameter setting
if nargin == 0
    % sample implementation
    sample_generate_rain;
    return;
end

if nargin < 2 || isempty(motion_length)
    motion_length = 15; %length
end

if nargin < 3 || isempty(motion_angle)
    motion_angle = 60; %angle
end

if nargin < 4 || isempty(scale)
    scale = 1.2; % intensity
end

if nargin < 5 || isempty(range_min)
    range_min = 0.65; 
end

if nargin < 6 || isempty(range_max)
    range_max = 0.9;
end

if nargin < 7 || isempty(uniform_noise_amount)
    uniform_noise_amount = 1.2; % noise amount
end

if nargin < 8 || isempty(gauss_radius)
    gauss_radius = 0.5; % radius of gaussian filter
end

% Processing

size_img = size(img); % image size

rain_noise = zeros(size_img(1 : 2)); % rain noise matrix

% Generate uniformaly distributed random numbers.
% Adjust the noise amount and crop between 0 and 1.
uniform_noise = ((rand(size_img(1 : 2)) - 0.5) * uniform_noise_amount) + 0.5; 
uniform_noise = min(max(uniform_noise, 0), 1);
rain_noise = rain_noise + uniform_noise;

% Apply Gaussian filter. 
gauss_filter = fspecial('gaussian', 5, sqrt(gauss_radius)); %Ç⁄Ç©Ç∑
rain_noise = imfilter(rain_noise, gauss_filter, 'circular');

% The noise is scaled by threshold values.
rain_noise = (rain_noise - range_min) * ((range_max - range_min) ^ -1);
rain_noise = min(max(rain_noise, 0), 1);


% Apply motion filter.
motion_filter = fspecial('motion', motion_length, motion_angle); 
rain_noise = imfilter(rain_noise, motion_filter, 'circular');

% Adjust a internsity of rain noise.
rain_noise = rain_noise * scale;


end

%% Sample implementation
function sample_generate_rain

img = im2double(imread('./image/synthetic/1original.jpg'));

set(figure(1), 'Name', 'Original image');
imshow(img);

% Rain noise with default parameters
set(figure(2), 'Name', 'Rainy image (default parameters)');
imshow(generate_rain(img));
title('defaul parameters');

% Rain noise with length: 20, angle: 120
set(figure(3), 'Name', 'Rainy image (length 20px, angle: 120 degree)');
imshow(generate_rain(img, 20, 120));
title('length 20px, angle: 120 degree');

end