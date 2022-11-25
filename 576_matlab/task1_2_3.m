original_path = frame_path;                      % original image path
fore_path = [frame_path, '_fore'];               % from the generate_fore_img.m
back_path = 'bgdir';                             % from the script.m
ref_frames = 1:20:frame_num;                     % selected frames
H_to_ref = struct2cell(load([frame_path, '_H_to_ref.mat']));    % from the script.m
H_to_ref = H_to_ref{1};
back_panorama = imread([frame_path, '_back_panorama_img.jpg']); % from the script.m
vidObj1 = VideoWriter([frame_path, '_task2_output'],'MPEG-4');
vidObj1.FrameRate=2;                             % FrameRat
vidObj2 = VideoWriter([frame_path , '_task3_output'],'MPEG-4');
vidObj2.FrameRate=25;                            % FrameRat
vidObj3 = VideoWriter([frame_path , '_task4_output'],'MPEG-4');
vidObj3.FrameRate=10;                            % FrameRat
all_frames_num = frame_num;                            % the same to script.m


projected_frames_path = 'projected_frames';

%%%%%%%%%%%%%%%%%%task1%%%%%%%%%%%%%%%%
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
imwrite(back_panorama, [frame_path, '_fore_panorama_img.jpg']);
disp("task 1 done")




%%%%%%%%%%%%%%%%%%task2%%%%%%%%%%%%%%%%

open(vidObj3);
cd(fore_path);
frame_num = size(ref_frames, 2);
frames = cell(frame_num,1);
%perform the reading:
for i = 1:frame_num
    frames{i,1} = imread(['fore', sprintf('%.4d',ref_frames(i)), '.jpg']);
end
cd ..;

mkdir(projected_frames_path);
cd(projected_frames_path);

for i = 1:frame_num
    back_temp = back_panorama;
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
    cd ..;
    back_temp = myplotter(back_temp, frame, H);
    cd(projected_frames_path);
    imwrite(back_temp, [projected_frames_path, sprintf('%.4d',i),'.jpg']);
    f = back_temp;                
    writeVideo(vidObj3,f);

end
%imwrite(back_panorama, [frame_path, '_fore_panorama_img.jpg']);


%close video
close(vidObj3);

cd ..;

disp("task 2 done")



%%%%%%%%%%%%%%%%%%task3%%%%%%%%%%%%%%%%
%load background img
cd(back_path);
frame_num = round(all_frames_num / interval_num);
frames = cell(frame_num,1);
%perform the reading:
for i = 1:frame_num
    frames{i,1} = imread(['f', sprintf('%.4d',i), '.jpg']);
end
cd ..;

%ref images convert to video
open(vidObj2);
for i = 1:frame_num
    f = frames{i};                
    writeVideo(vidObj2,f);
end
%close video
close(vidObj2);

disp("task 3 done")

%THE END
