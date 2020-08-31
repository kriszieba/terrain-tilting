%%%% SL effect
load('sl_deflection_matrix.mat')

f=15/180;

[xs,ys] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
ws = griddata(sl_deflection_matrix(:,:,1),sl_deflection_matrix(:,:,2),-sl_deflection_matrix(:,:,3),xs,ys);

%%%% Water displacement effect
load('water_deflection_matrix.mat')
f=15/180;
[xq,yq] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wq = griddata(water_deflection_matrix(:,:,1),water_deflection_matrix(:,:,2),water_deflection_matrix(:,:,3),xq,yq);

%%%% Load effect
load('deflection_matrix.mat')
[xr,yr] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wr = griddata(deflection_matrix(:,:,1),deflection_matrix(:,:,2),-deflection_matrix(:,:,3),xr,yr);

%%%% Final topo incl sl change
load('Z_sl.mat') %topo after SL change (without isostatic adjustment)
load('reg_thickness_matrix.mat'); %loads thickness
final_topo = Z_sl - reg_thickness_matrix(:,:,3) - wr+wq+ws;

%%%% calculates uncompensated water
uncomp_wd = zeros(size(Z_sl));
bath_filled = Z_sl+ws-reg_thickness_matrix(:,:,3);


for a=1:180
    for b= 1:360
        if reg_thickness_matrix(a,b,3) < 0 % in places where we had loads
            if final_topo(a,b) < 0 %if reconstructed topo is offshore
                if bath_filled(a,b) >= 0; %if filled bathymetry is above sealevel
                    uncomp_wd(a,b) = final_topo(a,b)*-1;
                else
                    uncomp_wd(a,b) = wr(a,b)-wq(a,b);
                end
            else
                uncomp_wd(a,b) = 0;
            end
        else
            uncomp_wd(a,b) = 0;
       end
    end
end

[xt,yt] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
figure(100)
contourf(xt, yt, uncomp_wd);
title('Uncompensated water')


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
    base_map(a+(b-1)*xt_size(1,1),3) = uncomp_wd(a,b);
    a=a+1;    
end
end


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

% figure(5)
% scatter(load_contours(:,1), load_contours(:,2), 3, load_contours(:,3))






