function [CH] = colorhistogram(bimage,containersize,image)
%image=rgb2hsv(image);
gg=double(bimage);
gg(find(gg==0))=NaN;


image2(:,:,1)=im2double(image(:,:,1)).*gg;
image2(:,:,2)=im2double(image(:,:,2)).*gg;
image2(:,:,3)=im2double(image(:,:,3)).*gg;
siz=size(image2);

image3=reshape(image2,siz(1)*siz(2),siz(3));
image3=double(image3);

[N,X]=hist(image3, [0:containersize:1]);
CH(:,1,1)=N(:,1,1)/sum(N(:,1,1));
CH(:,2,1)=N(:,2,1)/sum(N(:,2,1));
CH(:,3,1)=N(:,3,1)/sum(N(:,3,1));


