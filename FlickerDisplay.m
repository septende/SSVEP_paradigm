function [ timeUse,keyUse ] = FlickerDisplay( window,resolusion, Hz, displaytime,x,y,center_x,center_y )
Screen('Flip',window);
RefreshRate=Screen('GetFlipInterval',window);% get refress rate in seconds. for 60 hz, it should be 1/60 (s)
TotalFrames=round(displaytime/RefreshRate);% max frames num you want to display.
FramesPerStimuli=round(1/Hz/RefreshRate);% Frames for each displaying period.
FrameCounter=0;
Screen('FillRect',window,[255 255 255],resolusion);
StartTime=Screen('Flip',window);
while 1
    if FrameCounter==TotalFrames % no key pressed down
        timeUse=displaytime;
        break;
    end
    if ~mod(FrameCounter,FramesPerStimuli)
        dotcolor=0;
    else
        dotcolor=255;
    end
    Screen('DrawDots', window, [x; y], 1,dotcolor,[center_x center_y],1);%draw dots
    Screen('Flip',window);
    FrameCounter=FrameCounter+1;
    [~,EndTime,keyCode,~]=KbCheck;
    [~,~]=KbReleaseWait;
    if (max(keyCode)==1)
        timeUse=EndTime-StartTime;
        keyUse=keyCode;
        break
    else
        keyUse=0;
    end    
end
end

