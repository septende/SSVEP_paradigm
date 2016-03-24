function pres_ALSSBeh()


InitExperiment;

global w wRect centerx centery subinfo dataFile daydouble
global ttable ttable_new codes mybasecodes
global relevantfeatset
global trainedstimset
global fixyoff fixxoff fixx fixy fixationcross fcolor fixationcolor penwidth fixationsize fixwidth
global fixdur stimdur ITI preblockInt fbdur ITI2
global horseparts humparts horsexy humxy  horsedims humdims reldimnames xyadjust xyadjust_labels
global mystimuli
global stimcolor mywrap
global debugging debugging1
global nbut mbut pausekey
global textcolor
global numblocks scale myset subnum

experimentstarttime = GetSecs();

debugging = 0;
debugging1 = 0;
debugsync = 0;

if ~debugging
% very long durations while experimenter gives verbal instructions
    
    fixdur = .5;
    stimdur = .6;
    ITI = .5;
    ITI2 = .5;
    preblockInt = 1.5;
    fbdur = .7;
    pausetime = 3600; % pause for this number of seconds if pause is triggered
    
else
    fbdur = .001;
    fixdur = .001;
    stimdur = .001;
    ITI = .001;
    ITI2 = .001;
    preblockInt = .001;
    pausetime = 3600; % pause for this number of seconds if pause is triggered
    
end

scale = .2;
stimcolor = 250;
backgroundcolor = 0;
textcolor = stimcolor;
mbut = 'S';
nbut = 'L';
pausekey = 'p';
numtrndays = 6;
numblocks = 16;
mywrap = 70;


if ~debugging
    badfilename = 0;
    GetParticipantInfo_v2('OBSSBeh','day','numblocks');
    subnum = str2double(subinfo.subnum);
    daydouble = str2double(subinfo.day);
    numblocks = str2double(subinfo.numblocks);
    
    FileNameErrorMsg0 = ['You entered: name: ' subinfo.subname ' subnum: ' subinfo.subnum ' day: ' subinfo.day];
    FileNameErrorMsg1 = 'One or more previous training sessions are missing';
    FileNameErrorMsg2 = 'for this subject. Make sure you have the ';
    FileNameErrorMsg3 = 'correct initials, participant number, and training day.';
    FileNameErrorMsg4 = 'For clues, check in desktop folder Experiments/AliensSS/data';
    FileNameErrorMsg5 = ['for other datafiles with initials ' subinfo.subname ' or # ' subinfo.subnum];
    FileNameErrorMsg6 = 'and double check the sublist.';
        
    if daydouble > 1
        for i = 1:daydouble-1
            if ~exist(['data/OBSSBeh_' subinfo.subnum  '_' subinfo.subname 'day' num2str(i) '_data.txt'])
                badfilename = 1;
            end
        end
    end      
end
if debugsync
    Screen('Preference', 'SkipSyncTests', 1);
end
s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);

myscreens = Screen('Screens');
myscreen = max(myscreens);
[w, wRect, centerx, centery] = InitScreens(num2str(myscreen));
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('TextSize',w,24);
Screen('TextColor',w,textcolor);
Screen('TextFont',w,'-sony-fixed-medium-r-normal--24-230-75-75-c-120-iso8859-1');
Screen('FillRect',w,backgroundcolor);

if badfilename
    line = 50;
    linefeed = 50;
    center_text(w,FileNameErrorMsg0,textcolor,line+linefeed*0);
    center_text(w,FileNameErrorMsg1,textcolor,line+linefeed*1);
    center_text(w,FileNameErrorMsg2,textcolor,line+linefeed*2);
    center_text(w,FileNameErrorMsg3,textcolor,line+linefeed*3);
    center_text(w,FileNameErrorMsg4,textcolor,line+linefeed*4);
    center_text(w,FileNameErrorMsg5,textcolor,line+linefeed*5);
    center_text(w,FileNameErrorMsg6,textcolor,line+linefeed*6);
    center_text(w,'press any key to abort session and start over',0,line+linefeed*8);
    Screen('Flip',w);
    KbWait([],3);
    Screen('CloseAll');
    fclose all
end

fixationsize = 10;
fixyoff = -10;
fixxoff = 0;
fixxoff = fixxoff*scale;
fixyoff = fixyoff*scale;
fixx = centerx+fixxoff;
fixy = centery+fixyoff;
fixationcross = [
                 fixx-fixationsize fixx+fixationsize fixx fixx
                 fixy fixy fixy-fixationsize fixy+fixationsize
                 ];
fcolor = 250; 
fixationcolor = [[fcolor;fcolor;fcolor] [fcolor;fcolor;fcolor] [fcolor;fcolor;fcolor] [fcolor;fcolor;fcolor]];

if debugging
    numblocks = 16; %64 x 16 = 1024 trials per session
end
trialsperblock = 64;

penwidth = 1;
fixwidth = 2;

% which stimulus set is trained - each element is a subject
% 1 is horses 2 is humanoids
trainedstimset = [1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 ...
    1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 ...
    1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 ...
    1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 
    ];

% which feature set is category-relevant - each element is a subject
% 1 is features 1 through 3; 2 is features 4 through 6
% this is confounded with stimtypeorder: featset 1 is relevant whenever
% horses are presented first and featset 2 is relevant whenever humans are
% presented first
% some of the variables named eg "stimset" are actually feature set
% coordinates
relevantfeatset = [ 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
    1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
    1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
    1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
    1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 1 1 2 2 ...
    ];

% each column is a run and each row is a subject
% 1 is horse stimuli 2 is humanoid stimuli
stimtypeorder = [1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1
             1 1 2 2 1 1 2 2
             1 1 2 2 1 1 2 2
             2 2 1 1 2 2 1 1
             2 2 1 1 2 2 1 1];
             
