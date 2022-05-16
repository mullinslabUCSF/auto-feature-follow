# auto-feature-follow
Track Features:
1. linfit_slope: slope of the linear fit of the log intensity profile over normalized time
2. linfit_amplitude: background corrected exp of the constant of the linear fit of the log intensity
profile over normalized time
3. amplitude_mean: mean amplitude of each track (normalized by the median amplitude of all
tracks on the image stack)
4. amplitude_mean2: mean amplitude of the first half of the track over the sum of the mean of
amplitude for the second half and the first half;
5. charact_exp: characteristic parameter in the exponential fit of the (background corrected)
track amplitude over time
6. (iniamp_exp: initial intensity (at t=0) from the exponential fit of the (background corrected)
track amplitude over time)
7. amplitude_std: std of amplitude for the first half of the track over the sum of the std of
amplitude for the second half and the first half.
8. position_std: std of the x-, y-position over time
9. psf_std: linear slope of the std of the position over time (i.e. spot diameter increases for out of
focus particles)
10. pos_std: std of the position;
11. pos_std2: std of the position for the first half of the track over the sum of the std of position
for the second half and the first half;
