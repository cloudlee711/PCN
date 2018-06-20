function introspection (firingassociatedNeuron1, firingassociatedNeuron2, UI2, UI1, firingsignal1, firingsignal2, ...
    NFD, FD, mfcc, firingOutlineNeuron, firingColorNeuron, difference)

global inputimage;
global syllableConceptNeuron;
global wordConceptNeuron;
global viewConceptNeuron;
global outlineConceptNeuron;
global colorConceptNeuron;
global associatedNeuron;
global connection;
global associatedconnection;
global syllableconnection;

[~,firingwordindex]=max(firingsignal2.data);    
[~,firingviewindex]=max(firingsignal1.data);
[~, firingassociatedneuronindex1]=max(firingassociatedNeuron1);
[~, firingassociatedneuronindex2]=max(firingassociatedNeuron2);
[~, firingColorNeuronindex]=max(firingColorNeuron);

if isempty(firingassociatedNeuron1)&&isempty(firingassociatedNeuron2)
    % add new associated neuron  
    tem=size(associatedNeuron,2)+1;
    associatedNeuron(tem).(firingsignal1.tag)=firingviewindex;  
    associatedNeuron(tem).word=firingwordindex;    
    associatedNeuron(tem).activity=1; 
    % update connection 
    connection.(firingsignal1.tag)(associatedNeuron(tem).(firingsignal1.tag),tem)=1;
    connection.word(associatedNeuron(tem).word,tem)=1;
    associatedconnection(tem).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
end

