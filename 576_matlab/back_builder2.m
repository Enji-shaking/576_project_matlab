%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background video builder - pan %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The purpose of this script is to prepare a folder with frames of
% the background video, which has been extracted using one of the
% conventional approaches (in this scenario I have used mainly
% temporal median approach as the method. Gaussian approach resulted in
% a little noisier panorama.

%building a directory:
mkdir bgpandir
panorama = back_panorama;
prcnt = 0;
h=waitbar(prcnt, 'initializing...');
for i = 1:size(H_k_to_ref, 2)
    prcnt = i / size(H_k_to_ref, 2);
    waitbar(prcnt, h, sprintf('please wait, background frames are being generated... \n%d%%',floor(100*prcnt) ));
    
    frame = frames{ref_frames(i),1};
    H = H_k_to_ref{1,i};
    bgimage = give_it_back_to_me2(panorama, frame, H);
    cd bgpandir;
    imwrite(bgimage, ['f', sprintf('%.4d',i), '.jpg']);
    cd ..;
end
waitbar(1, h, sprintf('All done. \n%d%%',floor(100) ));
close(h);
system('ffmpeg -r 30 -i bgpandir/f%04d.jpg -vf "scale=trunc(1861/2)*2:trunc(721/2)*2" -pix_fmt yuv420p 02_back_pan.mp4 ');                            

