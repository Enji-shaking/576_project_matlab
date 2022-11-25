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
align_frame = ref_frames(round(size(ref_frames, 2) / interval_num));

% mkdir(frame_path);
% %moving to the folder of the images:
% cd(frame_path);
% %reading the frames into a huge cell array:
% frames = cell(frame_num,1);
% %get image
% for i = 1:frame_num
%     frame = read(obj,i);
%     frames{i,1} = frame;
%     imwrite(frame, [sprintf('%.4d',i),'.jpg']);
% end
% %head back
% cd ..;
% 
% 
% %finding some important homographies...:
% F = {};
% D = {};
% for i = 1:interval_num:frame_num
%     % [f, d] = getFeatures(im2single(rgb2gray(frames{i,1})), 'PeakThresh',0.00001);
%     i
%     [d, f] = getFeatures(frames{i,1});
%     D{ceil(i / interval_num)} = d;
%     F{ceil(i / interval_num)} = f;
% end
% 
% matches = {};
% for i = 1:round(size(D,2)/2) - 1
%     D_temp = D{i};
%     D_temp_next = D{i+1};
%     matches{i} = match(D_temp, D_temp_next);
% end
% 
% for i = round(size(D,2)/2) + 1:size(D,2)
%     D_temp = D{i};
%     D_temp_before = D{i-1};
%     matches{i} = match(D_temp, D_temp_before);
% end
% 
% H = {}
% inliers = {}
% 
% for i = 1:round(size(D,2)/2) - 1
%     [H_temp, inliers_temp] = ransacfithomography(F{i}(1:2,matches{i}(1,:)),...
%     F{i+1}(1:2,matches{i}(2,:)), 0.001);
%     H{i} = H_temp;
%     inliers{i} = inliers_temp;
% end
% 
% for i = round(size(D,2)/2) + 1:size(D,2)
%     
%     [H_temp, inliers_temp] = ransacfithomography(F{i}(1:2,matches{i}(1,:)),...
%     F{i-1}(1:2,matches{i}(2,:)), 0.001);
%     H{i} = H_temp;
%     inliers{i} = inliers_temp;
% end
% 
% %now main Hs computed, the way we use these Hs are as following:
% % newimage = imtransform(firstimage, maketform('projective', H'));
% H_k_to_ref = {}
% H_k_to_ref{round(size(D,2)/2)-1} = H{round(size(D,2)/2)-1};
% for i = round(size(D,2)/2)-2:-1:1
%     H_temp = H{i};
%     H_k_to_ref{i} = H_k_to_ref{i+1} * H_temp
% end
% 
% H_k_to_ref{round(size(D,2)/2)} = eye(3);
% 
% H_k_to_ref{round(size(D,2)/2)+1} = H{round(size(D,2)/2)+1};
% for i = round(size(D,2)/2)+2:size(H,2)
%     H_temp = H{i};
%     H_k_to_ref{i} = H_temp * H_k_to_ref{i-1} 
% end
% 
% %%%%%%%%%% COMBINING ALGORITHM %%%%%%%%%%
% % %Now, making that video...
% %We construct a reference plane:
% plane = zeros(height,width,3);
% prcnt = 0;
% h=waitbar(prcnt, 'initializing...'); 
% Projected_Video = cell(1,size(H_k_to_ref,2));
% 
% for i = 1:size(H_k_to_ref,2)
%     prcnt = i / size(H_k_to_ref,2);
%     waitbar(prcnt, h, sprintf('please wait, frames are being generated... \n%d%%',floor(100*prcnt) ));
%     if i == round(size(H_k_to_ref,2) / 2)
%         I = myplotter(plane, frames{ref_frames(i),1}, eye(3));
%     else 
%         I = myplotter(plane, frames{ref_frames(i),1}, H_k_to_ref{i});
%     end 
%     Projected_Video{1,i} = I;
% end
% waitbar(1, h, sprintf('All done. \n%d%%',floor(100) ));
% close(h);
%      
% %%FINDING BACKGROUND PANORAMA:
% I = zeros(size(plane));
% histsR = cell(size(I,1),size(I,2));
% histsG = cell(size(I,1),size(I,2));
% histsB = cell(size(I,1),size(I,2));
% for i = 1:size(I,1)
%     for j = 1:size(I,2)
%         histsR{i,j} = [];
%         histsG{i,j} = [];
%         histsB{i,j} = [];
%     end
% end
% %%%%  background panorama
% for i = 1:size(H_k_to_ref,2)
%     i
%     frame=Projected_Video{1,i};
%     mask = or((logical(frame(:,:,1))), or((logical(frame(:,:,2))),(logical(frame(:,:,3)))));
%     [r,c] = find(mask);
%     for k = 1:size(r,1)
%        histsR{r(k,1), c(k,1)} =  [histsR{r(k,1), c(k,1)}, frame(r(k,1), c(k,1),1)];
%        histsG{r(k,1), c(k,1)} =  [histsG{r(k,1), c(k,1)}, frame(r(k,1), c(k,1),2)];
%        histsB{r(k,1), c(k,1)} =  [histsB{r(k,1), c(k,1)}, frame(r(k,1), c(k,1),3)];
%     end
% end
% 
% 
% back_panorama = zeros(size(I));
% for i=1:size(I,1)
%     i
%     for j = 1:size(I,2)
%         R = histsR{i,j};
%         G = histsG{i,j};
%         B = histsB{i,j};
%         if size(R,1) ~= 0
%             back_panorama(i,j,1) = median(R);
%         end
%         if size(G,1) ~= 0
%             back_panorama(i,j,2) = median(G);
%         end
%         if size(B,1) ~= 0
%             back_panorama(i,j,3) = median(B);
%         end
%         
%     end
% end
% back_panorama = normalizer(back_panorama);
% imwrite(back_panorama, [frame_path, '_back_panorama_img.jpg']);
% 
% save([frame_path, '_H_to_ref.mat'],'H_k_to_ref');
% back_builder;
% 
% %generate foreground image
% generate_fore_img;

%task 1 2 3
task1_2_3;

%THE END
