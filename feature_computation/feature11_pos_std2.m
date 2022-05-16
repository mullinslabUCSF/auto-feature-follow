function feature11_pos_std2(mainfolder,subfolder,mintrackleng,maxtrackleng)
% 
% Extract track feature and save the results to a file;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Function arguments: 

% % Image main folder path:
% mainfolder=['/mnt/partition/image_data/peters_sm_data/cp_arp_100ms_full/'];
% subfolder=['sample 1 Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1% Arp2 _2/'];
% subfolder=['sample 1 Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1% Arp23/'];
% %subfolder=['sample 1 CP  644nM 30% 750EM 100ms 14bit 1.6opt 100x 0.1% CP/'];
% %subfolder=['sample 1 CP  644nM 30% 750EM 100ms 14bit 1.6opt 100x 0.1% CP 2/'];
% %subfolder=['sample 4 LAT Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1%  Arp23 1/'];
% subfolder=['sample 4 LAT Arp23  561nM 50% 750EM 100ms 14bit 1.6opt 100x 0.1% Arp23 2/'];
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
    posxvec=tracksFinal(trackind).tracksCoordAmpCG(1:8:end);
    posyvec=tracksFinal(trackind).tracksCoordAmpCG(2:8:end);
    
    
    tracklengthhalf=round(tracklength/2)-1;
    posxstd_start=nanstd(posxvec(1:tracklengthhalf));
    posystd_start=nanstd(posyvec(1:tracklengthhalf));
    posstd_start=sqrt(posxstd_start^2+posystd_start^2);
    posxstd_end=nanstd(posxvec(tracklengthhalf+1:end));
    posystd_end=nanstd(posyvec(tracklengthhalf+1:end));
    posstd_end=sqrt(posxstd_end^2+posystd_end^2);
    feature=posstd_start/(posstd_start+posstd_end);
    
    featurevec(trackind)=feature;

%     end % if (startind > firstimage && endind < lastimage &&...
    
    trackind=trackind+1;
end % while (trackind <= numboftracks)

% Plot a histogram of this track feature:
if (plotfigure == 2)
    featurevechist=featurevec(find(featurevec~=-999));
    figure(2)
    clf
    hist(featurevechist,20)
end % if (plotfigure == 2)

%%%%%%%%      

% Define the fit functions:
function ydata=lin_fit_fun(par,xdata)
    ydata=par(1).*xdata+par(2);
end % function

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
































