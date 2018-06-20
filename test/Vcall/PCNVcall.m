clear all;
load('image.mat')
load('..\..\testresult\result3.mat');

global outlineConceptNeuron;
global colorConceptNeuron;
global viewConceptNeuron;
global associatedNeuron;

containersize=0.05;

%----------------------------------------------------------------------------------------------
index = 1; % your image index here (now from 1 to 176 here becasue we give 176 test images now)
%----------------------------------------------------------------------------------------------

inputimage=image(index).data;
% extract outline feature
[NFD FD boundary bimage]=outline(inputimage);
% extract color feature
[CH]=colorhistogram(bimage,containersize,inputimage);
% construct outline feature network
[outlineConceptNeuron firingOutlineNeuron] = outlinefiring (outlineConceptNeuron,NFD);
% construct color feature network
[colorConceptNeuron firingColorNeuron] = colorfiring (colorConceptNeuron,CH);
% construct visual primary concept
firingOutlineNeuronindex=find(firingOutlineNeuron==1);
[colorandviewconnection, outlineandviewconnection, viewfiringsignal] = OIDSconceptfiring ( firingOutlineNeuron, ...
    colorandviewconnection, outlineandviewconnection);
% associated
[wordcalled] = associatedcortexcall (viewfiringsignal);
str=['You word recall is ' syllableConceptNeuron(wordConceptNeuron(wordcalled).order).label];
display(str);
figure(1);
imshow(image(index).data);
set(gcf,'Name','Current input image');