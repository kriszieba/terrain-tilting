% lonlim = [10 40];
% latlim = [65 80]; 

if sea_level_change == 1;
    load('Z_sl.mat') %topo afer sl change (without isostasy)
    load('Zw_sl.mat') %isostatic response to sea level change
    Z_sl_corr = Z_sl + Zw_sl; %topo after sea level change corrected for isostasy
elseif sea_level_change == 0;
    load('past_topo_matrix.mat') %loading topo without SL change
    Z_sl_corr = past_topo_matrix(:,:,3);
end

load('thickness_matrix.mat'); %ice thickness
f=15/180;
[xt,yt] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wt = griddata(thickness_matrix(:,:,1),thickness_matrix(:,:,2),thickness_matrix(:,:,3),xt,yt);


% calculate thickness of repleaced water
repleaced_water = zeros(size(wt));
for a = 1:180
    for b = 1:360
        if Z_sl_corr(a,b)<0 %if offshore
            if -Z_sl_corr(a,b)<wt(a,b) %if ice is thicker than water depth
                repleaced_water(a,b) = -Z_sl_corr(a,b); %displaced water = water depth
            else
                repleaced_water(a,b) = wt(a,b); %displaced water = ice thickness
            end
        else
            repleaced_water(a,b) = 0;
        end
    end
end
        

% figure(1)
% contourf(xt,yt,Z_sl)

% figure(1)
% contourf(xt,yt,wt)
% 
% figure(2)
% contourf(xt,yt,Z_sl_corr)
% 
%     
% figure(3)
% contourf(xt,yt,repleaced_water);

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

% figure(2)
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
