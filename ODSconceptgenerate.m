function [syllableandwordconnection, syllableandwordconnectionact, wordfiringsignal] = ODSconceptgenerate (firingSyllables, ...
    syllableandwordconnection, syllableandwordconnectionact)

global wordConceptNeuron;

wordfiringsignal=[];
order=[];
firingconnection=zeros(1,size(firingSyllables,2));
firingact=zeros(1,size(firingSyllables,2));
for i=1:size(firingSyllables,1)
    order(i)=find(firingSyllables(i,:)==1);
    firingconnection(1,order(i))=1;
    firingact(order(i))=firingact(order(i))+1;
end
if size(wordConceptNeuron,2)==0
    wordConceptNeuron(1).order=order;
    wordConceptNeuron(1).activity=1;
    wordConceptNeuron(1).check=0;
    syllableandwordconnection=firingconnection';
    syllableandwordconnectionact=firingact';
    wordfiringsignal.data=1;
    wordfiringsignal.tag='word';
else
    if size(firingSyllables,2)>size(syllableandwordconnection,1)
        tem1=size(firingSyllables,2);
        tem2=size(wordConceptNeuron,2)+1;
        wordConceptNeuron(tem2).order=order;
        wordConceptNeuron(tem2).activity=1;
        wordConceptNeuron(tem2).check=0;
        syllableandwordconnection(tem1,tem2)=0;
        syllableandwordconnection(:,tem2)=firingconnection';
        syllableandwordconnectionact(tem1,tem2)=0;
        syllableandwordconnectionact(:,tem2)=firingact';
        wordfiringsignal.data(tem2)=1;
        wordfiringsignal.tag='word';
    else
        %firing=find(firingSyllables*syllableandwordconnection/sum(firingSyllables.^2)==1);
        %using neuron thread to improve this part
        firing=firingword(firingSyllables,wordConceptNeuron,syllableandwordconnection);
        
        if firing
            wordConceptNeuron(firing).activity=wordConceptNeuron(firing).activity+1;
            syllableandwordconnectionact(find(syllableandwordconnectionact(:,firing)~=0))+1;
            tem1=size(wordConceptNeuron,2);
            wordfiringsignal.data(tem1)=0;
            wordfiringsignal.data(firing)=1;
            wordfiringsignal.tag='word';
        else
            tem1=size(firingSyllables,2);
            tem2=size(wordConceptNeuron,2)+1;
            wordConceptNeuron(tem2).order=order;
            wordConceptNeuron(tem2).activity=1;
            wordConceptNeuron(tem2).check=0;
            syllableandwordconnection(tem1,tem2)=0;
            syllableandwordconnection(:,tem2)=firingconnection';
            syllableandwordconnectionact(tem1,tem2)=0;
            syllableandwordconnectionact(:,tem2)=firingact';
            wordfiringsignal.data(tem2)=1;
            wordfiringsignal.tag='word';
        end
    end
end