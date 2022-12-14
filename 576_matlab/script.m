clear all;
close all;
clc;

video_path = 'inputvideo_640_368_351.mp4';            % original video path           
split_temp = split(video_path, '.');
frame_path = split_temp{1};                           % original image path
interval_num = 5;                                     % frame interval for calculate transformation matrix (1 or 2)
height = 711;                                         % height of panorama
width = 5000;                                         % width of panorama                                   % frames number

obj = VideoReader(video_path);
frame_num = obj.NumberOfFrames;

ref_frames = 1:interval_num:frame_num;

newvideo = false;
% generate the folder images
if ~exist(frame_path, 'dir')
    newvideo = true;
    mkdir(frame_path);
end

%moving to the folder of the images:
cd(frame_path);
%reading the frames into a huge cell array:
frames = cell(frame_num,1);
%write images into jpg files
for i = 1:frame_num
    frame = read(obj,i);
    frames{i,1} = frame;
    if newvideo
        imwrite(frame, [sprintf('%.4d',i),'.jpg']);
    end
end
%head back
cd ..


% % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % Task!!! % % % % % % % % %
% % % % % Understand code below % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % 

% Enji's note: It seem's calculating the H_K_ref matrix through D/F/h
% matrixs, and the matrix is used later. But no idea what's the exact
% procedure
if newvideo
    generate_h_k_to_ref;
end

% Enji's note: It uses a mysterious way to get an okay plain background
% first, then extract each single image out of the panorama. We may need to
% understand the algorithm below

H_k_to_ref = struct2cell(load([frame_path, '_H_to_ref.mat']));    % from the script.m
H_k_to_ref = H_k_to_ref{1};

% generate back panorama and frame by frame iamge out of that panorama
% back_builder;

% generate foreground image
% generate_fore_img;

% % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % Task!!! % % % % % % % % %
% % % % % Understand code above % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % 

% use created foreground images and background panorama to create an image
% for task 1
% Not using right now because we have better python code
% create_panorama_with_static_foreground;
% use created foreground images and background panorama to create a moving
% forground video for task 2
% create_panorama_with_moving_foreground;
% use result from back_builder, the created background images to create a
% video for task 3
create_plain_background_video;

% task1_2_3;

%THE END
