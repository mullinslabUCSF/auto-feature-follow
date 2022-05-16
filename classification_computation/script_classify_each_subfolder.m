function script_classify_each_subfolder
%
% This function uses a random forest supervised classification method to
% classify productive and unproductive Arp tracks. The automatic
% classification is trained by the manual classification from experts.
fprintf('\n\nscript_classify_each_subfolder.m\n\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mainfolder_training=['../../automatic_classification_data/arp_12_08_13_psf09/'];
%mainfolder_class=['../../automatic_classification_data/new_additional_50-200nN_new/'];
mainfolder_class=['/home/bq_jweichsel/weichsel/scratchy/partition/image_data/peters_sm_data/data_29_07_14_scratchy/alldata_actin_arp_cp/'];

featureindvec=[1,2,3,4,5,7,8,9,10,11];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

randseed=1;
if (randseed ~= 0)
    rand('seed',randseed);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Training:
fprintf('  Training the random forest;\n')

% Get dir info of all subfolders to process:
mainfolder_training;
dirinfo=dir(mainfolder_training);
dirinfo=dirinfo(3:end);
dirinfo.name;
folderixvec=1:length(dirinfo);

% Initialize variables:
feature_matrix=0;
classvec=0;

% Load features and classification data of all folders given in folderixvec
% and combine in a single featurematrix and classvector:
fprintf('     Loading the training data;\n');
fprintf('     Training folder %s ;\n',mainfolder_training);
folderind=1;
nfolderind=length(folderixvec);
%nfolderind=folderind  
while (folderind <= nfolderind)

    subfolder=dirinfo(folderixvec(folderind)).name;
    subfolder=[subfolder,'/'];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mainfolder_training;
    subfolder;
    
    % Load the features:
    feature_matrix_now=load_features(mainfolder_training,subfolder,featureindvec);
    size(feature_matrix_now);
    
    % Load the manual classification:
    tracksubfolder=['tracking_results/'];
    load([mainfolder_training,subfolder,tracksubfolder,'Tracking_class.mat']);
    tracksFinalclass;
    classvec_now=0;
    nwindvec_now=0;
    i=1;
    ni=length(tracksFinalclass);
    while (i <= ni)
        classvec_now(i)=tracksFinalclass(i).class;
        nwindvec_now(i)=tracksFinalclass(i).nwind;
        i=i+1;
    end % while (i <= ni)
    size(classvec_now);

%     % Only use tracks of a given minimum length:
%     minlength=20; % Parameter to set the minimum track length used;
%     classvec_now_backup=classvec_now;
%     nwindvec_now_backup=nwindvec_now;
%     feature_matrix_now_backup=feature_matrix_now;
%     classvec_now=0;nwindvec_now=0;feature_matrix_now=0;
%     i=1;
%     ni=length(tracksFinalclass);
%     dummytrackind=0;
%     while (i <= ni)
%         amplitudevec=tracksFinalclass(i).tracksCoordAmpCG(4:8:end);
%         trackleng=length(amplitudevec);
%         classvec_now_backup(i);
%         nwindvec_now_backup(i);
%         if (trackleng >= minlength)
%             dummytrackind=dummytrackind+1;
%             classvec_now(dummytrackind)=classvec_now_backup(i);
%             nwindvec_now(dummytrackind)=nwindvec_now_backup(i);
%             feature_matrix_now(dummytrackind,1:size(feature_matrix_now_backup,2))=...
%                 feature_matrix_now_backup(i,:);
%         end
%         i=i+1;
%     end % while (i <= ni)
%     size(classvec_now);
%     size(feature_matrix_now);

    % Append features and classvec to exisitng matrix/vector:
    classvec_now=classvec_now';
    nwindvec_now=nwindvec_now';
    if (feature_matrix == 0)
        feature_matrix=feature_matrix_now;
    else
        feature_matrix=[feature_matrix;feature_matrix_now];
    end % if (feature_matrix == 0)
    size(feature_matrix);
    if (classvec == 0)
        classvec=classvec_now;
        nwindvec=nwindvec_now;
        folderindvec(1:length(nwindvec_now))=folderixvec(folderind);
    else
        classvec=[classvec;classvec_now];
        nwindvec=[nwindvec;nwindvec_now];
        folderindvec(end+1:end+length(nwindvec_now))=folderixvec(folderind);
    end % if (classvec == 0)
    size(classvec);
    size(nwindvec);
    size(folderindvec);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    folderind=folderind+1;
    %fprintf('---------------------\n');
    %pause(1)
    %pause 
end % while (folderind <= nfolderind)

% Prepare data for training:
% Only use productive and nonproductive tracks that where actually 
% classified, 
% i.e. either nwindvec == 1 (left) or nwindvec == 2 (right) 
% (or nwindvec ~= 3 (both))
validtrackix=find(nwindvec == 1);
size(validtrackix);
feature_matrix=feature_matrix(validtrackix,:);
classvec=classvec(validtrackix);
nwindvec=nwindvec(validtrackix);
folderindvec=folderindvec(validtrackix);

size(feature_matrix);
size(classvec);
size(nwindvec);
size(folderindvec);

%%%%%%%%%%%%%%%%%%

% Train the classifier:
fprintf('      Training the classifier;\n');

% Randomly permute all samples:
permutationix=randperm(length(classvec));
classvec=classvec(permutationix);
folderindvec=folderindvec(permutationix);
feature_matrix=feature_matrix(permutationix,:);
size(feature_matrix);
size(classvec);
classvec;
folderindvec;

% Use the same number of cases for each class for training and
% classification:
class1ixs=find(classvec == 1);
lengcl1ixs=length(class1ixs);
class2ixs=find(classvec == 2);
lengcl2ixs=length(class2ixs);
if (lengcl1ixs >= lengcl2ixs)
    class1ixs=class1ixs(1:lengcl2ixs);
else
    class2ixs=class2ixs(1:lengcl1ixs);
end
length(class1ixs);
length(class2ixs);
classvec=classvec([class1ixs;class2ixs]);
length(classvec);
feature_matrix=feature_matrix([class1ixs;class2ixs],:);
size(feature_matrix);
folderindvec=folderindvec([class1ixs;class2ixs]);
length(folderindvec);
folderindvec;

% Prepare for classification:
feature_matrix;
classvec;
size(feature_matrix);
size(classvec);
nsamples=length(classvec);

% Randomly permute all samples:
permutationix=randperm(length(classvec));
classvec=classvec(permutationix);
folderindvec=folderindvec(permutationix);
feature_matrix=feature_matrix(permutationix,:);
size(feature_matrix);
size(classvec);
size(folderindvec);
classvec;
folderindvec;

fprintf('      Number of training samples = %g;\n', nsamples);
fprintf('      Number of features = %g;\n', size(feature_matrix,2));

% Random forest classifier:
ntrees=100;
trainingparam=feature_matrix;
trainingclass=classvec;
TreeObject=...
    TreeBagger(ntrees,trainingparam,trainingclass,...
    'OOBPred','on','oobvarimp','on','FBoot',1);
TreeObject;
errorvec=oobError(TreeObject);
correctoobestimate=1-errorvec(end);
fprintf('      Out of the bag accuracy estimate = %g;\n', correctoobestimate);

% figure(3)
% plot(oobError(TreeObject))
% xlabel('number of grown trees')
% ylabel('out-of-bag classification error')
% figure(4);
% bar(TreeObject.OOBPermutedVarDeltaError);
% xlabel('Feature Number');
% ylabel('Out-Of-Bag Feature Importance');
% idxvar = find(TreeObject.OOBPermutedVarDeltaError>0.65)

fprintf('\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Classification:
fprintf('  Classifying each folder of the new data;\n')
fprintf('     Classification folder %s ;\n',mainfolder_class);

% Get all subfolders to process:
dirinfo=dir(mainfolder_class);
dirinfo=dirinfo(3:end);
dirinfo.name;

% Load the valid network regions:
[nwwin_x,nwwin_y,nwwin_width,nwwin_height]=get_nw_region();

folderind=1;
nfolderind=length(dirinfo);
%nfolderind=folderind
while (folderind <= nfolderind)

    subfolder=dirinfo(folderind).name;
    subfolder=[subfolder,'/'];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mainfolder_class;
    subfolder;

    % Load the features:
    feature_matrix=load_features(mainfolder_class,subfolder,featureindvec);
    size(feature_matrix);
    
    % Perform the classification:
    fprintf('     Classifying all tracks of subfolder\n     %s\n',subfolder);
    [YFITstr,scores] = predict(TreeObject,feature_matrix);
    i=1;
    ni=length(YFITstr);
    while (i <= ni)
        YFIT(i)=str2num(YFITstr{i});
        i=i+1;
    end % while (i <= ni)
    YFIT=YFIT';
    scores;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('       Finding the tracks inside nw area\n        and are long enough;\n');
    
    % Get the valid tracks:
    mintracklength=5;
    fprintf('       mintracklength = %g ;\n', mintracklength);
    
    track_folder=[mainfolder_class,subfolder,'tracking_results/'];
    load([track_folder,'Tracking.mat']);
    tracksFinal;
    
    trackind=1;
    ntrackind=length(tracksFinal);
    while (trackind <= ntrackind)
        nwindnow=3;
    
        startind=tracksFinal(trackind).seqOfEvents(1,1);
        endind=tracksFinal(trackind).seqOfEvents(2,1);
        trackleng=endind-startind+1;
    
        if (startind > 1 && trackleng >= mintracklength)
            % Find the network region, the track is located:
            xpos=tracksFinal(trackind).tracksCoordAmpCG(0*8+1);
            ypos=tracksFinal(trackind).tracksCoordAmpCG(0*8+2);
            
            indnwwind=1;
            nindnwind=length(nwwin_x(folderind,:));
            while (indnwwind <= nindnwind)
                if (xpos >= nwwin_x(folderind,indnwwind) && xpos <= nwwin_x(folderind,indnwwind)+nwwin_width(folderind,indnwwind)...
                 && ypos >= nwwin_y(folderind,indnwwind) && ypos <= nwwin_y(folderind,indnwwind)+nwwin_height(folderind,indnwwind))
                    nwindnow=indnwwind;
                    indnwwind=nindnwind+1;
                end % if ()
                indnwwind=indnwwind+1;
            end % while (indnwwind <= nindnwind)
            
        end % if (startind > firstimage && trackleng >= minlength)
        
        nwind(trackind)=nwindnow;
        
        trackind=trackind+1;
    end % while (trackind <= ntrackind)
    length(nwind);
    length(find(nwind~=3));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('       Creating the file Tracking_class.mat\n');
    nwind;
    class=YFIT;
    class(find(nwind == 3))=3;
    scores;
    scores(find(nwind == 3),:)=0;
    randseed;
        
    
    % Create the structure tracksFinalclass:
    tracksFinalclass=tracksFinal;
    i=1;
    ni=length(tracksFinalclass);
    while (i <= ni)
        tracksFinalclass(i).class=class(i);
        tracksFinalclass(i).nwind=nwind(i);
        tracksFinalclass(i).scores=scores(i,:);
        tracksFinalclass(i).randseed=randseed;      
        i=i+1;
    end % while (i <= ni)
    tracksFinalclass;
    save([track_folder,'Tracking_class.mat'],'tracksFinalclass');
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('\n');
    folderind=folderind+1;
end % while (folderind <= nfolderind)

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nALL DONE!\n\n');
end % function test_classify_arp_data