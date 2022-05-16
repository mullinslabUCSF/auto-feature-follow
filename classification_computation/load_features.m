function feature_matrix=load_features(mainfolder,subfolder,featureindvec)
%
% Columns of feature_matrix are the different features;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mainfolder;
subfolder;
tracksubfolder=['tracking_results/'];

% Get the features which are available:
dirinfo=dir([mainfolder,subfolder,tracksubfolder,'feature*.mat']);
dirinfo.name;

ifeat=1;
nifeat=length(dirinfo);
featmatrixind=1;
while (ifeat <= nifeat)
    featurefilename=dirinfo(ifeat).name;
    featurenumber=str2num(featurefilename(8:9));
    
    if (max(featureindvec==featurenumber) == 1)
        featurenowstruct=load([mainfolder,subfolder,tracksubfolder,featurefilename]);
        featurenow=featurenowstruct.featurevec;
        feature_matrix(:,featmatrixind)=featurenow;
        featmatrixind=featmatrixind+1;
    end % if (max(featureindvec==featurenumber) == 1)
    
    ifeat=ifeat+1;
end % while (ifeat <= nifeat)
size(feature_matrix);
feature_matrix;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % function load_features();