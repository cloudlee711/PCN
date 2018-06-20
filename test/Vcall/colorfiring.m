function [colorConceptNeuron firingNeuron] = colorfiring (colorConceptNeuron,CH)
winner=0;
length=size(colorConceptNeuron,2);
%find winners
mindis1=1000000;
mindis2=2000000;
for i=1:length
    A=CH-colorConceptNeuron(i).data;
    distem=norm(A(:));
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
    
    
    