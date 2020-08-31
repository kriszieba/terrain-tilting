xy_map = load('00_15_semi_wide.dat');

xy_map(:,1) = xy_map(:,1)/1000;
xy_map(:,2) = xy_map(:,2)/1000;

% figure(1)
% scatter(xy_map(:,1),xy_map(:,2),3,xy_map(:,3))


xmin_xy_map = min(xy_map(:,1));
ymin_xy_map = min(xy_map(:,2));

xy_map(:,1) = xy_map(:,1) - xmin_xy_map;
xy_map(:,2) = xy_map(:,2) - ymin_xy_map;


load_contours = zeros(size(xy_map));
load_contours(:,1) = xy_map(:,1);
load_contours(:,2) = xy_map(:,2);
load_contours(:,3) = xy_map(:,3)/1000;
dlmwrite('loadcontours.txt',load_contours,'\t')

% figure(8)
% scatter(load_contours(:,1),load_contours(:,2),3,load_contours(:,3))