%---------------------------------------------------------------------------------------------------------------------------------------
if ~isempty(firingassociatedNeuron1)&&isempty(firingassociatedNeuron2)
    [UIword,~]=find(UI2==max(UI2(:)));
    %imshow(inputimage);
    subplot(2,2,1);
    imshow(inputimage);
    hold on;
    title('Fig.1 Current input view');
    subplot(2,2,2);
    plot(ifft(outlineConceptNeuron(viewConceptNeuron(firingviewindex).outline).FD), 'color', ... 
        colorhistogram2RGB(colorConceptNeuron(firingColorNeuronindex).data,0.05),'linewidth',7);
    tem=unidrnd(size(UIword,2));
    str=['Fig.2 The view fired by current input view and its name is ' syllableConceptNeuron(wordConceptNeuron(UIword(tem)).order).label];
    title(str);
    set(gcf,'position',[30 250 600 400]);
    question1 = ['Is Fig. 2 right that I recall from current view? y/n '];
    answer1=input(question1,'s');
    if answer1=='n'
        % add new outlineConceptNeuron to system 
        addnewoutlineConceptNeuron(NFD, FD);
        % add new viewConceptNeuron to syste
        addviewConceptNeuron(firingColorNeuron);
        % add new associated neuron  
        tem=size(associatedNeuron,2)+1;
        tem2=size(viewConceptNeuron,2);
        associatedNeuron(tem).(firingsignal1.tag)=tem2;  
        associatedNeuron(tem).word=firingwordindex;    
        associatedNeuron(tem).activity=1; 
        % update connection 
        connection.(firingsignal1.tag)(associatedNeuron(tem).(firingsignal1.tag),tem)=1;
        connection.word(associatedNeuron(tem).word,tem)=1;
        associatedconnection(tem).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
        % drop the color of Fig. 2
        deletewrongview(firingviewindex, firingColorNeuronindex);
    else
        if ~isempty(UIword) 
            tem=unidrnd(size(UIword,2));
            question2 = ['Fig. 2 is called ' syllableConceptNeuron(wordConceptNeuron(UIword(tem)).order).label, ' before? y/n ']; 
            answer2=input(question2,'s');
            if answer2=='n'%drop this learning result 
                if size(associatedNeuron(firingassociatedneuronindex1).word,2)>1
                    associatedNeuron(firingassociatedneuronindex1).word(find(associatedNeuron(firingassociatedneuronindex1).word==UIword(tem)))=[];
                    connection.word(UIword(tem),firingassociatedneuronindex1)=0;
                end
            end
        end
        % get similar words of current word fired by current view input
        flagsimilarword=0;
        for j=1:size(UIword,2)
            similarsyllable=[];
            for i=1:size(wordConceptNeuron(UIword(j)).order,2)
                similarsyllable(i).data=find(syllableconnection(wordConceptNeuron(UIword(j)).order(i),:)~=0);
                similarsyllable(i).data=[similarsyllable(i).data wordConceptNeuron(UIword(j)).order(i)];
            end
            similarword=similarsyllable(1).data';
            similarsyllable(1)=[];
            similarword=getsimilarword(similarword, similarsyllable);
            
            for i=1:size(similarword,1)
                if size(similarword(i,:),2)==size(wordConceptNeuron(firingwordindex).order,2)
                    if similarword(i,:)==wordConceptNeuron(firingwordindex).order
                        flagsimilarword=i;
                        break;
                    end
                end
            end
            if flagsimilarword~=0
                break;
            end
        end
        flagnewword=1;
        if ~isempty(UIword) 
            for i=1:size(UIword,1)
                if size(wordConceptNeuron(firingwordindex).order,2)== size(wordConceptNeuron(UIword(i)).order,2)
                    flagnewword=0;
                    break;
                end
            end
        end

        if flagnewword==1 % the length of the current input word is not equal to that of the word introspected by current input view
            question3 = ['You want to call Fig.2 ' syllableConceptNeuron(wordConceptNeuron(firingwordindex).order).label 'another name? y/n '];
            answer3=input(question3,'s');
            if answer3=='y' % add this new word to system
                associatedNeuron(firingassociatedneuronindex1).word=union(associatedNeuron(firingassociatedneuronindex1).word, firingwordindex);
                associatedNeuron(firingassociatedneuronindex1).activity=associatedNeuron(firingassociatedneuronindex1).activity+1;
                % update connection
                connection.word(firingwordindex,firingassociatedneuronindex1)=1;
                associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
            end
        else
            if flagsimilarword
                associatedNeuron(firingassociatedneuronindex1).word=union(associatedNeuron(firingassociatedneuronindex1).word, firingwordindex);
                associatedNeuron(firingassociatedneuronindex1).activity=associatedNeuron(firingassociatedneuronindex1).activity+1;
                % update connection
                connection.word(firingwordindex,firingassociatedneuronindex1)=1;
                associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
            else
                if find(difference>600)
                    question3 = ['Is this also called ' syllableConceptNeuron(wordConceptNeuron(firingwordindex).order).label ' ? y/n '];
                else
                    question3 = ['You call it ' syllableConceptNeuron(wordConceptNeuron(firingwordindex).order).label ...
                        ' a bit different as before, do I remember this? y/n '];
                end
                answer3=input(question3,'s');
                if answer3=='y' % add this new word to system
                    associatedNeuron(firingassociatedneuronindex1).word=union(associatedNeuron(firingassociatedneuronindex1).word, firingwordindex);
                    associatedNeuron(firingassociatedneuronindex1).activity=associatedNeuron(firingassociatedneuronindex1).activity+1;
                    % update connection
                    connection.word(firingwordindex,firingassociatedneuronindex1)=1;
                    associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
                end
            end
        end
    end
    close all;
end

