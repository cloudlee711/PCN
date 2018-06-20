clear all;
load('.\datademon\image.mat');
load('.\datademon\voice.mat');

%--------------------------------------------------------------------------
% for demon: generate sample input sequence, divide=88, 10 classes of objects 
% learned first, then 10 remaining classes of objects learned, i.e., open-ended
% learning environment; divide=176, 20 classes of objects learned in one
% time, i.e., closed learning environment; 
samplenum=size(image,2);
divide=176;
for i=1:samplenum/divide
    base=randperm(divide);
    sequence((i-1)*divide+1:i*divide)=divide*(i-1)+base;
end

image=image(sequence);
voice=voice(sequence);
%--------------------------------------------------------------------------
global channlename;
global inputimage;
global inputvoice;
global syllableConceptNeuron;
global syllableconnection;
global wordConceptNeuron;
global viewConceptNeuron;
global outlineConceptNeuron;
global outlineconnection;
global colorConceptNeuron;
global colorconnection;
global associatedNeuron;
global connection;
global associatedconnection;
global colorandviewconnection; 
global outlineandviewconnection;
global syllableandwordconnection;
global syllableandwordconnectionact;

channlename={'view','word','taste','touch','smell'};

colorConceptNeuron=[];
colorconnection=[];
firingColorNeuron=0;

outlineConceptNeuron=[];
outlineconnection=[];
firingOutlineNeuron=0;

syllableConceptNeuron=[];
syllableconnection=[];
firingSyllables=[];

viewConceptNeuron=[];
colorandviewconnection=[];
outlineandviewconnection=[];


wordConceptNeuron=[];
syllableandwordconnection=[];
syllableandwordconnectionact=[];

associatedNeuron=[];

for i=1:size(channlename,2)-1
    for j=i+1:size(channlename,2)
        associatedconnection.([channlename{i},'and', channlename{j}])=[];
    end
end
connection=[];

fs=8000;
containersize=0.05;
outlinethreshold=4;
colorthreshold=4;
syllablethreshold=200;
%--------------------------------------------------------------------------
% start the PCN learning
questionnm=0;
for trail=1:176
    trail
    inputimage=image(trail).data;
    inputvoice=voice(trail).data;
    inputvoicelabel=voice(trail).label;
    %----------------------------------------------------------------------
    % image channle
    % extract outline feature
    [NFD FD boundary bimage contr]=outline(inputimage);
    % extract color feature
    [CH gg image2]=colorhistogram(bimage,containersize,inputimage);
    % construct outline feature network
    [outlineConceptNeuron firingOutlineNeuron outlineconnection] = outlinefeaturemap (outlineConceptNeuron,NFD,FD,outlineconnection,outlinethreshold);
    % construct color feature network
    [colorConceptNeuron firingColorNeuron colorconnection] = colorfeaturemap (colorConceptNeuron,CH,colorconnection,colorthreshold);
    % construct visual primary concept
    [colorandviewconnection, outlineandviewconnection, viewfiringsignal] = OIDSconceptgenerate ( firingOutlineNeuron, firingColorNeuron, ...
    colorandviewconnection, outlineandviewconnection);

    %----------------------------------------------------------------------
    % voice channel
    % extract syllable and feature
    [syllable mfcc]=voice2syllable(inputvoice,inputvoicelabel,fs); 
    % construct syllabel feature network
    [syllableConceptNeuron firingSyllables syllableconnection difference] = syllablefeaturemap (syllableConceptNeuron,mfcc,syllableconnection, syllablethreshold);
    differencett{trail}=difference;
    % construct auditory primary concept
    [syllableandwordconnection, syllableandwordconnectionact, wordfiringsignal] = ODSconceptgenerate (firingSyllables, ...
        syllableandwordconnection, syllableandwordconnectionact);
    %----------------------------------------------------------------------   
    % associated  
    associatedcortex (viewfiringsignal, wordfiringsignal, NFD, FD, mfcc, firingOutlineNeuron, firingColorNeuron, difference);
    
    %----------------------------------------------------------------------
end
% show the results
for i=1:size(associatedNeuron,2)
    p=1;
    figure(i);
    for j=1:size(associatedNeuron(i).view,2)
        for k=1:size(viewConceptNeuron(associatedNeuron(i).view(j)).color,2)
            subplot(5,5,p)
            plot(ifft(outlineConceptNeuron(viewConceptNeuron(associatedNeuron(i).view(j)).outline).FD), 'color', ...
                colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron(associatedNeuron(i).view(j)).color(k)).data,0.05),'linewidth',7);
            p=p+1;
        end
        str=[num2str(i)];
        for j=1:size(associatedNeuron(i).word,2)
            str=[str syllableConceptNeuron(wordConceptNeuron(associatedNeuron(i).word(j)).order).label];
        end
        title(str);
    end
end
