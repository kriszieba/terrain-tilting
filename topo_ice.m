lonlim = [10 40];
latlim = [70 75]; 
sea_level_change = 1;

load('r_coastline.mat')
load('r_struct.mat')
topo_limits = [-1200 500];


%%%% Initial topo
if sea_level_change == 0;
    load('past_topo_matrix.mat') %loading topo without SL change
    [xs,ys] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
    Z = past_topo_matrix(:,:,3);
    figure(1)
    worldmap(latlim, lonlim)
    geoshow(ys,xs,Z, 'DisplayType', 'surface');
    %demcmap(Z);
    demcmap(topo_limits,200);
    plotm(r_struct(:,1),r_struct(:,2), 'LineWidth', 0.1, 'Color','w')
    title('Initial topo')
else
    figure(1)
    [Z, refvec] = etopo('etopo5.dat', 1, latlim, lonlim);
    worldmap(latlim, lonlim)
    geoshow(Z, refvec, 'DisplayType', 'surface');
    %demcmap(Z);
    demcmap(topo_limits,200);
    plotm(r_struct(:,1),r_struct(:,2), 'LineWidth', 0.1, 'Color','w')
    title('Present-day topo')
end
%%

%%%% SL effect
load('sl_deflection_matrix.mat')
if sea_level_change == 1;
f=15/180;
[xs,ys] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
ws = griddata(sl_deflection_matrix(:,:,1),sl_deflection_matrix(:,:,2),-sl_deflection_matrix(:,:,3),xs,ys);
else
   [xs,ys] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
   ws=zeros(size(xs));
   ws(:,:) = 0;
end

figure(2)
worldmap(latlim, lonlim)
geoshow(ys,xs,ws, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('Sea level change effect')

%%%% Water displacement effect
load('water_deflection_matrix.mat')
f=15/180;
[xq,yq] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wq = griddata(water_deflection_matrix(:,:,1),water_deflection_matrix(:,:,2),water_deflection_matrix(:,:,3),xq,yq);

figure(3)
worldmap(latlim, lonlim)
%contourf(xq,yq,wq,40);
geoshow(yq,xq,wq, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('Water displacement effect')

%%%% Load effect
load('deflection_matrix.mat')
[xr,yr] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wr = griddata(deflection_matrix(:,:,1),deflection_matrix(:,:,2),deflection_matrix(:,:,3),xr,yr);

figure(4)
worldmap(latlim, lonlim)
%contourf(xr,yr,wr,40);
geoshow(yr,xr,wr, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('Load effect')

%%%% Created water effect
load('uncomp_water_deflection_matrix.mat');
[xu,yu] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wu = griddata(uncomp_water_deflection_matrix(:,:,1),uncomp_water_deflection_matrix(:,:,2),uncomp_water_deflection_matrix(:,:,3),xr,yr);

figure(5)
worldmap(latlim, lonlim)
%contourf(xu,yu,wu)
geoshow(yu,xu,wu, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('Created water effect')

%%%% Total effect of SL change, water repleacement, loading effect and
%%%% created water
figure(6)
worldmap(latlim, lonlim)
%geoshow(-wr+wq+ws-wu,refvec, 'DisplayType', 'surface');
geoshow(ys,xs,-wr+wq+ws-wu, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('All isostatic effects')

%%%% Final topo incl sl change
if sea_level_change == 0;
    final_topo = Z-wr+wq+ws-wu;
else
    load('Z_sl.mat')
    final_topo = Z_sl-wr+wq+ws-wu; %CHECK THE SIGNS
end
load('thickness_matrix.mat') %ice thickness matrix

figure(7) 
worldmap(latlim, lonlim)
geoshow(ys,xs,final_topo, 'DisplayType', 'surface');
%demcmap(final_topo);
demcmap(topo_limits,200);
hold on
[c,h] = contourm(thickness_matrix(:,:,2),thickness_matrix(:,:,1),thickness_matrix(:,:,3),'LevelStep', 100, 'LabelSpacing', 2000, 'LineWidth', 1);
ht = clabelm(c,h);
set(ht,'Color','w','BackgroundColor','none','FontWeight','normal')
plotm(r_coastline(:,1),r_coastline(:,2), 'w')
plotm(r_struct(:,1),r_struct(:,2), 'LineWidth', 0.1, 'Color','w', 'LineStyle', '-')

title('Reconstructed topo below ice sheet')

% %% constructing study area polygon
% load('area_outline.mat') %appears as x
% utm_x = size(x);
% lcm = 0.1571;
% set_zone = '32 V';
% 
% for a = 1:699
% [utm_x(a,2),utm_x(a,1),utm_x(a,3),lcm]=ell2utm(x(a,2)*0.0174532925,x(a,1)*0.0174532925,lcm);
% end
% 
% dlmwrite('outline.txt',utm_x,'delimiter','\t')
% 
% figure(200)
% scatter(utm_x(:,2),utm_x(:,1))

%% alt isostatic response map
figure(8)
worldmap(latlim, lonlim)
geoshow(ys,xs,-wr+wq+ws-wu, 'DisplayType', 'surface');
geoshow(ys,xs,-wr+wq+ws-wu, 'DisplayType', 'contour','Fill', 'off', 'LevelStep', 50, 'ShowText', 'on', 'LineColor', 'k',  'LabelSpacing', 800, 'LineWidth', 1);
demcmap(-wr+wq+ws-wu,200,bone,jet)

hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
%plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.5, 'Color','w')
colorbar
title('All isostatic effects')