%---------------------------------------------------------------------------------------------------------------------------------------
if isempty(firingassociatedNeuron1)&&~isempty(firingassociatedNeuron2)
    [UIview,~]=find(UI1==max(UI1(:)))
    if wordConceptNeuron(firingwordindex).check==0
        question1=['Current input view is new to me. Is it a correct word ' syllableConceptNeuron(wordConceptNeuron(firingwordindex).order).label ' that I recognize? y/n '];
        answer1=input(question1,'s');
        subplot(2,2,1);
        imshow(inputimage);
        hold on;
        title('Fig.1 Current input view');
        subplot(2,2,2);
        plot(ifft(outlineConceptNeuron(viewConceptNeuron(UIview(1)).outline).FD), 'color', ...
            colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron(UIview(1)).color(1)).data,0.05),'linewidth',7);
        title('Fig.2 The view called by current input voice');
        set(gcf,'position',[30 250 400 400]);
        if answer1=='n' %the word is wrong
            question2=['Do you mean the view in Fig.2 by what you said? y/n '];
            answer2=input(question2,'s');
            if answer2=='n'
                % delete wrong word and add new word
                deletewrongword(firingwordindex);                
                addnewword(mfcc);
                % add new associated neuron to learn this two current input
                tem=size(associatedNeuron,2)+1;
                firingwordindex=size(wordConceptNeuron,2);
                associatedNeuron(tem).(firingsignal1.tag)=firingviewindex;
                associatedNeuron(tem).word=firingwordindex;
                associatedNeuron(tem).activity=1;
                % update connection
                connection.(firingsignal1.tag)(associatedNeuron(tem).(firingsignal1.tag),tem)=1;
                connection.word(associatedNeuron(tem).word,tem)=1;
                associatedconnection(tem).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
            else 
                % delete wrong word and add new word
                deletewrongword(firingwordindex);                
                addnewword(mfcc);
                % add word to associated layer
                firingwordindex=size(wordConceptNeuron,2);
                associatedNeuron(firingassociatedneuronindex2).word=union(associatedNeuron(firingassociatedneuronindex2).word, firingwordindex);
                associatedNeuron(firingassociatedneuronindex2).activity=associatedNeuron(firingassociatedneuronindex2).activity+1; 
                % update connection
                connection.word(firingwordindex,firingassociatedneuronindex2)=1;
                associatedconnection(firingassociatedneuronindex2).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
            end
        else %the word is correct
            question2=['Do you mean the view in Fig.2 by what you said? y/n '];
            answer2=input(question2,'s');
            if answer2=='n'
                addnewword(mfcc);
                % add new associated neuron to learn this two current input
                tem=size(associatedNeuron,2)+1;
                firingwordindex=size(wordConceptNeuron,2);
                associatedNeuron(tem).(firingsignal1.tag)=firingviewindex;
                associatedNeuron(tem).word=firingwordindex;
                associatedNeuron(tem).activity=1;
                % update connection
                connection.(firingsignal1.tag)(associatedNeuron(tem).(firingsignal1.tag),tem)=1;
                connection.word(associatedNeuron(tem).word,tem)=1;
                associatedconnection(tem).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
            else                
                associatedNeuron(firingassociatedneuronindex2).view=union(associatedNeuron(firingassociatedneuronindex2).view, firingviewindex);
                associatedNeuron(firingassociatedneuronindex2).activity=associatedNeuron(firingassociatedneuronindex2).activity+1;
                % update connection
                connection.view(firingviewindex,firingassociatedneuronindex2)=1;
                associatedconnection(firingassociatedneuronindex2).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
            end
        end
    end
    close all;
end

