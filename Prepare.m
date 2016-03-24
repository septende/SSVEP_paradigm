function [ output ] = Prepare( a )
%PREPARE Summary of this function goes here
%   Detailed explanation goes here
output=imread(a);
output=output(:,:,1);
output(output<200)=0;
output(output>200)=255;
end

