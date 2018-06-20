function [output] = unconsciousimpulse (input,connection)
if isempty(input)
    output=[];
else
    output=repmat(input,size(connection,1),1).*connection;
end