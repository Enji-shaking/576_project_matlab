%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background video builder %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The purpose of this script is to prepare a folder with frames of
% the background video, which has been extracted using one of the
% conventional approaches (in this scenario I have used mainly
% temporal median approach as the method. Gaussian approach resulted in
% a little noisier panorama.

% Construct a background panorama, as well as individual frames

%We construct a reference plane:
plane = zeros(height,width,3);
prcnt = 0;
h=waitbar(prcnt, 'initializing...'); 
Projected_Video = cell(1,size(H_k_to_ref,2));

for i = 1:size(H_k_to_ref,2)
    prcnt = i / size(H_k_to_ref,2);
    waitbar(prcnt, h, sprintf('panorama ref frames are being generated... \n%d%%',floor(100*prcnt) ));
    if i == round(size(H_k_to_ref,2) / 2)
        I = myplotter(plane, frames{ref_frames(i),1}, eye(3));
    else 
        I = myplotter(plane, frames{ref_frames(i),1}, H_k_to_ref{i});
    end 
    Projected_Video{1,i} = I;
end
waitbar(1, h, sprintf('panorama ref frames generated. \n%d%%',floor(100) ));
close(h);
     
%%FINDING BACKGROUND PANORAMA:
I = zeros(size(plane));
histsR = cell(size(I,1),size(I,2));
histsG = cell(size(I,1),size(I,2));
histsB = cell(size(I,1),size(I,2));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        histsR{i,j} = [];
        histsG{i,j} = [];
        histsB{i,j} = [];
    end
end
%%%%  background panorama
for i = 1:size(H_k_to_ref,2)
    i
    frame=Projected_Video{1,i};
    mask = or((logical(frame(:,:,1))), or((logical(frame(:,:,2))),(logical(frame(:,:,3)))));
    [r,c] = find(mask);
    for k = 1:size(r,1)
       histsR{r(k,1), c(k,1)} =  [histsR{r(k,1), c(k,1)}, frame(r(k,1), c(k,1),1)];
       histsG{r(k,1), c(k,1)} =  [histsG{r(k,1), c(k,1)}, frame(r(k,1), c(k,1),2)];
       histsB{r(k,1), c(k,1)} =  [histsB{r(k,1), c(k,1)}, frame(r(k,1), c(k,1),3)];
    end
end


back_panorama = zeros(size(I));
for i=1:size(I,1)
    i
    for j = 1:size(I,2)
        R = histsR{i,j};
        G = histsG{i,j};
        B = histsB{i,j};
        if size(R,1) ~= 0
            back_panorama(i,j,1) = median(R);
        end
        if size(G,1) ~= 0
            back_panorama(i,j,2) = median(G);
        end
        if size(B,1) ~= 0
            back_panorama(i,j,3) = median(B);
        end
        
    end
end
back_panorama = normalizer(back_panorama);
imwrite(back_panorama, [frame_path, '_back_panorama_img.jpg']);

%building a directory:
mkdir bgdir
panorama = back_panorama;
prcnt = 0;
h=waitbar(prcnt, 'initializing...');

for i = 1:size(H_k_to_ref, 2)
    prcnt = i/size(H_k_to_ref, 2);
    waitbar(prcnt, h, sprintf('please wait, background frames are being generated... \n%d%%',floor(100*prcnt) ));
    frame = frames{i,1};
    H = H_k_to_ref{1,i};
    bgimage = give_it_back_to_me(panorama, frame, H);
    cd bgdir;
    imwrite(bgimage, ['f', sprintf('%.4d',i), '.jpg']);
    cd ..;
end


waitbar(1, h, sprintf('background panaroma pictures generated \n%d%%',floor(100) ));
close(h);

% system('ffmpeg -r 30 -i bgdir/f%04d.jpg -vf "scale=trunc(1861/2)*2:trunc(721/2)*2" -pix_fmt yuv420p 04_background.mp4 ');                            

