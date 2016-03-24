clear;clc;
Data=cell(3,6);
%             Data
%               |
%   ----------------------------------------------
%   |         |        |       |         |       |
% Beard1    Body1    Head1    Leg1     Tail1    mane1
% Beard2    Body2    Head2    Leg2     Tail2    mane2
Connection=Prepare('connection.bmp');
Data{1,1}=Prepare('beard1.bmp');
Data{2,1}=Prepare('beard2.bmp');
Data{1,2}=Prepare('body1.bmp');
Data{2,2}=Prepare('body2.bmp');
Data{1,3}=Prepare('head1.bmp');
Data{2,3}=Prepare('head2.bmp');
Data{1,4}=Prepare('leg1.bmp');
Data{2,4}=Prepare('leg2.bmp');
Data{1,5}=Prepare('tail1.bmp');
Data{2,5}=Prepare('tail2.bmp');
Data{1,6}=Prepare('mane1.bmp');
Data{2,6}=Prepare('mane2.bmp');
%----------------------------
[row,col]=size(Connection);
half_row=floor(row/2);
half_col=floor(col/2);
%canvas size
new_row=300;
new_col=300;
%-----fix connection to the center of canvas
Canvas=255*ones(new_row,new_col);
Canvas((new_row/2-half_row+1):new_row/2+(row-half_row),(new_col/2-half_col+1):new_col/2+(col-half_col))=Connection;
%-----Dots trace
Connection_Coordinate=cell(3,6);                                
temp=figure;
imshow(Connection);
for i=1:6
    for j=1:2       
        [Connection_Coordinate{j,i}{1},Connection_Coordinate{j,i}{2}]=Track(Data{j,i});%get dots trace from 6 sub-images
    end
    myfigure=figure;
    imshow(Canvas);
    [Connection_Coordinate{3,i}(1),Connection_Coordinate{3,i}(2)]=ginput(1);% keep the connection points based on mouse click.
    close(myfigure);
end
close(temp);
%---------get dots trace from connection image
Connection_xy=cell(1,2);
[R,C]=size(Canvas);
Reshape_Canvas=Canvas(:);
ZeroPosition=find(Reshape_Canvas==0);
tempx=255*ones(length(ZeroPosition),1);
tempy=255*ones(length(ZeroPosition),1);
for i= 1:length(ZeroPosition)
        tempx(i)=ceil(ZeroPosition(i)/R);
        tempy(i)=mod(ZeroPosition(i),R);
        if tempy(i)==0
            tempy(i)=R;
        end
end
for i=1:length(tempx)
    Connection_xy{1}(i)=tempx(i)-C/2;
    Connection_xy{2}(i)=tempy(i)-R/2;
end
save('data.mat','Connection_Coordinate','Connection_xy','Canvas');




        