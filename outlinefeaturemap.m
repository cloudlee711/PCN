function [outlineConceptNeuron firingNeuron connection] = outlinefeaturemap (outlineConceptNeuron,NFD,FD,connection,outlinethreshold)
theta=0.5;
delta=3;
agedead=100;
winner=0;
secondwinner=0;
numConceptNeuron=size(outlineConceptNeuron,2);
if numConceptNeuron==0
    outlineConceptNeuron(1).data=NFD(3:25);
    outlineConceptNeuron(1).FD=FD;
    outlineConceptNeuron(1).threshold=norm(NFD(3:25))/outlinethreshold;
    outlineConceptNeuron(1).activity=1;
    firingNeuron=[1];
    connection(1,1)=0;
else
    %find winners
    mindis1=1000000; 
    mindis2=2000000;
    for i=1:numConceptNeuron
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
    
    %update colorConceptNeuron map
    dis=norm(outlineConceptNeuron(winner).data-NFD(3:25));
    ratio=dis/min(norm(outlineConceptNeuron(winner).data),norm(NFD(3:25)));
    if ratio>theta
        length=size(outlineConceptNeuron,2)+1;
        outlineConceptNeuron(length).data=NFD(3:25); 
        outlineConceptNeuron(length).FD=FD;
        firingNeuron=zeros(1,length);
        firingNeuron(length)=1;
        connection(length,length)=0;
        outlineConceptNeuron(length).activity=1;
        outlineConceptNeuron(length).threshold=norm(NFD(3:25))/outlinethreshold;
    else
        if mindis1>outlineConceptNeuron(winner).threshold %new neuron
            length=size(outlineConceptNeuron,2)+1;
            outlineConceptNeuron(length).data=NFD(3:25); 
            outlineConceptNeuron(length).FD=FD;
            firingNeuron=zeros(1,length);
            firingNeuron(length)=1;
            connection(length,length)=0;
            outlineConceptNeuron(length).activity=1;
            outlineConceptNeuron(length).threshold=norm(NFD(3:25))/outlinethreshold;    
        else %update winner
            outlineConceptNeuron(winner).activity=outlineConceptNeuron(winner).activity+1;             
            outlineConceptNeuron(winner).data=outlineConceptNeuron(winner).data+(1/outlineConceptNeuron(winner).activity)*(NFD(3:25)-outlineConceptNeuron(winner).data);
            length=size(outlineConceptNeuron,2);
            firingNeuron=zeros(1,length);
            firingNeuron(winner)=1;
            [row,col]=find(connection(winner,:)~=0);            
            connection(winner,col)=connection(winner,col)+1;            
            connection(col,winner)=connection(col,winner)+1;
            locate=find(connection(winner,:)>agedead);            
            connection(winner,locate)=0;            
            connection(locate,winner)=0;
            if secondwinner~=0
                if mindis2<delta*outlineConceptNeuron(secondwinner).threshold  
                    connection(winner,secondwinner)=1;
                    connection(secondwinner,winner)=1;
                end
            end
        end
    end
end