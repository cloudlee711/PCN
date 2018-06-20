function [viewcalled] = associatedcortexcall (wordfiringsignal)

global associatedNeuron;
global connection;
p=1;
wordfiringassociatedNeuron=wordfiringsignal*connection.word;
viewcalled=wordfiringassociatedNeuron*connection.view';
for i=1:size(viewcalled,1)
    [value,index]=max(wordfiringassociatedNeuron(i,:));
    if value>0
        viewConceptNeuroncall(p)=index;
        p=p+1;
    end
end
viewcalled=unique(viewConceptNeuroncall);
