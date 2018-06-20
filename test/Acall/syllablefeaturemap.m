function [firingSyllables] = syllablefeaturemap (syllableConceptNeuron,mfcc)
firingSyllables=[];
k=1;
dist=[];
for i=1:size(mfcc,2)
    for j=1:size(syllableConceptNeuron,2)
        [dist(i,j)]=dtw(mfcc(i).data,syllableConceptNeuron(j).data);
    end
    [~, b]=min(dist(i,:));
    firingSyllables(k,b)=1;
    k=k+1;
end
% completion firingSyllables
if size(firingSyllables,2)<size(syllableConceptNeuron,2)
    firingSyllables(:,size(syllableConceptNeuron,2))=0;
end