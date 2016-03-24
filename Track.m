%Given a black-white(255-0) image. This function returns the relative coordinate of
%black dots based on start point (start_x,start_y)
function [ x,y ] = Track( a )
[R,~]=size(a);
Reshape_a=a(:);%resize a 2D image into 1D array.
ZeroPosition=find(Reshape_a==0);%locate the black dots
tempx=255*ones(length(ZeroPosition),1);
tempy=255*ones(length(ZeroPosition),1);
%*****The following for loop transfers the 1D location into 2D coordinates
for i= 1:length(ZeroPosition)
        tempx(i)=ceil(ZeroPosition(i)/R);%use help to see ceil function
        tempy(i)=mod(ZeroPosition(i),R); %use help to see mod function
        if tempy(i)==0
            tempy(i)=R;
        end
end
%********The following part records the start point based on mouse click
newfigure=figure;
imshow(a);
[start_x,start_y]=ginput(1);%use help to see ginput function
close(newfigure);
x=tempx-start_x;
y=tempy-start_y;
end

