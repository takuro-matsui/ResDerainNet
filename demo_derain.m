% =======================================================================
% ======================== 'demo_derain.m'===============================
% This script is for implementation of ResDerainNet proposed in the paper
% whose title is "Single-image rain removal using residual deep learning".
% You can test on both synthetic and real-world images.
%   Input        : Rainy image
%   Medium output: Rain noise
%   Final output : De-rained image
% =======================================================================



%% Choose the input image type
img_type = 'synthetic';
%img_type = 'real_world';

%% Parameter setting
image_number = 2; % synthetic: {1,2,3,4}, real-world: {1,2,3,4,5,6}
gpu = false;

%% Read an image
switch img_type
    case 'real_world'
        rainy_image = im2single(imread(['image/real_world/' num2str(image_number) '.jpg']));
    case 'synthetic'   
        rainy_image = im2single(imread(['image/synthetic/' num2str(image_number) 'rain.bmp']));
        ground_truth = im2single(imread(['image/synthetic/' num2str(image_number) 'original.jpg']));
end
set(figure(1), 'Name', 'Rainy image'); imshow(rainy_image);

%% Caffe
caffe.reset_all();
if gpu
    caffe.set_mode_gpu();
    caffe.set_device(1);
end
weight_dir = 'weight_add_residual/';
weight_h5 = 'ResDerainNet_iter_100000.caffemodel.h5';
prototxt_file = 'Residual_net_relu_matlab.prototxt';
net = caffe.Net(prototxt_file,[weight_dir weight_h5], 'test');

%% Processing
% Crop an image to size of 128*128 so as not to exceed maximum memory
patch_size_x = 128;
patch_size_y = 128;
patch_shift = 106;

mid_output = zeros( size(rainy_image), 'like', rainy_image );
overlap_count_output = mid_output(:, :, 1);

for patch_x = 1 : patch_shift : size(rainy_image, 2)
    for patch_y = 1 : patch_shift : size(rainy_image, 1)
        % y coordinate
        y_input = ( 1 : patch_size_y ) + patch_y - 1;
        y_output = (1 : patch_size_y ) + patch_y - 1;
        if y_input(end) > size(rainy_image, 1)
            y_input  = ( - patch_size_y + 1 : 0 ) + size(rainy_image, 1);
            y_output = ( - patch_size_y + 1 : 0 ) + size(rainy_image, 1);
        end
        % x cordinate
        x_input  = ( 1 : patch_size_x ) + patch_x - 1;
        x_output = ( 1 : patch_size_x ) + patch_x - 1;
        if x_input(end) > size(rainy_image, 2)
            x_input  = ( - patch_size_x + 1 : 0 ) + size(rainy_image, 2);
            x_output = ( - patch_size_x + 1 : 0 ) + size(rainy_image, 2);
        end
                      
        net.forward({rainy_image(y_input, x_input, :)});

        rain_noise_patch = net.blobs('conv20').get_data();
        mid_output(y_output, x_output, :) =  mid_output(y_output, x_output, :) + rain_noise_patch;
        overlap_count_output(y_output, x_output) = overlap_count_output(y_output, x_output) + 1;
    end
end

mid_output = mid_output ./ overlap_count_output;
final_output = rainy_image - mid_output;


%% Show results
switch img_type
    case 'synthetic'
        set(figure(5), 'Name', 'Derained output'); imshow([ground_truth final_output]);
        title('(left) ground truth               (right) estimated');
        set(figure(6), 'Name', 'Estimated rain noise'); imshow([(rainy_image - ground_truth) mid_output]);
        title('(left) ground truth               (right) estimated');
        PSNR = psnr(final_output, ground_truth);
        SSIM = ssim(final_output, ground_truth);
        T = table(image_number, PSNR, SSIM)
    case 'real_world'
        set(figure(6), 'Name', 'Estimated rain noise'); imshow(mid_output);
        dehazed_output = imreducehaze(final_output);
        set(figure(5), 'Name', 'Final output'); imshow([ rainy_image dehazed_output]);
        title('(left) input               (right) output');
end