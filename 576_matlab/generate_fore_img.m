fore_save_path = [frame_path, '_fore'];    % generate fore image

%it needs to be adjusted according to the video data
block_size=31;                             % must odd
interval_num_fore = 2;                          % frame interval for block matching
threshold_1ow = 2;                         % determine the threshold of foreground and background
threshold_high = threshold_1ow * 10;

%moving to the folder of the images:
cd(frame_path);

%reading the frames into a huge cell array:
frames = cell(frame_num,1);

%perform the reading:
for i = 1:frame_num
    frames{i,1} = imread([sprintf('%.4d',i), '.jpg']);
end

%head back
cd ..;

%load BlockMatcher
hbm = vision.BlockMatcher('ReferenceFrameSource',...
        'Input port','SearchMethod', 'Three-step', 'MatchCriteria', 'Mean absolute difference (MAD)', 'BlockSize',[block_size block_size]);
hbm.OutputValue = 'Horizontal and vertical components in complex form';
halphablend = vision.AlphaBlender;

mkdir(fore_save_path);

for i = 1:interval_num_fore:frame_num-interval_num_fore
    img0 = frames{i,1};
    img1 = im2double(im2gray(frames{i,1}));
    img2 = im2double(im2gray(frames{i+interval_num_fore,1}));
    motion = hbm(img1,img2);
    %calculating motion vectors
    [X,Y] = meshgrid(1:block_size:size(img1,2),1:block_size:size(img1,1));
    [row,line]=size(img1);
    %subtract background motion vector
    u=real(motion);
    v=imag(motion);
    mean_u = median(u(:));
    mean_v = median(v(:));
    diff_u = u - mean_u;
    diff_v = v - mean_v;
    diff_abs = abs(diff_u + diff_v*i);
    %judge the foreground and background
    judge_fore = (diff_abs > threshold_1ow) .* (diff_abs < threshold_high);
    judge_fore(1,:)=0;judge_fore(end,:)=0;judge_fore(:,1)=0;judge_fore(:,end)=0;
    %get foreground image
    fore_img = img1-img1;
    m=1;
    for j=1:block_size:row-block_size-1
       n=1;
        for k=1:block_size:line-block_size-1
           fore_img(j:j+block_size-1,k:k+block_size-1)=img1(j:j+block_size-1,k:k+block_size-1)*judge_fore(m,n); %按照运动场的偏移进行恢复
            n=n+1;
        end
        m=m+1;
    end
    %get foreground image with color
    fore_color_img = img0;
    fore_img_mask = fore_img == 0;
    fore_img_mask = repmat(fore_img_mask, [1,1,3]);
    fore_color_img(fore_img_mask) = 255;
    % save foreground image
    cd(fore_save_path);
    imwrite(fore_color_img, ['fore', sprintf('%.4d',i), '.jpg']);
    cd ..;
end

%THE END