%---------------------------------------------------------------------------------------------------------------------------------------
if ~isempty(firingassociatedNeuron1)&&~isempty(firingassociatedNeuron2)  
    if firingassociatedNeuron1*firingassociatedNeuron2' 
        %update connection
        tem1=size(associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword']),1);
        tem2=size(associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword']),2);
        if firingviewindex>tem1||firingwordindex>tem2
            associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
        else
            associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=...
                associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)+1;
        end
        
        associatedNeuron(firingassociatedneuronindex1).activity=associatedNeuron(firingassociatedneuronindex1).activity+1;
    else
        [UIview,~]=find(UI1==max(UI1(:)));
        question1=['The word that I recongize as ' syllableConceptNeuron(wordConceptNeuron(firingwordindex).order).label ' is right? y/n '];
        answer1=input(question1,'s');
        if answer1=='n'%drop this learning result 
            wordConceptNeuron(firingwordindex)=[];
            connection.word(firingwordindex,:)=[];
            for i=1:size(associatedNeuron,2)
                [~,index]=find(associatedNeuron(i).word==firingwordindex);
                if index
                    associatedNeuron(i).word(index)=[];
                end
                [~,index]=find(associatedNeuron(i).word>firingwordindex);
                if index
                    associatedNeuron(i).word(index)=associatedNeuron(i).word(index)-1;
                end
            end
        else
            question2=['I have a problem, tell me which fig is right or both or none. Type 2/3/b/n. '];
            subplot(2,2,1);
            imshow(inputimage);
            hold on;
            title('Fig.1 Current input view');
            
            subplot(2,2,2);
            plot(ifft(outlineConceptNeuron(viewConceptNeuron(firingviewindex).outline).FD), 'color', ... 
                colorhistogram2RGB(colorConceptNeuron(firingColorNeuronindex).data,0.05),'linewidth',7);
            [UIword,~]=find(UI2==max(UI2(:)));
            if ~isempty(UIword) 
                tem=unidrnd(size(UIword,2));
                name=['Fig.2 The view fired by current input view and its name is ' syllableConceptNeuron(wordConceptNeuron(UIword(tem)).order).label];
            else
                name=['Fig.2 The view fired by current input view'];
            end
            title(name);

            subplot(2,2,3);
            plot(ifft(outlineConceptNeuron(viewConceptNeuron(UIview(1)).outline).FD), 'color', ... 
                colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron(UIview(1)).color(1)).data,0.05),'linewidth',7);
            title('Fig.3 The view called by current input voice');
            set(gcf,'position',[30 250 400 400]);
            answer=input(question2,'s');
            if answer=='2' % enhance 2 and drop 3
                associatedNeuron(firingassociatedneuronindex1).word=union(associatedNeuron(firingassociatedneuronindex1).word, firingwordindex);
                associatedNeuron(firingassociatedneuronindex1).activity=associatedNeuron(firingassociatedneuronindex1).activity+1;
                associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
                % update connection
                connection.word(firingwordindex,firingassociatedneuronindex1)=1;
                associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
                
                associatedNeuron(firingassociatedneuronindex2).view=setdiff(associatedNeuron(firingassociatedneuronindex2).view,firingviewindex);
                connection.view(firingviewindex,firingassociatedneuronindex2)=0;
                associatedconnection(firingassociatedneuronindex2).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=0;
                
            end
            if answer=='3' % enhance 3 and drop 2
                % add new outlineConceptNeuron to system
                addnewoutlineConceptNeuron(NFD, FD);
                % add new viewConceptNeuron to syste
                addviewConceptNeuron(firingColorNeuron);
                % add new associated neuron
                firingviewindex=size(viewConceptNeuron,2);
                associatedNeuron(firingassociatedneuronindex2).view=union(associatedNeuron(firingassociatedneuronindex2).view, firingviewindex);
                associatedNeuron(firingassociatedneuronindex2).activity=associatedNeuron(firingassociatedneuronindex2).activity+1;
                % update connection
                connection.(firingsignal1.tag)(firingviewindex,firingassociatedneuronindex2)=1;
                associatedconnection(firingassociatedneuronindex2).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
                % drop the color of Fig. 2
                deletewrongview(firingviewindex, firingColorNeuronindex);
            end
            if answer=='b' % enhance both
                %update neuron
                associatedNeuron(firingassociatedneuronindex2).view=union(associatedNeuron(firingassociatedneuronindex2).view, firingviewindex);
                associatedNeuron(firingassociatedneuronindex2).activity=associatedNeuron(firingassociatedneuronindex2).activity+1; 
                associatedNeuron(firingassociatedneuronindex1).word=union(associatedNeuron(firingassociatedneuronindex1).word, firingwordindex);
                associatedNeuron(firingassociatedneuronindex1).activity=associatedNeuron(firingassociatedneuronindex1).activity+1;   
                %update connection
                connection.view(firingviewindex,firingassociatedneuronindex2)=1;
                associatedconnection(firingassociatedneuronindex2).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
                connection.word(firingwordindex,firingassociatedneuronindex1)=1;
                associatedconnection(firingassociatedneuronindex1).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=1;
            end
            if answer=='n' %drop this learning result
                associatedNeuron(firingassociatedneuronindex2).view=setdiff(associatedNeuron(firingassociatedneuronindex2).view,firingviewindex);
                connection.view(firingviewindex,firingassociatedneuronindex2)=0;
                associatedconnection(firingassociatedneuronindex2).([firingsignal1.tag 'andword'])(firingviewindex,firingwordindex)=0;
                % drop the color of Fig. 2
                deletewrongview(firingviewindex, firingColorNeuronindex);
                
            end
        end
        close all;
    end
end