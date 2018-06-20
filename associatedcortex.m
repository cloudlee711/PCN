function associatedcortex (viewfiringsignal, wordfiringsignal, NFD, FD, mfcc, firingOutlineNeuron, firingColorNeuron, difference, questionnm, varargin)

global channlename;
global associatedNeuron;
global connection;
global associatedconnection;

channelnum=numel(varargin)+2;

if size(associatedNeuron,2)==0
    for i=1:channelnum
        associatedNeuron(1).(channlename{i})=1;
        connection.(channlename{i})=1;
    end
    associatedNeuron(1).activity=1;
    for i=1:channelnum-1
        for j=i+1:channelnum
            associatedconnection.([channlename{i},'and', channlename{j}])=1;
        end
    end
else
    % find firing associatedNeuron
    if size(viewfiringsignal.data,2)>size(connection.view,1)% view channel has a new thing
        viewfiringassociatedNeuron=[];
    else
        viewfiringassociatedNeuron=viewfiringsignal.data*connection.view;
    end
    
    if size(wordfiringsignal.data,2)>size(connection.word,1)% view channel has a new thing
        wordfiringassociatedNeuron=[];
    else
        wordfiringassociatedNeuron=wordfiringsignal.data*connection.word;
    end
    % unconscious impulse process
    UIword = unconsciousimpulse(viewfiringassociatedNeuron,connection.word);
    UIview = unconsciousimpulse(wordfiringassociatedNeuron,connection.view);
    % introspection process, now only two channels, process of more
    % channels should be further developed
    if ~isempty(wordfiringsignal) %communication needs introspection
        introspection(viewfiringassociatedNeuron,wordfiringassociatedNeuron, ...
            UIword, UIview, viewfiringsignal, wordfiringsignal, NFD, FD, mfcc, firingOutlineNeuron, firingColorNeuron, difference);
    else %communication does not need introspection
        %communication does not need introspection
    end
    
end