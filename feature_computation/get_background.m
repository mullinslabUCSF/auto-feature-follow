function background=get_background(mainfolder,subfolder)
%
% Function to look up the average background of the given image stack.
% This information is stored in the Detection.mat file;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mainfolder;
auxind=strfind(mainfolder,'/');
stringfolder=mainfolder(auxind(end-1)+1:end-1);

if (strcmp(stringfolder,'arp_12_08_13_psf09'))
    % for arp_12_08_13_psf09 data only:
    fprintf('\nWARNING: image background information \nis only valid for data arp_12_08_13_psf09\n');

    subfolder;
    backgrounddir=[mainfolder, '../arp_12_08_13_psf09_background/'];
else
    backgrounddir=[mainfolder];
    
end % if (strcmp(stringfolder,'new_additional_50-200nN_new'))

dirinfobackgrounddir=dir([backgrounddir,'*_*']);
backgroundDetectionpath=[backgrounddir,subfolder,...
        '/tracking_results/Detection.mat'];
auxback=load(backgroundDetectionpath);
backgroundmat=auxback.background;
size(backgroundmat);
max(backgroundmat);
min(backgroundmat);
background=mean(backgroundmat);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % function backgrounderg=get_background()