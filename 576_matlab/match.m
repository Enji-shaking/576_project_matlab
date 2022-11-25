% 
%   Copyright (C) 2016  Starsky Wong <sununs11@gmail.com>
% 
%   Note: The SIFT algorithm is patented in the United States and cannot be
%   used in commercial products without a license from the University of
%   British Columbia.  For more information, refer to the file LICENSE
%   that accompanied this distribution.

function [ matched_ ] = match( des1, des2 )
% Function: Match descriptors from the 1st to the 2nd, return matched index.
% matched vectors' angles from the nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;
% for each descriptor in the first image, select its match to second image.
des2t = des2';
n = size(des1,1);
matched = zeros(2,n);
for i = 1 : n
   dotprods = des1(i,:) * des2t;
   [values,index] = sort(acos(dotprods));
   if (values(1) < distRatio * values(2))
      matched(1:2, i) = [i, index(1)];
   else
      matched(1:2, i) = [0, 0];
   end
end

matched_ = matched(:, matched(1, :) ~= 0);

end