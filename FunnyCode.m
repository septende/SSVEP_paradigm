clear;
clc;
close all;
Screen('Preference', 'SkipSyncTests', 1)
screens = Screen('Screens');
screenNumber = max(screens);
%***********read image********
load('data.mat');
[R,C]=size(Canvas);
center_cx=C/2; 
center_cy=R/2;
%********random generator*****
group_num=10;
R_seq=cell(1,group_num); %20ื้
R_alien=cell(1,group_num);
trace=cell(1,group_num);
for i=1:group_num
    trace{i}=cell(1,2);
end
%*************The following part is very important
%*************call me if you can not follow
for i=1:1:group_num
    R_seq{i}=binornd(1,0.5,[1 6])+1; %generates random sequence to pick up different parts.
    for j=1:6
        trace{i}{1}=[trace{i}{1} (Connection_Coordinate{R_seq{i}(j),j}{2}'+Connection_Coordinate{3,j}(2)-center_cx)];%keep an eye on this line, make sure you understand it.
        trace{i}{2}=[trace{i}{2} (Connection_Coordinate{R_seq{i}(j),j}{1}'+Connection_Coordinate{3,j}(1)-center_cy)];
    end
        trace{i}{1}=[trace{i}{1} Connection_xy{2}];
        trace{i}{2}=[trace{i}{2} Connection_xy{1}];
end    
%**********************************************
[window,rect]=Screen('OpenWindow',screenNumber);
center_x=rect(3)/2;center_y=rect(4)/2;
KbName('UnifyKeyNames');
fid=fopen('result.txt','w+');
for i=1:group_num
    [timeUse,keyUse]=FlickerDisplay(window,rect,60,5,trace{i}{2},trace{i}{1},center_x,center_y);
    if keyUse==0
        fprintf(fid,'%s       %s       %f\n','Nan','NoPress',timeUse);        
    else
        fprintf(fid,'%s       %s       %f\n','Nan',KbName(keyUse),timeUse);
    end
end
fclose(fid);
Screen('CloseAll');
close all;