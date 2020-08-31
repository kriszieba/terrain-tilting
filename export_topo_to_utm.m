%Writes topography after sea level change and writes difference thickness
%between present day and past sea level

clear all
close all

ice_response = 0;
load_response = 1;
sea_level_change = 1;
load_past_topo = 1;

% INPUT
latlim = [65 80];
lonlim = [10 40];
lcm = 0.1571;
set_zone = '32 V';


[Z, refvec] = etopo('etopo5.dat', 1, latlim, lonlim);


figure(1)
geoshow(Z, refvec, 'DisplayType', 'surface');
demcmap(Z);
title('Initial topo')



%%%% THIS PART CREATES XYZ MAP INSTEAD FOR MATRIX %%%% 
f=15/180;
[xt,yt] = meshgrid(10.04:f:39.96, 65.04:f:79.96);  
    
xt_size = size(xt);

base_map = zeros(xt_size(1,1)*xt_size(1,2),3);
max_b = xt_size(1,2);

a = 1;
for b=1:max_b
    a = 1;
while a<=xt_size(1,1);
    base_map(a+(b-1)*xt_size(1,1),1) = yt(a,b);
    base_map(a+(b-1)*xt_size(1,1),2) = xt(a,b);
    base_map(a+(b-1)*xt_size(1,1),3) = Z(a,b);
    a=a+1;    
end
end

figure(4)
scatter(base_map(:,2),base_map(:,1),10,base_map(:,3))

%%%%%%%%%%%%%%%%%%%%%%%%%
xy_map = zeros(size(base_map));

                
for a = 1:size(base_map)
    [N,E,Zone,lcm]=ell2utm(base_map(a,1)*0.0174532925,base_map(a,2)*0.0174532925,lcm);
    xy_map(a,1) = E;
    xy_map(a,2) = N;
    xy_map(a,3) = Zone;
    xy_map(a,4) = lcm;
end

xy_map(:,1) = xy_map(:,1);
xy_map(:,2) = xy_map(:,2);


load_contours = zeros(size(base_map));
load_contours(:,1) = xy_map(:,1);
load_contours(:,2) = xy_map(:,2);
load_contours(:,3) = base_map(:,3);
dlmwrite('topo_utm.txt',load_contours,'\t')

figure(5)
scatter(load_contours(:,1), load_contours(:,2), 3, load_contours(:,3))
