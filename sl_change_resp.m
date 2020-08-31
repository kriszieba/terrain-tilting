%Writes SL change isostatic effect
load('sl_deflection_matrix.mat')

f=15/180;

[xs,ys] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
Zw_sl = griddata(sl_deflection_matrix(:,:,1),sl_deflection_matrix(:,:,2),-sl_deflection_matrix(:,:,3),xs,ys);

save('Zw_sl.mat', 'Zw_sl')