function addviewConceptNeuron (firingColorNeuron)

global outlineConceptNeuron;
global viewConceptNeuron;
global colorandviewconnection; 
global outlineandviewconnection;


tem1=size(outlineConceptNeuron,2); 
tem2=size(viewConceptNeuron,2)+1;  
viewConceptNeuron(tem2).outline=tem1;
[~,colorindex]=max(firingColorNeuron);
viewConceptNeuron(tem2).color=colorindex;
viewConceptNeuron(tem2).activity=1;
outlineandviewconnection(tem1,tem2)=1;
colorandviewconnection(colorindex,tem2)=1;


