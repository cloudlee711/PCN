function deletewrongword (firingwordindex)

global wordConceptNeuron;
global connection;
global associatedconnection;
global associatedNeuron;

wordConceptNeuron(firingwordindex)=[];
connection.word(firingwordindex,:)=[];

for i=1:size(associatedNeuron,2)
    associatedNeuron(i).word=setdiff(associatedNeuron(i).word,firingwordindex); 
    associatedNeuron(i).word(find(associatedNeuron(i).word>firingwordindex))=...
        associatedNeuron(i).word(find(associatedNeuron(i).word>firingwordindex))-1;
end
for i=1:size(associatedconnection,2)
    if size(associatedconnection(i).viewandword,2)>firingwordindex
        associatedconnection(i).viewandword(:,firingwordindex)=[];
    end
end

