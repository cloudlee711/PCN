function [wordfiringsignal similarword firingSyllablesSimilar] = ODSconceptfiring (firingSyllables)

global wordConceptNeuron;
global syllableconnection;


wordfiringsignal=[];
order=[];
firingconnection=zeros(1,size(firingSyllables,2));
firingact=zeros(1,size(firingSyllables,2));
for i=1:size(firingSyllables,1)
    order(i)=find(firingSyllables(i,:)==1);
end

firing=firingword(firingSyllables)

if firing
    tem1=size(wordConceptNeuron,2);
    wordfiringsignal(tem1)=0;
    wordfiringsignal(firing)=1;
else
    set=[];
    for sizesyllableindex=1:size(order,2)
        set(sizesyllableindex).data=find(syllableconnection(order(sizesyllableindex),:)~=0);
        set(sizesyllableindex).data=[set(sizesyllableindex).data order(sizesyllableindex)];
    end
    setcopy=set;
    similarword=setcopy(1).data';
    setcopy(1)=[];
    similarword=getsimilarword(similarword, setcopy);
    tem1=size(wordConceptNeuron,2);
    tem2=size(syllableconnection,2);
    if size(similarword,1)~=0
        for i=1:size(similarword,1)
            for j=1:size(similarword(i,:),2)
                firingSyllablesSimilar(i).data(j,tem2)=0;
                firingSyllablesSimilar(i).data(j,similarword(i,j))=1;
            end
            firing=firingword(firingSyllablesSimilar(i).data);
            if firing
                wordfiringsignal(i,tem1)=0;
                wordfiringsignal(i,firing)=1;
            end
        end
    end
end

