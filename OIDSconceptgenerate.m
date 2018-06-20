function [colorandviewconnection, outlineandviewconnection, viewfiringsignal] = OIDSconceptgenerate (firingOutlineNeuron, firingColorNeuron, ...
    colorandviewconnection, outlineandviewconnection)

global viewConceptNeuron;

viewfiringsignal=[];
tem1=find(firingOutlineNeuron~=0);
tem2=find(firingColorNeuron~=0);

if size(viewConceptNeuron,2)==0
    viewConceptNeuron(1).outline=tem1;
    viewConceptNeuron(1).color=tem2;
    viewConceptNeuron(1).activity=1;
    colorandviewconnection=1;
    outlineandviewconnection=1;
    viewfiringsignal.data=1;
    viewfiringsignal.tag='view';
else
    if size(firingOutlineNeuron,2)>size(viewConceptNeuron,2)
        tem=size(firingOutlineNeuron,2);
        viewConceptNeuron(tem).outline=tem1;
        viewConceptNeuron(tem).color=tem2;
        viewConceptNeuron(tem).activity=1;
        outlineandviewconnection(tem,tem)=1;
        colorandviewconnection(size(firingColorNeuron,2),tem)=0;
        if size(colorandviewconnection,1)<size(firingColorNeuron,2)% get number of color rows
            colorandviewconnection(size(firingColorNeuron,2),tem)=1;% add new color view connection
        else
            colorandviewconnection(:,tem)=colorandviewconnection(:,tem)+firingColorNeuron';
        end
        viewfiringsignal.data(tem)=1;
        viewfiringsignal.tag='view';
    else
        [~, index] = max(outlineandviewconnection*firingOutlineNeuron');
        outlineandviewconnection(:,index)=outlineandviewconnection(:,index)+firingOutlineNeuron';
        viewConceptNeuron(index).activity=viewConceptNeuron(index).activity+1;
%         if ~find(tem2==viewConceptNeuron(index).color)
%             viewConceptNeuron(index).color=union(viewConceptNeuron(index).color, tem2);
%         end
        viewConceptNeuron(index).color=union(viewConceptNeuron(index).color, tem2);
        if size(colorandviewconnection,1)<size(firingColorNeuron,2)% get number of color rows
            colorandviewconnection(size(firingColorNeuron,2),index)=1;% add new color view connection
        else
            colorandviewconnection(:,index)=colorandviewconnection(:,index)+firingColorNeuron';
        end
        tem=size(viewConceptNeuron,2);
        viewfiringsignal.data(tem)=0;
        viewfiringsignal.data(index)=1;
        viewfiringsignal.tag='view';
    end
end