% =======================================================================
% ======================== 'demo_fast_derain.m'===============================
% This script is for implementation of ResDerainNet proposed in the paper
% whose title is "Single-image rain removal using residual deep learning".
% You can test on both synthetic and real-world images.
%   Input        : Rainy image
%   Medium output: Rain noise
%   Final output : De-rained image
% You are required to change the patch size in the file
% 'Residual_net_relu_matlab_fast.prototxt'.
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
        
        patch_size = 128;
        rainy_image = rainy_image(1:patch_size,1:patch_size,:);
        ground_truth = ground_truth(1:patch_size,1:patch_size,:);
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
prototxt_file = 'Residual_net_relu_matlab_fast.prototxt';
net = caffe.Net(prototxt_file,[weight_dir weight_h5], 'test');

%% Processing
net.forward({rainy_image});
mid_output = net.blobs('conv20').get_data();
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