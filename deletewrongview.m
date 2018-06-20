function deletewrongview (firingviewindex, firingColorNeuronindex)

global viewConceptNeuron;
global colorandviewconnection; 

viewConceptNeuron(firingviewindex).color=setdiff(viewConceptNeuron(firingviewindex).color,firingColorNeuronindex);
colorandviewconnection(firingColorNeuronindex,firingviewindex)=0;