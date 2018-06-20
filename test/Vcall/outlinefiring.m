function [outlineConceptNeuron firingNeuron] = outlinefiring (outlineConceptNeuron,NFD)

winner=0;
length=size(outlineConceptNeuron,2);

%find winners
mindis1=1000000;
mindis2=2000000;
for i=1:length
    distem=norm(NFD(3:25)-outlineConceptNeuron(i).data);
    if distem<mindis1
        mindis1=distem;
        secondwinner=winner;
        winner=i;
    else
        if distem<mindis2
            mindis2=distem;
            secondwinner=i;
        end
    end
end
firingNeuron=zeros(1,length);
firingNeuron(winner)=1;
    
