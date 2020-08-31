% lonlim = [10 40];
% latlim = [65 80]; 

%%%% reads sediment load files from ASCII
xy_map = load('00_15_semi_wide.dat');


% figure(1)
% scatter(xy_map(:,1),xy_map(:,2),3,xy_map(:,3))

%%

[xq,yq] = meshgrid(200000:10000:2000000, 7400000:10000:9000000);
vq = griddata(xy_map(:,1),xy_map(:,2),xy_map(:,3),xq,yq);

% figure(2)
% mesh(xq,yq,vq);


deg_lon = zeros(size(xq));
deg_lat = zeros(size(yq));
size_vq = size(vq);


for a = 1:size_vq(1,1)
    for b = 1:size_vq(1,2)
    [Lat,Lon] = utm2deg(xq(a,b),yq(a,b),set_zone);
    deg_lat(a,b) = Lat;
    deg_lon(a,b) = Lon;
    end
end


thickness_matrix = zeros(size_vq(1,1),size_vq(1,2),3);
thickness_matrix(:,:,1) = deg_lon;
thickness_matrix(:,:,2) = deg_lat;
thickness_matrix(:,:,3) = vq;


f=15/180;

[xt,yt] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wt = griddata(thickness_matrix(:,:,1),thickness_matrix(:,:,2),thickness_matrix(:,:,3),xt,yt);

size_wt = size(wt);
reg_thickness_matrix = zeros(size_wt(1,1),size_wt(1,2),3);
reg_thickness_matrix(:,:,1) = xt;
reg_thickness_matrix(:,:,2) = yt;
reg_thickness_matrix(:,:,3) = wt;


save('reg_thickness_matrix.mat', 'reg_thickness_matrix')

% figure(3)
% contourf(xt,yt,wt)


%%%% Calculates repleaced water

load('Z_sl.mat') %topo after sea level change
load('Zw_sl.mat') %isostatic response to sea level change

Z_sl_corr = Z_sl + Zw_sl; %topo after sea level change corrected for isostasy

% figure(4)
% contourf(xt,yt,Z_sl)

% figure(5)
% contourf(xt,yt,Z_sl_corr)


% calculate thickness of repleaced water
repleaced_water = zeros(size(wt));
for a = 1:180
    for b = 1:360
        if Z_sl_corr(a,b)<0 %only for offshore
            if wt(a,b)<0 %where deposition
                if -Z_sl_corr(a,b)>-wt(a,b)
                    repleaced_water(a,b) = -wt(a,b); %positive value
                else
                    repleaced_water(a,b) = -Z_sl_corr(a,b); %positive value
                end
            else %where erosion
                repleaced_water(a,b) = -wt(a,b); %negative value
            end
        else
            repleaced_water(a,b) = 0;
        end
    end
end
        

% figure(6)
% contourf(xt,yt,repleaced_water);
% title('Repleaced water thickness')


%%%% THIS PART CREATES XYZ MAP INSTEAD FOR MATRIX %%%% 
xt_size = size(xt);

base_map = zeros(xt_size(1,1)*xt_size(1,2),3);
max_b = xt_size(1,2);

a = 1;
for b=1:max_b
    a = 1;
while a<=xt_size(1,1);
    base_map(a+(b-1)*xt_size(1,1),1) = yt(a,b);
    base_map(a+(b-1)*xt_size(1,1),2) = xt(a,b);
    base_map(a+(b-1)*xt_size(1,1),3) = repleaced_water(a,b);
    a=a+1;    
end
end

% figure(7)
% scatter(base_map(:,2),base_map(:,1),10,base_map(:,3))

%%%%%%%%%%%%%%%%%%%%%%%%%
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


xy_map(:,1) = xy_map(:,1)/1000;
xy_map(:,2) = xy_map(:,2)/1000;

xmin_xy_map = min(xy_map(:,1));
ymin_xy_map = min(xy_map(:,2));

xy_map(:,1) = xy_map(:,1) - xmin_xy_map;
xy_map(:,2) = xy_map(:,2) - ymin_xy_map;

load_contours = zeros(size(base_map));
load_contours(:,1) = xy_map(:,1);
load_contours(:,2) = xy_map(:,2);
load_contours(:,3) = base_map(:,3)/1000;
dlmwrite('loadcontours.txt',load_contours,'\t')

% figure(8)
% scatter(load_contours(:,1),load_contours(:,2),3,load_contours(:,3))
