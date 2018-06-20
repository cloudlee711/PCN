function [colorConceptNeuron firingNeuron connection] = colorfeaturemap (colorConceptNeuron,CH,connection,colorthreshold)
theta=0.5;
delta=3;
agedead=100;
winner=0;
secondwinner=0;
numConceptNeuron=size(colorConceptNeuron,2);
%initialize colorConceptNeuron map
if numConceptNeuron==0
    colorConceptNeuron(1).data=CH;
    colorConceptNeuron(1).threshold=norm(CH)/colorthreshold;
    colorConceptNeuron(1).activity=1;
    firingNeuron=[1];
    connection(1,1)=0;
else
    %find winners
    mindis1=1000000; 
    mindis2=2000000;
    for i=1:numConceptNeuron
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
    
    %update colorConceptNeuron map
    dis=norm(colorConceptNeuron(winner).data-CH);    
    ratio=dis/min(norm(colorConceptNeuron(winner).data),norm(CH));
    if ratio>theta %significant different, new neuron
        length=size(colorConceptNeuron,2)+1;
        colorConceptNeuron(length).data=CH; 
        firingNeuron=zeros(1,length);
        firingNeuron(length)=1;
        connection(length,length)=0;
        colorConceptNeuron(length).activity=1;
        colorConceptNeuron(length).threshold=norm(CH)/colorthreshold;
    else
        if mindis1>colorConceptNeuron(winner).threshold %new neuron
            length=size(colorConceptNeuron,2)+1;
            colorConceptNeuron(length).data=CH; 
            firingNeuron=zeros(1,length);
            firingNeuron(length)=1;
            connection(length,length)=0;
            colorConceptNeuron(length).activity=1;
            colorConceptNeuron(length).threshold=norm(CH)/colorthreshold;
        else %update winner
            colorConceptNeuron(winner).activity=colorConceptNeuron(winner).activity+1;             
            colorConceptNeuron(winner).data=colorConceptNeuron(winner).data+(1/colorConceptNeuron(winner).activity)*(CH-colorConceptNeuron(winner).data);
            length=size(colorConceptNeuron,2);
            firingNeuron=zeros(1,length);
            firingNeuron(winner)=1;
            [row,col]=find(connection(winner,:)~=0);            
            connection(winner,col)=connection(winner,col)+1;            
            connection(col,winner)=connection(col,winner)+1;
            locate=find(connection(winner,:)>agedead);            
            connection(winner,locate)=0;            
            connection(locate,winner)=0;
            if secondwinner~=0
                if mindis2<delta*colorConceptNeuron(secondwinner).threshold  
                    connection(winner,secondwinner)=1;
                    connection(secondwinner,winner)=1;
                end
            end
        end
    end
    
    
end