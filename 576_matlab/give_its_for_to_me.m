%%%%%%%%%%%%%%%%%%%%%%%%
%% give_its_for_to_me %%
%%%%%%%%%%%%%%%%%%%%%%%%
% This function works as follows:
% - It takes the background panorama, along with one frame of the
%   video and it's homography as it's inputs, 
%   then projects the frame on the mosaic, finds
%   the corresponding box on the mosaic, finds the foreground, and backprojects the part from
%   the mosaic, and that's it.

function out = give_its_for_to_me(panorama, frame, H)
%using the help from Dr. Sadeghi:

tform = maketform('projective', H');
transformedimage = imtransform(frame, maketform('projective', H'),...
                               'VData',[1 size(frame,1)],'UData',[1 size(frame,2)],...
                               'XData',[1+size(frame,2)-size(panorama,2)*3/4 size(frame,2)+size(panorama,2)/4],'YData',[1+size(frame,1)-size(panorama,1) size(frame,1)]);

mask = double(logical(transformedimage));
mask = double(logical(mean(mask,3)));
mask = cat(3, mask, mask, mask);
background = uint8(mask .* double(panorama));
temp = abs(transformedimage - background);
% temp = temp > 20;
% temp = double(logical(mean(temp,3)));
% temp = cat(3, temp, temp, temp);
transformedimage = uint8(double(temp));
% transformedimage = uint8(temp.*double(transformedimage));
% imshow(transformedimage);
% pause;
U = [1; 1; size(frame,1); size(frame,1)];
V = [1; size(frame,2); size(frame,2); 1];
[X, Y] = tformfwd(tform, U, V);
X = X - size(frame,2) + size(panorama,2)*3/4;
Y = Y - size(frame,1) + size(panorama,1);

tform2 = maketform('projective', [X Y], [U V]);
out = imtransform(transformedimage, tform2,'XData',[1 size(frame,2)],'YData',[1 size(frame,1)]);


end