F = {};
D = {};
for i = 1:interval_num:frame_num
    % [f, d] = getFeatures(im2single(rgb2gray(frames{i,1})), 'PeakThresh',0.00001);
%     Super super slow here
    i
    [d, f] = getFeatures(frames{i,1});
    D{ceil(i / interval_num)} = d;
    F{ceil(i / interval_num)} = f;
end

matches = {};
for i = 1:round(size(D,2)/2) - 1
    D_temp = D{i};
    D_temp_next = D{i+1};
    matches{i} = match(D_temp, D_temp_next);
end

for i = round(size(D,2)/2) + 1:size(D,2)
    D_temp = D{i};
    D_temp_before = D{i-1};
    matches{i} = match(D_temp, D_temp_before);
end

H = {}
inliers = {}

for i = 1:round(size(D,2)/2) - 1
    [H_temp, inliers_temp] = ransacfithomography(F{i}(1:2,matches{i}(1,:)),...
    F{i+1}(1:2,matches{i}(2,:)), 0.001);
    H{i} = H_temp;
    inliers{i} = inliers_temp;
end

for i = round(size(D,2)/2) + 1:size(D,2)
    
    [H_temp, inliers_temp] = ransacfithomography(F{i}(1:2,matches{i}(1,:)),...
    F{i-1}(1:2,matches{i}(2,:)), 0.001);
    H{i} = H_temp;
    inliers{i} = inliers_temp;
end

%now main Hs computed, the way we use these Hs are as following:
% newimage = imtransform(firstimage, maketform('projective', H'));
H_k_to_ref = {}
H_k_to_ref{round(size(D,2)/2)-1} = H{round(size(D,2)/2)-1};
for i = round(size(D,2)/2)-2:-1:1
    H_temp = H{i};
    H_k_to_ref{i} = H_k_to_ref{i+1} * H_temp
end

H_k_to_ref{round(size(D,2)/2)} = eye(3);

H_k_to_ref{round(size(D,2)/2)+1} = H{round(size(D,2)/2)+1};
for i = round(size(D,2)/2)+2:size(H,2)
    H_temp = H{i};
    H_k_to_ref{i} = H_temp * H_k_to_ref{i-1} 
end
save([frame_path, '_H_to_ref.mat'],'H_k_to_ref');