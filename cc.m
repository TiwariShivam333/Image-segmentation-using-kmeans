clc;
clear all;

RGB = imread('kobi.png');
RGB = imresize(RGB,0.4);
I=RGB;
imshow(RGB);
nrows = size(RGB,1);
ncols = size(RGB,2);
[X,Y] = meshgrid(1:ncols,1:nrows);
%I = rgb2gray(im2single(RGB));
J=stdfilt(I);
J=reshape(J,nrows*ncols,3);
Z=[X Y];
Z=reshape(Z,nrows*ncols,2);
RGB=reshape(RGB,nrows*ncols,3);
RGB=normalize(double(RGB));
Z=normalize(Z);
%imshow(J);

data= [RGB Z J];%cat(3,RGB,X,Y,J);
disp(size(data));
fprintf("1. RED\n2. GREEN\n3. BLUE\n4. X\n5. Y\n[6,7,8] Texture\n");
ab=input('Enter the column numbers(in [] with spaces) you want as features ');

X=[data(:,ab)];
%data=reshape(featureSet,nrows*ncols,6);
[n,features]=size(X);
k=input('Enter number of segments ');
%X=double(data);
A=randperm(n,k);
assign=zeros(n,1);
centers=X(A,:);
prev=centers;
prev(1,1)=0;

while sum(sum(prev~=centers))
%for iter=1:10
    c_no=zeros(k,1);
    clustersum=zeros(k,features);
    for i=1:n
        min=99999;
        for j=1:size(centers)
            d=sqrt(sum((X(i,:) - centers(j,:)) .^ 2));
            if d<min
                index=j;
                min=d;
            end    
        end
        %[m,index]=min(d);
        c_no(index)=c_no(index)+1;
        clustersum(index,:)=clustersum(index,:)+X(i,:);
        assign(i)=index;
    end 
    c_no
    prev=centers;
    centers=clustersum./c_no;
end 
if(c_no(2)>c_no(1))
for i=1:size(assign,1)
if(assign(i)==1)
assign(i)=2;
else
assign(i)=1;
end
end
end
pixel_labels = reshape(assign,nrows,ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');
