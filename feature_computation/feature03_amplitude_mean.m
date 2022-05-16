function feature03_amplitude_mean(mainfolder,subfolder,mintrackleng,maxtrackleng)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the feature for each track:
featurevec(1:numboftracks)=-999;
trackind=1;
numboftracks;
usedtracks=0;
while (trackind <= numboftracks)
    
    amplitudevec=tracksFinal(trackind).tracksCoordAmpCG(4:8:end);
    tracklength=length(amplitudevec);
    startind=tracksFinal(trackind).seqOfEvents(1,1);
    endind=tracksFinal(trackind).seqOfEvents(2,1); 
%     if (startind > firstimage && endind < lastimage &&...
%         tracklength > mintrackleng &&...
%         (tracklength < maxtrackleng || maxtrackleng == 0))
    
    usedtracks=usedtracks+1; % Update the number of evaluated tracks 
    
    % Calculate the feature:
    feature=nanmean(amplitudevec);
    normalizervec(usedtracks)=feature;
        
    featurevec(trackind)=feature;
        
%     end % if (startind > firstimage && endind < lastimage &&...
    
    trackind=trackind+1;
end % while (trackind <= numboftracks)

auxinds=find(featurevec~=-999);
%featurevec(auxinds)=featurevec(auxinds)./median(normalizervec);


% Plot a histogram of this track feature:
if (plotfigure == 2)
    featurevechist=featurevec(find(featurevec~=-999));
    figure(2)
    clf
    hist(featurevechist,40)
    xlim([0 5])
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

































