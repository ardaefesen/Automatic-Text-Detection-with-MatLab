%Arda Efe ÞEN 201611053

%Clear workspace
clear all
close all

%Step1
Image = imread('sample4.jpg');
Image = imresize(Image,[800,800]);
figure;
imshow(Image);
I = rgb2gray(Image);

% Detecting text regions with MSER.
[TextRegions, textConnComp] = detectMSERFeatures(I, ... 
    'RegionAreaRange',[200 8000],'ThresholdDelta',4);

figure
imshow(I)
hold on
plot(TextRegions, 'showPixelList', true,'showEllipses',false)
title('Text Regions')
hold off


%Step2 

 TextStats = regionprops(textConnComp);


% Get bounding textboxes for all the regions
textboxes = vertcat(TextStats.BoundingBox);


% xmin ymin xmax ymax for x = width y = height
xmin = textboxes(:,1);
ymin = textboxes(:,2);
xmax = xmin + textboxes(:,3) - 1;
ymax = ymin + textboxes(:,4) - 1;

% Expand the bounding textboxes. expansion amount should be small.
amount = 0.02;
xmin = (1-amount) * xmin;
ymin = (1-amount) * ymin;
xmax = (1+amount) * xmax;
ymax = (1+amount) * ymax;


% Show the expanded bounding textboxes
expandedTextBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
ImageExpanded = insertShape(Image,'Rectangle',expandedTextBoxes,'LineWidth',3);

figure
imshow(ImageExpanded)
title('TextBoxes')


%Step3
% Computing overlap ratio OR
OR = bboxOverlapRatio(expandedTextBoxes, expandedTextBoxes);



% Creating the graph
g = graph(OR);

% Find the connected text regions with conncomp
Indices = conncomp(g);


% Merge process the boxes.
xmin = accumarray(Indices', xmin, [], @min);
ymin = accumarray(Indices', ymin, [], @min);
xmax = accumarray(Indices', xmax, [], @max);
ymax = accumarray(Indices', ymax, [], @max);


% Highligthing process
textBoundBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
ImageHigh = insertShape(Image, 'FilledRectangle', textBoundBoxes,'LineWidth',3);

figure
imshow(ImageHigh)
title('Highligthing Text')




















% %Highlighting specific area in the text.
% 
% Img = imread('sample3.jpg');
% Img = imresize(Img,[800,800]);
% ocrResults = ocr(Img);
% 
%  Image = insertObjectAnnotation(Img, 'rectangle', ...
%                            ocrResults.WordBoundingBoxes, ...
%                            ocrResults.WordConfidences);
%      figure; 
%      imshow(Image);
%      
% textboxes = locateText(ocrResults,'leave','IgnoreCase', true);
% Image = insertShape(Image, 'FilledRectangle', textboxes);
% figure; 
% imshow(Image);




