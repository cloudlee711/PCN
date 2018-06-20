function firing = firingword (firingSyllables)
global wordConceptNeuron;
global syllableandwordconnection;
firing=0;
for i=1:size(wordConceptNeuron,2)
    flage=1;
    if size(firingSyllables,1)==size(wordConceptNeuron(i).order,2)   
       for j=1:size(firingSyllables,1)        
            multiplyfactor=zeros(size(syllableandwordconnection,1),1);
            multiplyfactor(wordConceptNeuron(i).order(j))=1;
            if firingSyllables(j,:)*multiplyfactor~=1
                flage=0;
                break;
            end
       end
       if flage==1;
           firing=i;
       end       
    end
end
