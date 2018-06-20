function [colorandviewconnection, outlineandviewconnection, viewfiringsignal] = OIDSconceptfiring (firingOutlineNeuron, ...
    colorandviewconnection, outlineandviewconnection)

global viewConceptNeuron;

viewfiringsignal=[];
[~, index] = max(outlineandviewconnection*firingOutlineNeuron');
tem=size(viewConceptNeuron,2);
viewfiringsignal.data(tem)=0;
viewfiringsignal.data(index)=1;
viewfiringsignal.tag='view';


