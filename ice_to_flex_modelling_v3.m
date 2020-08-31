base_map = load('ice_map.txt');


xy_map = zeros(size(base_map));

% lcm = 0.1571;
% set_zone = '32 V';
                
for a = 1:size(base_map)
    [N,E,Zone,lcm]=ell2utm(base_map(a,1)*0.0174532925,base_map(a,2)*0.0174532925,lcm);
    xy_map(a,1) = E;
    xy_map(a,2) = N;
    xy_map(a,3) = Zone;
    xy_map(a,4) = lcm;
end

ice_map_in_utm = xy_map;
ice_map_in_utm(:,3) = base_map(:,3);
ice_map_in_utm(:,4) = [];


figure(1)
scatter(xy_map(:,1),xy_map(:,2),10,base_map(:,3))
dlmwrite('ice_map_in_utm.txt',ice_map_in_utm,'\t')

%%
xy_map(:,1) = xy_map(:,1)/1000;
xy_map(:,2) = xy_map(:,2)/1000;

% figure(1)
% scatter(xy_map(:,1),xy_map(:,2))

% map_data = zeros(4,1);
% map_data(1,1) = min(xy_map(:,1));
% map_data(2,1) = min(xy_map(:,2));
% map_data(3,1) = lcm;
% 
% map_zone = set_zone;
% 
% dlmwrite('map_data.txt',map_data,'\t')

xmin_xy_map = min(xy_map(:,1));
ymin_xy_map = min(xy_map(:,2));

xy_map(:,1) = xy_map(:,1) - xmin_xy_map;
xy_map(:,2) = xy_map(:,2) - ymin_xy_map;

% figure(3)
% scatter(xy_map(:,1),xy_map(:,2))

load_contours = zeros(size(base_map));
load_contours(:,1) = xy_map(:,1);
load_contours(:,2) = xy_map(:,2);
load_contours(:,3) = base_map(:,3)/1000;
dlmwrite('loadcontours.txt',load_contours,'\t')