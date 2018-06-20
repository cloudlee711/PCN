function addnewword (mfcc)

global wordConceptNeuron;
global syllableConceptNeuron;
global syllableconnection;
global syllableandwordconnection;
global syllableandwordconnectionact;

firingSyllables=[];

k=1;
for i=1:size(mfcc,2)
    length=size(syllableConceptNeuron,2)+1;
    syllableconnection(length,length)=0;
    syllableConceptNeuron(length).data=mfcc(i).data;
    syllableConceptNeuron(length).label=mfcc(i).label.pronunciation;
    syllableConceptNeuron(length).activity=1;
    firingSyllables(k,length)=1;
    k=k+1;
end

order=[];
firingconnection=zeros(1,size(firingSyllables,2));
firingact=zeros(1,size(firingSyllables,2));

for i=1:size(firingSyllables,1)
    order(i)=find(firingSyllables(i,:)==1);
    firingconnection(1,order(i))=1;
    firingact(order(i))=firingact(order(i))+1;
end

tem1=size(firingSyllables,2);
tem2=size(wordConceptNeuron,2)+1;
wordConceptNeuron(tem2).order=order;
wordConceptNeuron(tem2).activity=1;
wordConceptNeuron(tem2).check=0;
syllableandwordconnection(tem1,tem2)=0;
syllableandwordconnection(:,tem2)=firingconnection';
syllableandwordconnectionact(tem1,tem2)=0; 
syllableandwordconnectionact(:,tem2)=firingact';
