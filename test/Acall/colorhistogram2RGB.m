function [RGB] = colorhistogram2RGB (histogram,containersize)

for i=1:3           
    RGB(i)=0;
    for j=1:21
        RGB(i)= RGB(i)+(0.05*(j-1)+containersize/2)*histogram(j,i);
    end
    if RGB(i)>1
        RGB(i)=1;
    end
end

if RGB(1)>0.95&&RGB(2)>0.95&&RGB(3)>0.95 
    RGB=RGB-0.05;
end
