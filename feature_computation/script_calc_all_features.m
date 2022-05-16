function script_calc_all_features
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mainfolder=['/mnt/partition/image_data/peters_sm_data/cp_arp_100ms_full/'];
mainfolder=['/home/bq_jweichsel/weichsel/scratchy/partition/image_data/peters_sm_data/automatic_classification/'];
mainfolder=['../../automatic_classification_data/arp_12_08_13_psf09/'];
mainfolder=['../../automatic_classification_data/new_additional_50-200nN_new/'];
mainfolder=['/home/bq_jweichsel/weichsel/scratchy/partition/image_data/peters_sm_data/new_additional_50-200nN/'];
mainfolder=['/home/bq_jweichsel/weichsel/scratchy/partition/image_data/peters_sm_data/data_29_07_14_scratchy/alldata_actin_arp_cp/'];

mintrackleng=0;
maxtrackleng=0; % 0 -> infinity

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get all subfolders to process:
dirinfo=dir(mainfolder);

folderind=3;
nfolderind=length(dirinfo);
%nfolderind=folderind;
while (folderind <= nfolderind)
    
    subfolder=dirinfo(folderind).name
    subfolder=[subfolder,'/'];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Remove all features that have been calculated previously for this
    % folder:
    mainfolder;
    subfolder;
    delete([mainfolder,subfolder,'tracking_results/feature*.mat']);    
    
    % Get the average background gray value for this image stack:
    background=get_background(mainfolder,subfolder);
    background

    % Calculate the track length, start and end frames for this folder:
    track_length_start_end(mainfolder,subfolder);
    
    % Calculate all features for this folder:
    feature01_linfit_slope(mainfolder,subfolder,mintrackleng,maxtrackleng,background);
    feature02_linfit_amplitude(mainfolder,subfolder,mintrackleng,maxtrackleng,background);
    feature03_amplitude_mean(mainfolder,subfolder,mintrackleng,maxtrackleng);
    feature04_amplitude_mean2(mainfolder,subfolder,mintrackleng,maxtrackleng);
    feature05_charact_exp(mainfolder,subfolder,mintrackleng,maxtrackleng,background);
    %feature06_iniamp_exp(mainfolder,subfolder,mintrackleng,maxtrackleng,background);
    feature07_amplitude_std(mainfolder,subfolder,mintrackleng,maxtrackleng);
    feature08_position_std(mainfolder,subfolder,mintrackleng,maxtrackleng);
    feature09_psf_std(mainfolder,subfolder,mintrackleng,maxtrackleng);
    feature10_pos_std(mainfolder,subfolder,mintrackleng,maxtrackleng);   
    feature11_pos_std2(mainfolder,subfolder,mintrackleng,maxtrackleng);   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    folderind=folderind+1;
    
end % while (folderind <= nfolderind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('ALL DONE!\n\n');
end % function script_calc_all_features

