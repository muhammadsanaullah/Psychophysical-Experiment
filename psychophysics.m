
%clear all; %Emptying workspace
close all; %Closing all figures
temp = uint8(zeros(400,400,3)); %Create a dark stimulus matrix
temp1 = cell(10,2); %Create a cell that can hold 10 matrices

brighter = []; %lef = 10*randperm(9); lef = [lef 0];
rb = []; ra = [];
abs_t = 25.7; 
% rb = 10*randperm(9); rb = [rb(1:1) 0 rb(2:end)]; 
% ra = []; temp_rb = rb;
% for e = 1:numel(temp_rb)
%     pos = randi([1 numel(temp_rb)]);
%     ra = [ra temp_rb(pos)];
%     temp_rb(pos) = [];
% end


% we keep iterating until we get different brightness levels for each point
% condition = ra==rb; 
% 
% while (sum(condition) > 0)
%     ra = []; rb = [];
%     ra = 10*randperm(9); rb = 10*randperm(9); 
%     rb = [rb(1:1) 0 rb(2:end)]; ra = [ra(1:2) 0 rb(4:end)];
%     condition = ra==rb;
% end

for i = 1:10 %Filling temp1
    % : for white, 1 for red, 2 for green, 3 for blue
    % fixation point
    temp(200,200,:) = 255; 
    
    % comparison point on the left (relative threshold)
    b = abs_t + (90 - abs_t)/2;%lef(i);
    %b = rb(i);
    temp(200,160,:) = b; 
    
    % target point on the right (absolute threshold)
    a = abs_t + (i - 1)*((90 - abs_t)/10);
    %a = ra(i);
    temp(200,240,:) = a; 
    
%     if (i < 6)
%         % comparison point on the left (relative threshold)
%         b = abs_t + (90 - abs_t)/2;%lef(i);
%         %b = rb(i);
%         temp(200,160,:) = b; 
%     
%         % target point on the right (absolute threshold)
%         a = abs_t + (i - 1)*((b - abs_t)/div);
%         %a = ra(i);
%         temp(200,240,:) = a;  
%     end
%     if (i >= 6)
%         
%         % target point on the right (absolute threshold)
%         a = 90 - abs_t;
%         %a = ra(i);
%         temp(200,240,:) = abs_t + a/2;
%         
%         % comparison point on the left (relative threshold)
%         b = abs_t + (i - 1)*(b/div);%lef(i);
%         %b = rb(i);
%         temp(200,160,:) =  b;
%     
%     end
        

    
    if (a > b)
        temp1{i,2} = 1;
    end
    if (a <= b)
        temp1{i,2} = 0;
    end
    
    rb = [rb b];
    ra = [ra a];
    %brightness_diff = [brightness_diff abs(a-b)];
    
    %Inserting a test point 40 pixels right of it. Brightness range 0 to 90.
    temp1{i,1} = temp; %Putting the respective modified matrix in cell
end %Done doing that


h = figure; %Creating a figure with a handle h
stimulusorder = randperm(200); %Creating a random order from 1 to 200.
%For the 200 trials. Allows to have
%a precisely equal number per condition.
stimulusorder = mod(stimulusorder,10); %Using the modulus function to
%create a range from 0 to 9. 20 each.
stimulusorder = stimulusorder + 1; %Now, the range is from 1 to 10, as
%desired.
score3 = zeros(10,1); %Keeping score. How many stimuli were reported seen

for i = 1:20 %200 trials, 20 per condition
    image(temp1{stimulusorder(1,i),1}) %Image the respective matrix. As
    %designated by stimulusorder
    i; %Give subject feedback about which trial we are in. No other feedback.
    pause; %Get the keypress
    temp2 = get(h,'CurrentCharacter'); %Get the keypress. "." for present,
    %"," for absent.
    
    %for absolute threshold:
    %temp3 = strcmp('.', temp2);
    
    %for relative threshold:
    temp3 = strcmp('.', temp2); %Compare strings. If . (present), temp3 = 1 otherwise 0.
    
    if (temp1{stimulusorder(1,i),2} == 1 && temp3 == 1)
        %Add up in the respective score sheet.
        score3(stimulusorder(1,i)) = score3(stimulusorder(1,i)) + 1; 
    end
    if (temp1{stimulusorder(1,i),2} == 0 && temp3 == 0)
        score3(stimulusorder(1,i)) = score3(stimulusorder(1,i)) + 0;
    end
        
end %End the presentation of trials, after 200 have lapsed.

% plotting scores as a probabilistic curve
%plot(0:10:90, score/20);
%xlim([0 90]); ylim([0 1]);

close all; 

% sorting and post-processing for relative thresholds
brightness_diff = abs(ra - rb);
brightness_diff = round(brightness_diff);
[brightness_diff, sortId] = sort(brightness_diff,'ascend'); 
score3 = score3(sortId);

u = unique(brightness_diff);
n = histc(brightness_diff,u);
tempscore = []; avg = 0; var = 1;
for i = 1:1:numel(u)
    for j = 1:1:n(i)
        avg = avg + score3(var);
        var = var + 1;
    end
    avg = avg/(n(i));
    tempscore = [tempscore avg];
    avg = 0;
end


        
%elements = find(ismember(brightness_diff, u(n > 1)));

% weber fraction = relative change / original value

