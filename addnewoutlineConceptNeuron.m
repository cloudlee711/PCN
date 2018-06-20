function addnewoutlineConceptNeuron (NFD, FD)
threshold=3;
global outlineConceptNeuron;
global outlineconnection


tem=size(outlineConceptNeuron,2)+1;
outlineConceptNeuron(tem).data=NFD(3:25);
outlineConceptNeuron(tem).FD=FD;
outlineConceptNeuron(tem).threshold=norm(NFD(3:25))/threshold;
outlineConceptNeuron(tem).activity=1;
outlineConceptNeuron(tem).label=[];
outlineconnection(tem,tem)=0;
