clear all;
load('voice.mat');
load('..\..\testresult\result3.mat');

global inputvoice;
global syllableConceptNeuron;
global viewConceptNeuron;
global outlineConceptNeuron;
global colorConceptNeuron;


fs=8000;
%----------------------------------------------------------------------------------------------
index = 1; % your voice index here (now from 1 to 176 here becasue we give 176 test voices now)
%----------------------------------------------------------------------------------------------
% voice channel
% extract syllable and feature
inputvoice=voice(index).data;
[syllable mfcc]=voice2syllable(inputvoice,fs);
% construct syllabel feature network
[firingSyllables] = syllablefeaturemap (syllableConceptNeuron,mfcc);
% construct auditory primary concept
[wordfiringsignal] = ODSconceptfiring (firingSyllables);

% associated
[viewcalled] = associatedcortexcall (wordfiringsignal);
    

p=1;
figure('NumberTitle', 'off', 'Name', 'The view called by input voice');
% play current input voice
audio = audioplayer(inputvoice,fs);
play(audio);
for i=1:size(viewcalled,2)
    for j=1:size(viewConceptNeuron(viewcalled(i)).color,2)
        subplot(5,5,p)
        plot(ifft(outlineConceptNeuron(viewConceptNeuron(viewcalled(i)).outline).FD), 'color', ...
            colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron(viewcalled(i)).color(j)).data,0.05),'linewidth',7);
        p=p+1;
    end
end

