function [syllableConceptNeuron firingSyllables connection, difference] = syllablefeaturemap (syllableConceptNeuron,mfcc,connection,syllablethreshold)
firingSyllables=[];
delta=2;
numConceptNeuron=size(syllableConceptNeuron,2);
difference=0;
k=1;
if numConceptNeuron==0
    for i=1:size(mfcc,2)
        syllableConceptNeuron(i).data=mfcc(i).data;
        syllableConceptNeuron(i).label=mfcc(i).label.pronunciation;
        syllableConceptNeuron(i).activity=1;
        firingSyllables(k,i)=1;
        k=k+1;
    end
    numConceptNeuron=size(syllableConceptNeuron,2);
    connection(numConceptNeuron,numConceptNeuron)=0;
else
    dist=[];
    for i=1:size(mfcc,2)
        for j=1:size(syllableConceptNeuron,2)
            [dist(i,j)]=dtw(mfcc(i).data,syllableConceptNeuron(j).data); 
        end
        [a b]=min(dist(i,:));
        if a>syllablethreshold
            length=size(syllableConceptNeuron,2)+1;
            connection(length,length)=0;
            syllableConceptNeuron(length).data=mfcc(i).data;
            syllableConceptNeuron(length).label=mfcc(i).label.pronunciation;
            syllableConceptNeuron(length).activity=1;
            firingSyllables(k,length)=1;
            k=k+1;
        else
            firingSyllables(k,b)=1;
            k=k+1;
            syllableConceptNeuron(b).activity=syllableConceptNeuron(b).activity+1;
        end
        [value index] = sort(dist(i,:));
        difference(i)=value(1); 
        for l=2:size(index,2)
            if dist(i,index(l))<delta*syllablethreshold
                connection(b,index(l))=1;
                connection(index(l),b)=1; 
            end
        end
    end
    % completion firingSyllables
    if size(firingSyllables,2)<size(syllableConceptNeuron,2)
        firingSyllables(:,size(syllableConceptNeuron,2))=0;
    end
end