% base is codes	(columns 8 and 9 of ttable)
% codes in column 8 are used when dims 1:3 are relevant
% codes in column 9 are used when dimes 4:6 are relevant
%
% first digit of code:
% 1 = mogproto	222 (dimension values)
% 2 = mogNB1	122
% 3 = mogNB2	212
% 4 = mogNB3	221
% 5 = nibproto	111
% 6 = nibNB1	211
% 7 = nibNB2	121
% 8 = nibNB3	112
%
% add a second digit to enumerate exemplars based on irrelevant dimensions:
% for column 8 codes (used if 1:3 are relevant
% 11 = dimensions 1 to 3 are mogproto and dimensions 4 to 6 are mogproto
% 12 = dimensions 1 to 3 are mogproto and dimensions 4 to 6 are mogNB1,
% etc....
% 
% for column 9 codes (used if 4:6 are relevant) (NOTE: ALL YOU HAVE TO DO
% IS SWITCH THE PLACES OF THE DIGITS - TRIPPY!)
% 11 = dimensions 4 to 6 are mogproto and dimensions 1 to 3 are mogproto
% 12 = dimensions 4 to 6 are mogproto and dimensions 1 to 3 are mogNB1,
% etc....

% use the hundreds place to indicate trained vs. untrained set:
% 11 through 88 are trained
% 111 through 188 are untrained


% 190:  relevant features early probe
% 191:  irrelevant features early probe
% 192:  relevant features late probe
% 193:  irrelevant features late probe


% horse dimensions: 
% head legs tail beard body mane
%
% humanoid dimensions:
% legs arms head body wings antennae

ttable = [
     2     2     2     2     2     2    1     1    11    11
     2     2     2     1     2     2    1     2    12    21
     2     2     2     2     1     2    1     3    13    31
     2     2     2     2     2     1    1     4    14    41
     2     2     2     1     1     1    1     5    15    51
     2     2     2     2     1     1    1     6    16    61
     2     2     2     1     2     1    1     7    17    71
     2     2     2     1     1     2    1     8    18    81
     1     2     2     2     2     2    1     9    21    12
     1     2     2     1     2     2    1    10    22    22
     1     2     2     2     1     2    1    11    23    32
     1     2     2     2     2     1    1    12    24    42
     1     2     2     1     1     1    1    13    25    52
     1     2     2     2     1     1    1    14    26    62
     1     2     2     1     2     1    1    15    27    72
     1     2     2     1     1     2    1    16    28    82
     2     1     2     2     2     2    1    17    31    13
     2     1     2     1     2     2    1    18    32    23
     2     1     2     2     1     2    1    19    33    33
     2     1     2     2     2     1    1    20    34    43
     2     1     2     1     1     1    1    21    35    53
     2     1     2     2     1     1    1    22    36    63
     2     1     2     1     2     1    1    23    37    73
     2     1     2     1     1     2    1    24    38    83
     2     2     1     2     2     2    1    25    41    14
     2     2     1     1     2     2    1    26    42    24
     2     2     1     2     1     2    1    27    43    34
     2     2     1     2     2     1    1    28    44    44
     2     2     1     1     1     1    1    29    45    54
     2     2     1     2     1     1    1    30    46    64
     2     2     1     1     2     1    1    31    47    74
     2     2     1     1     1     2    1    32    48    84
     1     1     1     2     2     2    1    33    51    15
     1     1     1     1     2     2    1    34    52    25
     1     1     1     2     1     2    1    35    53    35
     1     1     1     2     2     1    1    36    54    45
     1     1     1     1     1     1    1    37    55    55
     1     1     1     2     1     1    1    38    56    65
     1     1     1     1     2     1    1    39    57    75
     1     1     1     1     1     2    1    40    58    85
     2     1     1     2     2     2    1    41    61    16
     2     1     1     1     2     2    1    42    62    26
     2     1     1     2     1     2    1    43    63    36
     2     1     1     2     2     1    1    44    64    46
     2     1     1     1     1     1    1    45    65    56
     2     1     1     2     1     1    1    46    66    66
     2     1     1     1     2     1    1    47    67    76
     2     1     1     1     1     2    1    48    68    86
     1     2     1     2     2     2    1    49    71    17
     1     2     1     1     2     2    1    50    72    27
     1     2     1     2     1     2    1    51    73    37
     1     2     1     2     2     1    1    52    74    47
     1     2     1     1     1     1    1    53    75    57
     1     2     1     2     1     1    1    54    76    67
     1     2     1     1     2     1    1    55    77    77
     1     2     1     1     1     2    1    56    78    87
     1     1     2     2     2     2    1    57    81    18
     1     1     2     1     2     2    1    58    82    28
     1     1     2     2     1     2    1    59    83    38
     1     1     2     2     2     1    1    60    84    48
     1     1     2     1     1     1    1    61    85    58
     1     1     2     2     1     1    1    62    86    68
     1     1     2     1     2     1    1    63    87    78
     1     1     2     1     1     2    1    64    88    88
    ];
% set stimcodes for BOTH trained and untrained exemplars
% thus what untrained features are considered "relevant"
% will be counterbalanced across subs
if relevantfeatset(subnum) == 1
    mybasecodes = ttable(:,9);
else
    mybasecodes = ttable(:,10);
end

% make things less annoying later
ttable_new = [ttable(:,1:8) mybasecodes];

codes.mogproto = 11:18;
codes.mognb1 = 21:28;
codes.mognb2 = 31:38;
codes.mognb3 = 41:48;
codes.nibproto = 51:58;
codes.nibnb1 = 61:68;
codes.nibnb2 = 71:78;
codes.nibnb3 = 81:88;


horseparts =    {'head1' 'head2'
                 'leg1' 'leg2'
                 'tail1' 'tail2'
                 'beard1' 'beard2'
                 'body1' 'body2'
                 'mane1' 'mane2'
                 'connection' 'connection'};
    humparts =  {'head1' 'head2'
                 'leg1' 'leg2'
                 'tail1' 'tail2'
                 'beard1' 'beard2'
                 'body1' 'body2'
                 'mane1' 'mane2'
                 'connection' 'connection'};

% these are the actual names of the dimensions that the participants see
% since the dimenstions no long correspond to animal parts - JRF jan 2016
horsedims = {'bik' 'drog' 'trill' 'frop' 'lumm' 'zord'};
humdims = {'bik' 'drog' 'trill' 'frop' 'lumm' 'zord'};



% horsexy contains the x y adjustments to move each part away from the
    % center of the screen horsexy{1,1} contains the adjustments for head1

    horsexy = {[-217 -193] [-238 -184] % head
            [246 -3] [244 0] % legs
            [-127 228] [-100 225] % tail
            [126 -223] [112 -220] % beard
            [215 198] [214 190] % body
            [-262 4] [-267 18] % mane
            [0 0] [0 0] %central connection
            };
                   
          
humxy = {[-127 -214] [-142 -198] % head
            [248 -3] [251 12] % legs
            [-190 195] [-197 199] % tail
            [207 -184] [210 -190] % beard
            [142 235] [133 236] % body
            [-257 -8] [-263 10] % mane
            [0 0]     [0 0] %central connection
            };

        
    
        
        
horsexy_labels = {[-210 -210] [-210 -210] % head
            [210 -210] [210 -210] % legs
            [-210 210] [-210 210] % tail
            [180 -280] [180 -280] % beard
            [220 400] [220 400] % body
            [-410 0] [-410 0] % mane
            [0 0] [0 0] %central connection
            };
        
humxy_labels = {[-220 -220] [-220 -220] % head
            [220 260] [260 230] % legs
            [-220 220] [-220 220] % tail
            [300 -270] [300 -270] % beard
            [142 435] [133 436] % body
            [-357 -8] [-363 10] % mane
            [0 0] [0 0] %central connection
            };
      
 
        
        
if trainedstimset(subnum) == 1;
    if relevantfeatset(subnum) == 1
        reldimnames = horsedims(1:3);
%         horsexy_labels = horsexy_labels{1:3,:};
%         humxy_labels = humxy_labels{1:3,:};
        horsexy_labels = horsexy_labels(1:3,:);
        humxy_labels = humxy_labels(1:3,:);
    else
        reldimnames = horsedims(4:6);
%         horsexy_labels = horsexy_labels{4:6,:};
%         humxy_labels = humxy_labels{4:6,:};
        horsexy_labels = horsexy_labels(4:6,:);
        humxy_labels = humxy_labels(4:6,:);
    end
else
    if relevantfeatset(subnum) == 1
        reldimnames = humdims(1:3);
%         horsexy_labels = horsexy_labels{1:3,:};
%         humxy_labels = humxy_labels{1:3,:};
        horsexy_labels = horsexy_labels(1:3,:);
        humxy_labels = humxy_labels(1:3,:);
    else
        reldimnames = humdims(4:6);
%         horsexy_labels = horsexy_labels{4:6,:};
%         humxy_labels = humxy_labels{4:6,:};
        horsexy_labels = horsexy_labels(4:6,:);
        humxy_labels = humxy_labels(4:6,:);
    end
end

if trainedstimset(subnum) == 1
    myset = 'horses';
else
    myset = 'humans';
end
if strcmp(myset,'horses')
    xyadjust = horsexy;
    xyadjust_labels = horsexy_labels;
%         padjust = horseprbxy;
    myparts = horseparts;
else
    xyadjust = humxy;
    xyadjust_labels = humxy_labels;
%         padjust = humprbxy;
    myparts = humparts;

end
stimpath = ['stimuli/' myset '/'];
for stimi = 1:64

    mystim =stimi;
%     clear myrectangles
    thestim = ttable(mystim,1:7);
    stimlines = [];

    for dim = 1:7

        myfile = [stimpath myparts{dim,thestim(dim)} ];
        %disp(myparts{dim,thestim(dim)});
        load(myfile);
        
        
        myxoff = xyadjust{dim,thestim(dim)}(1);
        myyoff = xyadjust{dim,thestim(dim)}(2);

        myxoff = round(myxoff*scale);
        myyoff = round(myyoff*scale);

        xy(1,:) = thePoints(1,1:end);
        xy(2,:) = thePoints(2,1:end);

        % re-center thePoints to  the current screen

        maxx = max(xy(1,:));
        minx = min(xy(1,:));

        maxy = max(xy(2,:));
        miny = min(xy(2,:));
        boxcenterx = round((maxx+minx)/2);
        boxcentery = round((maxy+miny)/2);

        myxy(1,:) = xy(1,:)-boxcenterx;
        myxy(2,:) = xy(2,:)-boxcentery;

        myxy = myxy*scale;

        xy(1,:) = centerx+myxoff+myxy(1,:);
        xy(2,:) = centery+myyoff+myxy(2,:);
        
        % xy and probexy are the coordinates that we will use for each part
        % during stimulus presentation
        save(myfile,'thePoints','xy');

    %         probrects = [probrects theZones];    
    %         stimlines = [stimlines xy];
        clear xy myxy thePoints
    end
end


%     in case we want to inspect the stimuli
%         Screen('FrameRect',w,[],probrects); % draw the zones where the probes will be drawn
%         Screen('DrawLines',w,stimlines,4,[],[],1);
%         Screen('DrawDots',w,allprobes,4,[255;0;0]);
%         Screen('Flip',w);
%         %disp('Waiting');
%         [~,resp] = KbWait([],3);
%         if strcmp(KbName(resp),'q')
%             break
%         end

for stimi = 1:64
    
    mystim = [];
    myprobexy = [];
    for dimi = 1:7
        clear xy 
        load(['stimuli/' myset '/' myparts{dimi,ttable(stimi,dimi)} '.mat'],'xy');
        mystim = [mystim xy];
    end
    mystimuli{stimi} = mystim;
    
end

fprintf(dataFile,'day\ttotaltrials\tblocki\ttriali\tstimnum\tstimcode\tfeedback\tresp\tcorrect\tRT\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(subinfo.day,'1')
    study1();
end

training();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
experimentminutes = (GetSecs - experimentstarttime)/60;
experimenthours = experimentminutes/60;
payment = round(experimenthours*10);

fprintf(['\n\n\nExperimental session took ' num2str(experimentminutes) ' minutes.\n\n\n']);
fprintf(['\n\n\nPayment is ' num2str(payment) ' dollars.\n\n\n']);

Screen('FillRect',w,250);
center_text(w,'You are done!',0,-100);
center_text(w,['Experimental session took ' num2str(experimentminutes) ' minutes.'],0,-50);
center_text(w,['Payment is ' num2str(payment) ' dollars.'],0,0);
center_text(w,'Go get your friendly experimenter.',0,50);
Screen('Flip',w)
if ~debugging
    KbWait([],3);
end

fclose all;
Screen('CloseAll');
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function study1()

global w scale subnum
global ttable_new codes xyadjust xyadjust_labels centerx centery myset relevantfeatset
global penwidth
global reldimnames
global mystimuli
global stimcolor
global debugging textcolor dataFile subinfo daydouble

[pixx pixy] = Screen('WindowSize',w);

line = 50;
linespace = 50;
lmargin = 200;

message1 = 'In this experiment, you will learn to';
message2 = 'categorize imaginary creatures called ''aliens''.';
message3 = 'There are two kinds of aliens: ''Mogs'' and ''Nibs''.';
message4 = 'An alien is a Mog if it has at least TWO OUT OF THREE';
message5 = 'Mog features.';
% message6 = ['Mog ' reldimnames{1} ';   Mog ' reldimnames{2} ';   Mog ' reldimnames{3}];
message7 = 'An alien is a Nib if it has at least TWO OUT OF THREE';
message8 = 'Nib features.';
% message9 = ['Nib ' reldimnames{1} ';   Nib ' reldimnames{2} ';   Nib ' reldimnames{3}];
message9 = 'There are three additional features that you can ignore.';
message10 = 'We will point out the Mog and Nib features that you need to learn.';
message11 = 'On the next screen we will go over some examples.';
message12 = 'Press any key to advance.';

Screen('DrawText',w,message1,lmargin,line+linespace*0);
Screen('DrawText',w,message2,lmargin,line+linespace*1);
Screen('DrawText',w,message3,lmargin,line+linespace*2);
Screen('DrawText',w,message4,lmargin,line+linespace*3);
Screen('DrawText',w,message5,lmargin,line+linespace*4);
% Screen('DrawText',w,message6,lmargin,line+linespace*5);
Screen('DrawText',w,message7,lmargin,line+linespace*6);
Screen('DrawText',w,message8,lmargin,line+linespace*7);
Screen('DrawText',w,message9,lmargin,line+linespace*8);
Screen('DrawText',w,message10,lmargin,line+linespace*9);
Screen('DrawText',w,message11,lmargin,line+linespace*11);
Screen('DrawText',w,message12,lmargin,line+linespace*12);

Screen('Flip',w);
if ~debugging
    KbWait([],3);
end

message_mog = 'This is a Mog. It has:';
message_nib = 'This is a Nib. It has:';

message_mogproto = ['3 MOG features.'];
message_nibproto = ['3 NIB features.'];
message_Mnb1 = ['2 MOG features.'];
message_Mnb2 = ['2 MOG features.'];
message_Mnb3 = ['2 MOG features.'];

message_Nnb1 = ['2 NIB features.'];
message_Nnb2 = ['2 NIB features.'];
message_Nnb3 = ['2 NIB features.'];

if strcmp(myset,'horses') && relevantfeatset(subnum) == 1
    [mtex1 mdrect1] = PrepTex4Loc('stimuli/MogLabel1.BMP',centerx+xyadjust_labels{1,1}(1)*scale+xyadjust{1,1}(1)*scale,centery+xyadjust_labels{1,1}(2)*scale+xyadjust{1,1}(2)*scale,1);
    [mtex2 mdrect2] = PrepTex4Loc('stimuli/MogLabel2.BMP',centerx+xyadjust_labels{2,1}(1)*scale+xyadjust{2,1}(1)*scale,centery+xyadjust_labels{2,1}(2)*scale+xyadjust{2,1}(2)*scale,1);
    [mtex3 mdrect3] = PrepTex4Loc('stimuli/MogLabel3.BMP',centerx+xyadjust_labels{3,1}(1)*scale+xyadjust{3,1}(1)*scale,centery+xyadjust_labels{3,1}(2)*scale+xyadjust{3,1}(2)*scale,1);

    [ntex1 ndrect1] = PrepTex4Loc('stimuli/VecLabel1.BMP',centerx+xyadjust_labels{1,2}(1)*scale+xyadjust{1,2}(1)*scale,centery+xyadjust_labels{1,2}(2)*scale+xyadjust{1,2}(2)*scale,1);
    [ntex2 ndrect2] = PrepTex4Loc('stimuli/VecLabel2.BMP',centerx+xyadjust_labels{2,2}(1)*scale+xyadjust{2,2}(1)*scale,centery+xyadjust_labels{2,2}(2)*scale+xyadjust{2,2}(2)*scale,1);
    [ntex3 ndrect3] = PrepTex4Loc('stimuli/VecLabel3.BMP',centerx+xyadjust_labels{3,2}(1)*scale+xyadjust{3,2}(1)*scale,centery+xyadjust_labels{3,2}(2)*scale+xyadjust{3,2}(2)*scale,1);
elseif strcmp(myset,'horses') && relevantfeatset(subnum) == 2
    [mtex1 mdrect1] = PrepTex4Loc('stimuli/MogLabel1.BMP',centerx+xyadjust_labels{1,1}(1)*scale+xyadjust{1,1}(1)*scale,centery+xyadjust_labels{1,1}(2)*scale+xyadjust{1,1}(2)*scale,1);
    [mtex2 mdrect2] = PrepTex4Loc('stimuli/MogLabel2b.BMP',centerx+xyadjust_labels{2,1}(1)*scale+xyadjust{2,1}(1)*scale,centery+xyadjust_labels{2,1}(2)*scale+xyadjust{2,1}(2)*scale,1);
    [mtex3 mdrect3] = PrepTex4Loc('stimuli/MogLabel3.BMP',centerx+xyadjust_labels{3,1}(1)*scale+xyadjust{3,1}(1)*scale,centery+xyadjust_labels{3,1}(2)*scale+xyadjust{3,1}(2)*scale,1);

    [ntex1 ndrect1] = PrepTex4Loc('stimuli/VecLabel1.BMP',centerx+xyadjust_labels{1,2}(1)*scale+xyadjust{1,2}(1)*scale,centery+xyadjust_labels{1,2}(2)*scale+xyadjust{1,2}(2)*scale,1);
    [ntex2 ndrect2] = PrepTex4Loc('stimuli/VecLabel2b.BMP',centerx+xyadjust_labels{2,2}(1)*scale+xyadjust{2,2}(1)*scale,centery+xyadjust_labels{2,2}(2)*scale+xyadjust{2,2}(2)*scale,1);
    [ntex3 ndrect3] = PrepTex4Loc('stimuli/VecLabel3.BMP',centerx+xyadjust_labels{3,2}(1)*scale+xyadjust{3,2}(1)*scale,centery+xyadjust_labels{3,2}(2)*scale+xyadjust{3,2}(2)*scale,1); 
elseif strcmp(myset,'humans') && relevantfeatset(subnum) == 1
    [mtex1 mdrect1] = PrepTex4Loc('stimuli/MogLabel1.BMP',centerx+xyadjust_labels{1,1}(1)*scale+xyadjust{1,1}(1)*scale,centery+xyadjust_labels{1,1}(2)*scale+xyadjust{1,1}(2)*scale,1);
    [mtex2 mdrect2] = PrepTex4Loc('stimuli/MogLabel2b.BMP',centerx+xyadjust_labels{2,1}(1)*scale+xyadjust{2,1}(1)*scale,centery+xyadjust_labels{2,1}(2)*scale+xyadjust{2,1}(2)*scale,1);
    [mtex3 mdrect3] = PrepTex4Loc('stimuli/MogLabel3.BMP',centerx+xyadjust_labels{3,1}(1)*scale+xyadjust{3,1}(1)*scale,centery+xyadjust_labels{3,1}(2)*scale+xyadjust{3,1}(2)*scale,1);

    [ntex1 ndrect1] = PrepTex4Loc('stimuli/VecLabel1.BMP',centerx+xyadjust_labels{1,2}(1)*scale+xyadjust{1,2}(1)*scale,centery+xyadjust_labels{1,2}(2)*scale+xyadjust{1,2}(2)*scale,1);
    [ntex2 ndrect2] = PrepTex4Loc('stimuli/VecLabel2b.BMP',centerx+xyadjust_labels{2,2}(1)*scale+xyadjust{2,2}(1)*scale,centery+xyadjust_labels{2,2}(2)*scale+xyadjust{2,2}(2)*scale,1);
    [ntex3 ndrect3] = PrepTex4Loc('stimuli/VecLabel3.BMP',centerx+xyadjust_labels{3,2}(1)*scale+xyadjust{3,2}(1)*scale,centery+xyadjust_labels{3,2}(2)*scale+xyadjust{3,2}(2)*scale,1); 
elseif strcmp(myset,'humans') && relevantfeatset(subnum) == 2
    [mtex1 mdrect1] = PrepTex4Loc('stimuli/MogLabel1b.BMP',centerx+xyadjust_labels{1,1}(1)*scale+xyadjust{1,1}(1)*scale,centery+xyadjust_labels{1,1}(2)*scale+xyadjust{1,1}(2)*scale,1);
    [mtex2 mdrect2] = PrepTex4Loc('stimuli/MogLabel2b.BMP',centerx+xyadjust_labels{2,1}(1)*scale+xyadjust{2,1}(1)*scale,centery+xyadjust_labels{2,1}(2)*scale+xyadjust{2,1}(2)*scale,1);
    [mtex3 mdrect3] = PrepTex4Loc('stimuli/MogLabel3.BMP',centerx+xyadjust_labels{3,1}(1)*scale+xyadjust{3,1}(1)*scale,centery+xyadjust_labels{3,1}(2)*scale+xyadjust{3,1}(2)*scale,1);

    [ntex1 ndrect1] = PrepTex4Loc('stimuli/VecLabel1b.BMP',centerx+xyadjust_labels{1,2}(1)*scale+xyadjust{1,2}(1)*scale,centery+xyadjust_labels{1,2}(2)*scale+xyadjust{1,2}(2)*scale,1);
    [ntex2 ndrect2] = PrepTex4Loc('stimuli/VecLabel2b.BMP',centerx+xyadjust_labels{2,2}(1)*scale+xyadjust{2,2}(1)*scale,centery+xyadjust_labels{2,2}(2)*scale+xyadjust{2,2}(2)*scale,1);
    [ntex3 ndrect3] = PrepTex4Loc('stimuli/VecLabel3.BMP',centerx+xyadjust_labels{3,2}(1)*scale+xyadjust{3,2}(1)*scale,centery+xyadjust_labels{3,2}(2)*scale+xyadjust{3,2}(2)*scale,1); 
end

trainingcases(1).message{1} = message_mog;
trainingcases(1).message{2} = message_mogproto;
trainingcases(1).codes = codes.mogproto;
trainingcases(1).tex = {mtex1 mtex2 mtex3};
trainingcases(1).drect = {mdrect1 mdrect2 mdrect3};

trainingcases(2).message{1} = message_mog;
trainingcases(2).message{2} = message_Mnb1;
trainingcases(2).codes = codes.mognb1;
trainingcases(2).tex = {ntex1 mtex2 mtex3};
trainingcases(2).drect = {ndrect1 mdrect2 mdrect3};

trainingcases(3).message{1} = message_mog;
trainingcases(3).message{2} = message_Mnb2;
trainingcases(3).codes = codes.mognb2;
trainingcases(3).tex = {mtex1 ntex2 mtex3};
trainingcases(3).drect = {mdrect1 ndrect2 mdrect3};

trainingcases(4).message{1} = message_mog;
trainingcases(4).message{2} = message_Mnb3;
trainingcases(4).codes = codes.mognb3;
trainingcases(4).tex = {mtex1 mtex2 ntex3};
trainingcases(4).drect = {mdrect1 mdrect2 ndrect3};

trainingcases(5).message{1} = message_nib;
trainingcases(5).message{2} = message_nibproto;
trainingcases(5).codes = codes.nibproto;
trainingcases(5).tex = {ntex1 ntex2 ntex3};
trainingcases(5).drect = {ndrect1 ndrect2 ndrect3};

trainingcases(6).message{1} = message_nib;
trainingcases(6).message{2} = message_Nnb1;
trainingcases(6).codes = codes.nibnb1;
trainingcases(6).tex = {mtex1 ntex2 ntex3};
trainingcases(6).drect = {mdrect1 ndrect2 ndrect3};

trainingcases(7).message{1} = message_nib;
trainingcases(7).message{2} = message_Nnb2;
trainingcases(7).codes = codes.nibnb2;
trainingcases(7).tex = {ntex1 mtex2 ntex3};
trainingcases(7).drect = {ndrect1 mdrect2 ndrect3};

trainingcases(8).message{1} = message_nib;
trainingcases(8).message{2} = message_Nnb3;
trainingcases(8).codes = codes.nibnb3;
trainingcases(8).tex = {ntex1 ntex2 mtex3};
trainingcases(8).drect = {ndrect1 ndrect2 mdrect3};





for casei = 1:8
    coin = randperm(8);
    whichcode = coin(1);
    mystimnum = ttable_new(ttable_new(:,9) == trainingcases(casei).codes(whichcode),8);
    Screen('DrawText',w,trainingcases(casei).message{1},lmargin,line+linespace*0);
    Screen('DrawText',w,trainingcases(casei).message{2},lmargin,line+linespace*1);
    Screen('DrawText',w,'Press any key to continue to another example',lmargin,line+linespace*2);
    
    Screen('DrawTexture',w,trainingcases(casei).tex{1},[],trainingcases(casei).drect{1});
    Screen('DrawTexture',w,trainingcases(casei).tex{2},[],trainingcases(casei).drect{2});
    Screen('DrawTexture',w,trainingcases(casei).tex{3},[],trainingcases(casei).drect{3});
    Screen('DrawLines',w,mystimuli{mystimnum},penwidth,stimcolor,[],1);
    Screen('Flip',w);
    if ~debugging
        KbWait([],3);
    end

end

message1 = 'Now you can flip through all of the examples';
message2 = 'at your own pace.';
message3 = 'Press ''F'' to move forward in the list.';
message4 = 'Press ''B'' to move back in the list.';

Screen('DrawText',w,message1,lmargin,line+linespace*0);
Screen('DrawText',w,message2,lmargin,line+linespace*1);
Screen('DrawText',w,message3,lmargin,line+linespace*2);
Screen('DrawText',w,message4,lmargin,line+linespace*3);
Screen('DrawText',w,'When you think you know what the Mog and Nib',lmargin,line+linespace*4);
Screen('DrawText',w,'features look like, you can quit and try some training.',lmargin,line+linespace*5);
Screen('DrawText',w,'You will be able to come back to this later.',lmargin,line+linespace*6);
Screen('DrawText',w,'Press any key to start',lmargin,line+linespace*8);

Screen('Flip',w);
if ~debugging
    KbWait([],3);
end

coin = randperm(8);
casei = coin(1);
coin = randperm(8);
exemplari = coin(1);
legalresponses = {'F' 'B' 'Q'};
totaltrials = 1;
while 1
    
    whichcode = exemplari;
    mystimnum = ttable_new(ttable_new(:,9) == trainingcases(casei).codes(whichcode),8);
    Screen('DrawText',w,trainingcases(casei).message{1},lmargin,line+linespace*0);
    Screen('DrawText',w,trainingcases(casei).message{2},lmargin,line+linespace*1);
    Screen('DrawText',w,'Press ''F'' for forward ''B'' for back. ''Q'' to quit.',lmargin,line+linespace*2);
    center_text(w,trainingcases(casei).message{2},textcolor,pixy/4);
    
    Screen('DrawTexture',w,trainingcases(casei).tex{1},[],trainingcases(casei).drect{1});
    Screen('DrawTexture',w,trainingcases(casei).tex{2},[],trainingcases(casei).drect{2});
    Screen('DrawTexture',w,trainingcases(casei).tex{3},[],trainingcases(casei).drect{3});
    Screen('DrawLines',w,mystimuli{mystimnum},penwidth,stimcolor,[],1);
    Screen('Flip',w);
    if ~debugging
        response = 'none';
        while ~ismember(response,legalresponses)
            
            [~,keyCode,~] = KbWait([],3);
            response = upper(KbName(keyCode));
            
        end
    end
    
    if strcmpi(response,'F')
        casei = casei+1;
        if casei > 8
            casei = 1;
            exemplari = exemplari+1;
            if exemplari > 8
                exemplari = 1;
            end
        end
    elseif strcmpi(response,'B')
        casei = casei-1;
        if casei < 1;
            casei = 8;
            exemplari = exemplari-1;
            if exemplari < 1
                exemplari = 8;
            end
        end
    elseif strcmpi(response,'Q')
        break
    end
    totaltrials = totaltrials+1;
    fprintf(dataFile,'selfpaced\t%s\t%i\t%i\t%i\t%i\t%i\t%s\t%s\t%i\t%f\n',...
        subinfo.day,totaltrials,0,0,mystimnum,0,'none','none',0,0);
end

function training()
global w wRect centerx centery subinfo dataFile daydouble
global ttable ttable_new codes mybasecodes
global relevantfeatset
global trainedstimset
global fixyoff fixxoff fixx fixy fixationcross fcolor fixationcolor penwidth fixwidth
global fixdur stimdur ITI preblockInt fbdur ITI2
global horseparts humparts horsexy humxy horsedims humdims reldimnames
global mystimuli
global stimcolor
global debugging debugging1
global numblocks
global nbut mbut pausekey
global textcolor mywrap

line = 50;
linespace = 50;
lmargin = 200;



if daydouble > 2
    text = ['To help speed things up, we will only give negative feedback.\n\n' ...
        'If you receive no feedback after a given trial, it means you got it right.\n\n' ...
        'As always, press ' upper(mbut) ' for MOG and ' upper(nbut) ' for NIB\n\n' ...
        'Press any key to begin.'
        ];
    
else
    text = ['In this task, you will practice categorizing Mogs and Nibs.\n\n' ...
        'After each alien appears, press ' upper(mbut) ' for MOG and ' upper(nbut) ' for NIB\n\n'...
        'Respond as accurately as you can. Do not rush your response, but respond as soon as you know the answer.\n\n'...
        'Press any key to begin.'
        ];
end

DrawFormattedText(w, text, 'center', 100, [], mywrap,[],[],1.63);
Screen('Flip',w);
if ~debugging
    KbWait([],3);
end


totaltrials = 1;
for blocki = 1:numblocks
    
    if blocki>1
        message1 = ['You have now completed ' num2str(blocki-1) ' out of ' num2str(numblocks) ' blocks'];
        message2 = 'Press ''G'' to continue training or';
        message3 = '''B'' to go back to looking through the aliens';
        message4 = 'at your own pace';
        Screen('DrawText',w,message1,lmargin,line+linespace*0);
        Screen('DrawText',w,message2,lmargin,line+linespace*1);
        Screen('DrawText',w,message3,lmargin,line+linespace*2);
        Screen('DrawText',w,message4,lmargin,line+linespace*3);
        Screen('Flip',w);
        resp = 'none';
        if ~debugging
            while ~strcmpi(resp,'G') && ~strcmpi(resp,'B')
                [~,keyCode] = KbWait([],3);
                resp = KbName(keyCode);
            end
        else
            resp = 'G';
        end
        
        if strcmpi(resp,'B')
            study1();
            Screen('DrawText',w,'Press any key to continue',lmargin,line+linespace*0);
            Screen('Flip',w);
            if ~debugging
                KbWait([],3);
            end
        end
    end
    
    order = randperm(64);
    WaitSecs(preblockInt);
    
    
    for triali = 1:64
        
        badpress = 0;
        Screen('DrawLines',w,fixationcross,fixwidth,fixationcolor,[],1);
        Screen('Flip',w);
        WaitSecs(fixdur);
        Screen('DrawLines',w,mystimuli{order(triali)},penwidth,stimcolor,[],1);
%         Screen('DrawLines',w,fixationcross,fixwidth,fixationcolor,[],1);
        [~,startrt] = Screen('Flip',w);
        [resp, RT, presscounter] = Listen4Resp(stimdur,startrt,pausekey);
        if ~presscounter
            [resp, RT, presscounter] = Listen4Resp(0,startrt,pausekey);
        end
        if presscounter && (~strcmpi(resp,mbut) && ~strcmpi(resp,nbut))
            badpress = 1;
            center_text(w,'You pressed an incorrect key.',textcolor,-50);
            center_text(w,['Please press ' upper(mbut) ' for Mog and ' upper(nbut) ' for Nib.'],textcolor,0);
            center_text(w,'Press spacebar to continue.',textcolor,+50);
            Screen('Flip',w);
            if ~debugging
                KbWait([],3);
            end
        end
        
        if strcmpi(resp,mbut) && order(triali)<33
            correct = 1;
        elseif strcmpi(resp,nbut) && order(triali)>32
            correct = 1;
        else
            correct = 0;
        end
        
        feedback = 'none';
        if ~badpress
            if daydouble > 2
                if correct
%                     if order(triali)<33
%                         feedback = 'Mog';
%                         center_text(w,'Correct: Mog',textcolor,0);
%                     else
%                         feedback = 'Nib';
%                         center_text(w,'Correct: Nib',textcolor,0);
%                     end
                elseif ~correct
                    if order(triali)<33
                        feedback = 'Mog';
                        center_text(w,'Incorrect: Mog',textcolor,0);
                    else
                        feedback = 'Nib';
                        center_text(w,'Incorrect: Nib',textcolor,0);
                    end 
                    Screen('Flip',w);
                    WaitSecs(fbdur);
                end
                
            else
                if correct
                    if order(triali)<33
                        feedback = 'Mog';
                        center_text(w,'Correct: Mog',textcolor,0);
                    else
                        feedback = 'Nib';
                        center_text(w,'Correct: Nib',textcolor,0);
                    end
                    
                elseif ~correct
                    if order(triali)<33
                        feedback = 'Mog';
                        center_text(w,'Incorrect: Mog',textcolor,0);
                    else
                        feedback = 'Nib';
                        center_text(w,'Incorrect: Nib',textcolor,0);
                    end 
                end
                Screen('Flip',w);
                WaitSecs(fbdur);
            end
            
        end
        Screen('Flip',w);
        if daydouble <=2
            WaitSecs(ITI);
        else
            WaitSecs(ITI2)
        end
        
        fprintf(dataFile,'training\t%s\t%s\t%i\t%i\t%i\t%i\t%i\t%s\t%s\t%i\t%f\n',subinfo.day,subinfo.date,totaltrials,blocki,triali,ttable_new(order(triali),7),ttable_new(order(triali),8),feedback,resp,correct,RT);
        totaltrials = totaltrials+1;
    end

end




% HELPER FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function GetParticipantInfo_v2(expname,varargin)

% Get some data about the participant
% Outputs data to a struct called subinfo
% always asks for participants initials, number, and the date
% asks for additional variables that are entered as strings
% e.g. [datafile logfile subinfo] = GetParticipantInfo('TrainingSession','age')
%     will ask for a Training session and the participants age.
% All optional inputs must be a single string with no white space
% All output will be strings, but subject number must be a digit with no
% accompanying text i.e. 13 and not subnum13
% Finally, the participant's name and number are used to name a data output
% file and a logfile with a name that is unique to that participant

global dataFile subinfo

while 1
    prompt={'sub initials','sub number','date',varargin{:}}; 
    defaults={'DELETEME', '1', 'enter date','','16'};
    answer=inputdlg(prompt,'Run experiment',1,defaults);
%     eval(['[subname, subjectnum, date,' varargin{:} ']=deal(answer{:});']);
    subjectnum = answer{2};
    subinfo.subnum = answer{2};
    subinfo.subname = upper(answer{1});
    subinfo.date = answer{3};
    for i = 1:numel(varargin)
        for j = 1:length(varargin{i})
            if strcmp(varargin{i}(j),' ')
                varargin{i}(j) = '_';
            end
        end
        
        eval(['subinfo.' varargin{i} ' = answer{i+3};']);
    end
    myfields = fieldnames(subinfo);
    
    dfileName = ['data/' expname '_' subjectnum  '_' subinfo.subname];
    if numel(varargin) > 0
        for fieldi = 4:numel(answer)
            dfileName = [dfileName '_' myfields{fieldi} answer{fieldi}];
        end
    end
    
   
    dfileName = [dfileName '_data.txt'];
                
    if ~exist('data')
        mkdir('data');
    end

    if exist(dfileName)~=0
        button=questdlg(['Overwrite ' dfileName '? ANSWER USUALLY NO!!!']);
        if strcmp(button,'Yes'); break; end
    elseif isnan(str2double(subinfo.subnum))
        uiwait(msgbox('Enter only digits for the sub number','Title','modal'));
    else
        break
    end

end
dataFile = fopen(dfileName,'w');
for fieldi = 1:numel(myfields)
    eval(['fprintf(dataFile,''headerinfo %s:\t%s\n'',myfields{fieldi},subinfo.' myfields{fieldi} ');']);
end

function InitExperiment()
% clear all variables
% close all open files
% Close all open windows and textures
% bring the commandwindow to the front of the screen
% make KbName is mac osx key names


fclose all;
Screen('CloseAll');
% commandwindow; %commandwindow crashes compiled scripts
KbName('UnifyKeyNames');

function [w, wRect, centerx, centery] = InitScreens(varargin)


% Open a PTB window on one of the screens and make it available to the rest
% of the PTB script also output the x y coordinates of screen center

screens=Screen('Screens');
if numel(varargin) == 0
    screenNumber=max(screens);
elseif isnan(str2double(varargin{1}))
    error('To specify a screen number, enter a digit in the form of a string');
else
    screenNumber = str2double(varargin{1});
    if screenNumber > max(screens)
        error('screen number too big');
    end
end

[w wRect]=Screen('OpenWindow',screenNumber);
[centerx,centery] = RectCenter(wRect);

function center_text(ptr,ctext,tcolor,yoffset)

if nargin<2; error('%%Usage: center_text(ptr,text,[color],[yoffset])')
elseif nargin<3; yoffset=0; tcolor=255;
elseif nargin<4; yoffset=0; 
end

rect=Screen('Rect',ptr); %%size of window
sx = RectWidth(rect); %width
sy = RectHeight(rect); %height

tw=Screen('TextBounds',ptr,ctext);
Screen('DrawText',ptr,ctext,round(sx/2)-round(tw(3)/2),...
    round(sy/2)+yoffset,tcolor);

function [resp RT presscounter] = Listen4Resp(duration,startrt,pausekey)
% duration: how long to listen for a resp in seconds
% IF duration = 0, listens until a response is detected or 10 seconds,
% whichever comes first
%starttime is when to start the listening clock, usually the stimulus onset
%recorded by Screen('Flip');
% pausekey is a special key to pause the experiment
% if times out with no key press, resp == 'none' and RT == NaN (not a number);

deadline = 10; %prevent the while loop from going for too long and crashing matlab

presscounter = 0;
paused = 0;

if duration > 0
    while GetSecs-startrt <= duration
        [KeyIsDown, endrt, KeyCode]=KbCheck;
            if KeyIsDown && ~presscounter                       
                RT = endrt-startrt;
                resp = KbName(KeyCode);
                presscounter = 1;
                if strcmp(resp,pausekey)
                    center_text(w,'Experiment is paused.',0,-200);
                    center_text(w,'Please do not press any keys.',0,-150);
                    Screen('Flip',w);
                    paused = 1;
                    KbWait([],2);
                end
            end
    end
elseif duration == 0
    while GetSecs-startrt <= deadline
       [KeyIsDown, endrt, KeyCode]=KbCheck;
            if KeyIsDown
                RT = endrt-startrt;
                resp = KbName(KeyCode);
                presscounter = 1;
                if strcmp(resp,pausekey)
                    center_text(w,'Experiment is paused.',0,-200);
                    center_text(w,'Please do not press any keys.',0,-150);
                    Screen('Flip',w);
                    paused = 1;
                    KbWait([],2);
                end
                break
            end
    end 
else
    error('stimulus duration is less than zero');
end

if ~presscounter 
    resp = 'none';
    RT = NaN;
end
if iscell(resp)
    resp = resp{1}(1);
end

function [tex drect] = PrepTex4Loc(filename,destx,desty,scale)

% filename: the name of a file (a string), including the path to the file
% destx: the x coordinate of where you want the image to be on the screen
% desty: the y coord of where to want the image
% scale: number greater than zero. For original size of the image file, put
% 1.  2 is double the size. .5 is shrunk by half, etc.

global w

st = imread(filename); 
stim = imresize(st,scale);
tex = Screen('MakeTexture',w,stim);
r1 = Screen('Rect',tex);
drect = CenterRectOnPoint(r1,destx,desty);






