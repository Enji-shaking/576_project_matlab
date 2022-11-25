vidObj3 = VideoWriter([frame_path , '_task3_output'],'MPEG-4');
vidObj3.FrameRate=25;                            % FrameRat
plain_back_frames_path = 'bgdir';                % from the script.m
all_frames_num = frame_num;                      % the same to script.m


%%%%%%%%%%%%%%%%%%task3%%%%%%%%%%%%%%%%
% Create the background image without foreground element
%load background img
cd(plain_back_frames_path);
frame_num = round(all_frames_num / interval_num);
frames = cell(frame_num,1);
%perform the reading:
for i = 1:frame_num
    frames{i,1} = imread(['f', sprintf('%.4d',i), '.jpg']);
end
cd ..;

%ref images convert to video
open(vidObj3);
for i = 1:frame_num
    f = frames{i};                
    writeVideo(vidObj3,f);
end

%close video
close(vidObj3);
disp("Plain background generated")
