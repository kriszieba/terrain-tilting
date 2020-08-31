clear all

% loads ASCII point map
map = load('00_07.dat');
lon = map(:,1);
lat= map(:,2);
th = map(:,3);

figure(1)
scatter(lon,lat,3,th);
colorbar

%% creates a local system where S- and E-most point = 0
min_lat = min(min(lat)); %7.476830307763000e+06
min_lon = min(min(lon)); %-2.565479409000000e+03

loc = zeros(size(map));

loc(:,1) = (lon(:,1) - min_lon)/1000;
loc(:,2) = (lat(:,1) - min_lat)/1000;
loc(:,3) = th(:,1)/1000;

figure(2)
scatter(loc(:,1),loc(:,2),3,loc(:,3));
colorbar

% saves map as ASCII file in XYZ reference system. X, Y and Z in
% [km]
dlmwrite('loadcontours.txt',loc,'\t')