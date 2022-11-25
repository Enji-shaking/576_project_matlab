clear all;
obj = VideoReader('D:/video_test/yolotest.mp4');%输入视频位置
numFrames = obj.NumberOfFrames;% 帧的总数
numzeros= 4;%图片name长度
nz = strcat('%0',num2str(numzeros),'d');
for k = 1:15% 读取前15帧
    frame = read(obj,k);%读取第几帧
    id=sprintf(nz,k);
    imwrite(frame,strcat('D:/image/',id,'.jpg'),'jpg');% 保存帧
end
