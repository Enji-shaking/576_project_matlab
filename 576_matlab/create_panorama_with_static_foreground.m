original_path = frame_path;                      % original image path
fore_path = [frame_path, '_fore'];               % from the generate_fore_img.m

ref_frames = 1:20:frame_num;                     % selected frames
H_to_ref = struct2cell(load([frame_path, '_H_to_ref.mat']));    % from the script.m
H_to_ref = H_to_ref{1};
back_panorama = imread([frame_path, '_back_panorama_img.jpg']); % from the script.m

%%%%%%%%%%%%%%%%%%task1%%%%%%%%%%%%%%%%
% use the created foreground frames, and the created panorama, to create a
% whole picture
% As a side note, we will not use this part of code
cd(fore_path);
frame_num = size(ref_frames, 2);
frames = cell(frame_num,1);
%perform the reading:
for i = 1:frame_num
    frames{i,1} = imread(['fore', sprintf('%.4d',ref_frames(i)), '.jpg']);
end
cd ..;


for i = 1:frame_num
    frame = frames{i};
    for j=1:size(frame,1)
        for k=1:size(frame,2)
            if frame(j, k, 1) == 255 || frame(j, k, 2) == 255 || frame(j, k, 3) == 255
                frame(j, k, 1) = 0;
                frame(j, k, 2) = 0;
                frame(j, k, 3) = 0;
            end
        end
    end
    H = H_to_ref{ceil(ref_frames(i)/interval_num)};
    back_panorama = myplotter(back_panorama, frame, H);
end
imwrite(back_panorama, [frame_path, '_task1_img.jpg']);
disp("Panorama with foreground created")



%THE END
