function [nwwin_x,nwwin_y,nwwin_width,nwwin_height]=get_nw_region()
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Folder:
% alldata_actin_arp_cp:

% Define the network position window 
% (nwwin_x, nwwin_y, nwwin_width, nwwin_height):
% 01_actin_sample_2_(day3)_1:
nwwin_x(1,1)=93;
nwwin_y(1,1)=143;
nwwin_width(1,1)=170;
nwwin_height(1,1)=nwwin_width(1,1);
nwwin_x(1,2)=512;
nwwin_y(1,2)=154;
nwwin_width(1,2)=170;
nwwin_height(1,2)=nwwin_width(1,2);
% 02_actin_sample_3_(day3)_1:
nwwin_x(2,1)=96;
nwwin_y(2,1)=138;
nwwin_width(2,1)=nwwin_width(1,1);
nwwin_height(2,1)=nwwin_width(2,1);
nwwin_x(2,2)=510;
nwwin_y(2,2)=158;
nwwin_width(2,2)=nwwin_width(1,2);
nwwin_height(2,2)=nwwin_width(2,2);
% 03_actin_sample_1_(07-08_week_day_1)_1:
nwwin_x(3,1)=77;
nwwin_y(3,1)=145;
nwwin_width(3,1)=nwwin_width(1,1);
nwwin_height(3,1)=nwwin_width(2,1);
nwwin_x(3,2)=492;
nwwin_y(3,2)=167;
nwwin_width(3,2)=nwwin_width(1,2);
nwwin_height(3,2)=nwwin_width(2,2);
% 04_actin_sample_2_(07-08_week_day_1)_1:
nwwin_x(4,1)=92;
nwwin_y(4,1)=146;
nwwin_width(4,1)=nwwin_width(1,1);
nwwin_height(4,1)=nwwin_width(2,1);
nwwin_x(4,2)=500;
nwwin_y(4,2)=158;
nwwin_width(4,2)=nwwin_width(1,2);
nwwin_height(4,2)=nwwin_width(2,2);
% 05_actin_sample_3_(07-08_week_day_1)_1:
nwwin_x(5,1)=104;
nwwin_y(5,1)=130;
nwwin_width(5,1)=nwwin_width(1,1);
nwwin_height(5,1)=nwwin_width(2,1);
nwwin_x(5,2)=509;
nwwin_y(5,2)=167;
nwwin_width(5,2)=nwwin_width(1,2);
nwwin_height(5,2)=nwwin_width(2,2);
% 06_arp_sample_1_(day2)_2:
nwwin_x(6,1)=90;
nwwin_y(6,1)=138;
nwwin_width(6,1)=nwwin_width(1,1);
nwwin_height(6,1)=nwwin_width(2,1);
nwwin_x(6,2)=500;
nwwin_y(6,2)=148;
nwwin_width(6,2)=nwwin_width(1,2);
nwwin_height(6,2)=nwwin_width(2,2);
% 07_arp_sample_2_(day2)_1:
nwwin_x(7,1)=99;
nwwin_y(7,1)=147;
nwwin_width(7,1)=nwwin_width(1,1);
nwwin_height(7,1)=nwwin_width(2,1);
nwwin_x(7,2)=510;
nwwin_y(7,2)=161;
nwwin_width(7,2)=nwwin_width(1,2);
nwwin_height(7,2)=nwwin_width(2,2);
% 08_arp_sample_3_(day2)_1:
nwwin_x(8,1)=107;
nwwin_y(8,1)=137;
nwwin_width(8,1)=nwwin_width(1,1);
nwwin_height(8,1)=nwwin_width(2,1);
nwwin_x(8,2)=525;
nwwin_y(8,2)=162;
nwwin_width(8,2)=nwwin_width(1,2);
nwwin_height(8,2)=nwwin_width(2,2);
% 09_arp_sample_3_(day2)_2:
nwwin_x(9,1)=107;
nwwin_y(9,1)=135;
nwwin_width(9,1)=nwwin_width(1,1);
nwwin_height(9,1)=nwwin_width(2,1);
nwwin_x(9,2)=523;
nwwin_y(9,2)=165;
nwwin_width(9,2)=nwwin_width(1,2);
nwwin_height(9,2)=nwwin_width(2,2);
% 10_cp_sample_6_(day2)_1:
nwwin_x(10,1)=70;
nwwin_y(10,1)=139;
nwwin_width(10,1)=nwwin_width(1,1);
nwwin_height(10,1)=nwwin_width(2,1);
nwwin_x(10,2)=488;
nwwin_y(10,2)=152;
nwwin_width(10,2)=nwwin_width(1,2);
nwwin_height(10,2)=nwwin_width(2,2);
% 11_cp_sample_8_(day2)_1:
nwwin_x(11,1)=113;
nwwin_y(11,1)=151;
nwwin_width(11,1)=nwwin_width(1,1);
nwwin_height(11,1)=nwwin_width(2,1);
nwwin_x(11,2)=525;
nwwin_y(11,2)=162;
nwwin_width(11,2)=nwwin_width(1,2);
nwwin_height(11,2)=nwwin_width(2,2);
% 12_cp_sample_9_(day2)_1:
nwwin_x(12,1)=100;
nwwin_y(12,1)=145;
nwwin_width(12,1)=nwwin_width(1,1);
nwwin_height(12,1)=nwwin_width(2,1);
nwwin_x(12,2)=511;
nwwin_y(12,2)=160;
nwwin_width(12,2)=nwwin_width(1,2);
nwwin_height(12,2)=nwwin_width(2,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % function get_nw_region()