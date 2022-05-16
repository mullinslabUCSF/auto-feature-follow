function feature06_iniamp_exp(mainfolder,subfolder,mintrackleng,maxtrackleng,background)
% 
% Extract track feature and save the results to a file;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function arguments: 

% % Image main folder path:
% mainfolder=['/mnt/partition/image_data/peters_sm_data/cp_arp_100ms_full/'];
% subfolder=['sample 1 Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1% Arp2 _2/'];
% subfolder=['sample 1 Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1% Arp23/'];
% %subfolder=['sample 1 CP  644nM 30% 750EM 100ms 14bit 1.6opt 100x 0.1% CP/'];
% subfolder=['sample 1 CP  644nM 30% 750EM 100ms 14bit 1.6opt 100x 0.1% CP 2/'];
% %subfolder=['sample 4 LAT Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1%  Arp23 1/'];
% %subfolder=['sample 4 LAT Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1% Arp23 2/'];
% 
% % Parameters:
% mintrackleng=5;
% maxtrackleng=0; % 0 -> infinity

plotfigure=0; % 1 - plot feature; 2 - plot histogram

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tracksubfolder=['tracking_results/'];

% Load the tracking results .mat file for detection and tracks:

% Tracking results subfolders:
trackfolder=[mainfolder,subfolder,tracksubfolder];

%resultsfilefolderDetection=[trackfolder, 'Detection.mat'];
%detectionstruct=load(resultsfilefolderDetection)

resultsfilefolderTracking=[trackfolder, 'Tracking.mat'];
trackingstruct=load(resultsfilefolderTracking);

% Track parameters:
tracksFinal=trackingstruct.tracksFinal;
%tracksFeatIndxCG=trackingstruct.tracksFinal.tracksFeatIndxCG;
tracksCoordAmpCG=trackingstruct.tracksFinal.tracksCoordAmpCG;
seqOfEvents=trackingstruct.tracksFinal.seqOfEvents;
numboftracks=length(tracksFinal);
firstimage=1;
lastimage=length(trackingstruct.kalmanInfoLink);

if (plotfigure == 1)
    figure(1)
    clf
    hold on
end

%%%%%%

% % Get the nwind for each track:
% [trackfolder,'Tracking_class.mat'];
% tracksFinalclass=load([trackfolder,'Tracking_class.mat']);
% tracksFinalclass=tracksFinalclass.tracksFinalclass;
%  
% classvec=0;
% i=1;
% ni=length(tracksFinalclass);
% while (i <= ni)
%     classvec(i)=tracksFinalclass(i).class;
%     nwindvec(i)=tracksFinalclass(i).nwind;
%     i=i+1;
% end % while (i <= ni)
% size(classvec);
% size(nwindvec);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the median amplitude over all tracks as a normalizer:
% Extract the feature for each track:
trackind=1;
numboftracks;
usedtracks=0;
while (trackind <= numboftracks)
    
    nwind=nwindvec(trackind);
    if (nwind ~= 3)
        usedtracks=usedtracks+1; % Update the number of evaluated tracks 
        
    amplitudevec=tracksFinal(trackind).tracksCoordAmpCG(4:8:end);
    tracklength=length(amplitudevec);
    startind=tracksFinal(trackind).seqOfEvents(1,1);
    endind=tracksFinal(trackind).seqOfEvents(2,1); 

    % Calculate the normlizer:
    amplitudevec=amplitudevec-background;
    normalizervec(usedtracks)=nanmean(amplitudevec);
    end % if (nwind ~= 3)
    
    trackind=trackind+1;
end % while (trackind <= numboftracks)
normalizer=median(normalizervec);


% Extract the feature for each track:
featurevec(1:numboftracks)=-999;
trackind=1;
numboftracks;
usedtracks=0;
while (trackind <= numboftracks)
    
  
%     nwind=nwindvec(trackind);
%     if (nwind ~= 3)
    
        usedtracks=usedtracks+1; % Update the number of evaluated tracks 

        % Calculate the feature:
        amplitudevec=tracksFinal(trackind).tracksCoordAmpCG(4:8:end);
        startind=tracksFinal(trackind).seqOfEvents(1,1);
        endind=tracksFinal(trackind).seqOfEvents(2,1); 
        trackleng=endind-startind+1;
        timevecaux=1:length(amplitudevec);
        timevecaux=timevecaux-1;

        % Interpolate the amplitude data around NaNs before fitting a function:
        nanixaux=find(isnan(amplitudevec)==1);
        nonnanixaux=find(isnan(amplitudevec)==0);
        amplitudevecinterp=amplitudevec;
        if (isempty(nanixaux) == 0)
            % Interpolate:
            %amplitudevecinterp=interp1(nonnanixaux,amplitudevec(nonnanixaux),timevecaux+1);

            % Leave out missing values for the fit:
            timevecaux=timevecaux(nonnanixaux);
            amplitudevecinterp=amplitudevec(nonnanixaux);
        end % if (isempty(nanixaux) == 0)

        % Fit the data:
        xdata=timevecaux;
        ydata=amplitudevecinterp-background;
        %xdatafit=xdata(find(ydata > 0));
        %ydatafit=ydata(find(ydata > 0));
        %ydatafit=log(ydatafit);
        xdatafit=xdata;
        ydatafit=ydata;
        
        x0=[1,1];
        opts = optimset('Display','off');
        [x,resnorm] = lsqcurvefit(@fitfunction,x0,xdatafit,ydatafit,[],[],opts);
        x=real(x);

        % Store the results of the fit:
        iniamplitudevec=x(1);
        charactimevec=x(2);
        tracklengvec=trackleng;

        feature=iniamplitudevec;

        if (plotfigure == 1)   
            xfit=xdata(1):(xdata(end)-xdata(1))/500:xdata(end);
            x
            yfit=fitfunction(x,xfit);
            %yfit=exp(yfit);
                
            clf
            hold on
            plot(xdatafit,ydatafit,'x-')
            plot(xfit,yfit,'r--', 'Linewidth', 2)
            %plot(timevecauxnorm,amplitudevec,'rx-')
            feature
            %nanstd(amplitudevec)
 
            pause(1)
        end % if (plotfigure == 1)

        featurevec(trackind)=feature;
    
%     end % if (
    
    trackind=trackind+1;
end % while (trackind <= numboftracks)
%featurevec(find(featurevec~=-999))=featurevec(find(featurevec~=-999))./normalizer;
featurevec;


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit-function:
function ydatafun=fitfunction(x,xdatafun)
    ydatafun=x(1).*exp(-xdatafun./x(2));
end % function fitfunction()

function ydatafun=fitfunction2(x,xdatafun)
    ydatafun=log(x(1))+(-xdatafun./x(2));
end % function fitfunction2()
%%%%%%%%%%%%%%%%%%%%%%%%%%


% Plot a histogram of this track feature:
if (plotfigure == 2)
    featurevechist=featurevec(find(featurevec~=-999));
    figure(2)
    clf
    hist(featurevechist,60)
    xlim([0 0.5])
end % if (plotfigure == 2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the featurevec to a file in the tracking results folder:

% Set the feature name:
[ST,I]=dbstack('-completenames');
functionfilename=ST(1).file;
functionfilename(max(strfind(functionfilename,'feature')):end-2);
featurename=functionfilename(max(strfind(functionfilename,'feature')):end-2);

% Save the feature:
featurefolderfilename=[trackfolder,featurename,'.mat'];
save(featurefolderfilename,'featurevec');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % function feature00_generic_parameter()

































