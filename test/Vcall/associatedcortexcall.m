function [wordcalled] = associatedcortexcall (viewfiringsignal)

global connection;
p=1;
viewfiringassociatedNeuron=viewfiringsignal.data*connection.view;
wordcalled=viewfiringassociatedNeuron*connection.word';
[~,index]=max(wordcalled);
wordcalled=unique(index);
