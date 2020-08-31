lonlim = [10 40];
latlim = [70 75]; 

load('r_coastline.mat')
load('r_struct.mat')
% load('coast_big.mat');
% load('r_struct.mat');
% 
% final_topo_15 = load('final_topo_15_split.txt');
% final_topo_04 = load('final_topo_04.txt');
% final_topo_00 = load('final_topo_00.txt');

topo_limits = [-3700 1000];

all_maps = 0;
show_loads = 0;
show_profiles = 0;

%%%% Present-day topo. Only for showing the map
% figure(1)
% [Z, refvec] = etopo('etopo5.dat', 1, latlim, lonlim);
% 
% worldmap(latlim, lonlim)
% geoshow(Z, refvec, 'DisplayType', 'surface');
% demcmap(Z);
% %demcmap(topo_limits,200);
% %plotm(r_struct(:,1),r_struct(:,2), 'LineWidth', 0.1, 'Color','w')
% title('Present day topo')


% figure(11) %alt to figure 1
% worldmap(latlim, lonlim)
% geoshow(Z, refvec, 'DisplayType', 'texturemap')
% geoshow(Z, refvec, 'DisplayType', 'contour','LevelStep', 50, 'ShowText', 'on', 'LabelSpacing', 200, 'LineColor', 'k', 'LineWidth', 0.1)
% demcmap('inc',topo_limits,50);
% %demcmap(topo_limits);
% %geoshow(coast_big(:,2),coast_big(:,1), 'DisplayType', 'polygon', 'FaceColor', 'w', 'EdgeColor', 'none');
% scaleruler('FontSize', 6, 'Color', 'w', 'MajorTick', 0:50:50, 'MinorTick', 0)

%%%% SL effect
load('sl_deflection_matrix.mat')
f=15/180;
[xs,ys] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
ws = griddata(sl_deflection_matrix(:,:,1),sl_deflection_matrix(:,:,2),-sl_deflection_matrix(:,:,3),xs,ys);

if all_maps == 1
figure(2)
worldmap(latlim, lonlim)
geoshow(ys,xs,ws, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('Sea level change effect')
end

%%%% Water displacement effect
load('water_deflection_matrix.mat')
f=15/180;
[xq,yq] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wq = griddata(water_deflection_matrix(:,:,1),water_deflection_matrix(:,:,2),water_deflection_matrix(:,:,3),xq,yq);

if all_maps == 1
figure(3)
worldmap(latlim, lonlim)
%contourf(xq,yq,wq,40);
geoshow(yq,xq,wq, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('Water displacement effect')
end

%%%% Load effect
load('deflection_matrix.mat')
[xr,yr] = meshgrid(10.04:f:39.96, 65.04:f:79.96);
wr = griddata(deflection_matrix(:,:,1),deflection_matrix(:,:,2),-deflection_matrix(:,:,3),xr,yr);

if all_maps == 1
figure(4)
worldmap(latlim, lonlim)
%contourf(xr,yr,wr,40);
geoshow(yr,xr,wr, 'DisplayType', 'surface');
hold on
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colorbar
title('Load effect')
end

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
final_deflection = -wr+wq+ws-wu;
%dlmwrite('final_deflection_15_made_from_00_15.txt',final_deflection,'\t')


figure(6)
worldmap(latlim, lonlim)
geoshow(ys,xs,-wr+wq+ws-wu, 'DisplayType', 'surface');
%geoshow(ys,xs,-wr+wq+ws-wu, 'DisplayType', 'contour', 'Fill', 'off', 'LevelStep', 50, 'LineColor', 'k', 'LineWidth', 0.1);
hold on
%plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
%plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
colormap(parula(16))
%colormap(deflection)
colorbar
caxis([-250 550])
title('All isostatic effects')

%%
mod_defl = load('final_deflection_04.txt');

figure(7)
worldmap(latlim, lonlim)
geoshow(ys,xs,mod_defl, 'DisplayType', 'contour','Fill', 'off', 'LevelStep', 50, 'ShowText', 'on', 'LineColor', 'k',  'LabelSpacing', 800, 'LineWidth', 0.1);
geoshow(ys,xs,mod_defl, 'DisplayType', 'surface')



if all_maps == 1


%%%% Final topo incl sl change
load('Z_sl.mat') %initial topo after SL change (without isostatic adjustment)
load('reg_thickness_matrix.mat'); %loads thickness

final_topo = Z_sl - reg_thickness_matrix(:,:,3) -wr+wq+ws-wu;

if all_maps == 1
figure(7) 
worldmap(latlim, lonlim)
geoshow(ys,xs,final_topo, 'DisplayType', 'surface');
%geoshow(ys,xs,final_topo, 'DisplayType', 'contour', 'Fill', 'on', 'LevelStep', 50, 'ShowText', 'off', 'LabelSpacing', 800, 'LineColor', 'k', 'LineWidth', 0.1)
%demcmap(final_topo);
demcmap(topo_limits,200);
hold on
plotm(r_coastline(:,1),r_coastline(:,2),1000, 'w')
plotm(r_struct(:,1),r_struct(:,2), 'LineWidth', 0.1, 'Color','w', 'LineStyle', '-')
title('Reconstructed topo at XX Ma')
end


%dlmwrite('final_topo_07.txt',final_topo,'\t')

%% Plotting maps from final_topo_XX files
load('MyColormaps','mycmap')
load('Pliocene3.dat')
load('Pliocene2.dat')
load('Pliocene1.dat')
load('Miocene.dat')

final_topo_15 = load('final_topo_15.txt');
final_topo_07 = load('final_topo_07.txt');
final_topo_04 = load('final_topo_04.txt');
final_topo_00 = load('final_topo_00.txt');

% zero_00=final_topo_00;
% zero_00(zero_00<0)=0;

figure(77) %alt map to fig 7
worldmap(latlim, lonlim)
geoshow(ys,xs,final_topo_15, 'DisplayType', 'surface');
%geoshow(ys,xs,final_topo_15, 'DisplayType', 'contour', 'Fill', 'off', 'LevelStep', 50, 'ShowText', 'off', 'LabelSpacing', 800, 'LineColor', 'k', 'LineWidth', 0.1)
%demcmap('inc',topo_limits,50);
%plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
%plotm(Pliocene3(:,2),Pliocene3(:,1),2000,'LineWidth', 1, 'Color','w')
%plotm(Pliocene2(:,2),Pliocene2(:,1),2000,'LineWidth', 1, 'Color','y')
%plotm(Pliocene1(:,2),Pliocene1(:,1),2000,'LineWidth', 1, 'Color','g')
%plotm(Miocene(:,2),Miocene(:,1),2000,'LineWidth', 1, 'Color','r')
ax = gca;
colormap(ax,mycmap)
caxis([-3700 1000])
scaleruler('FontSize', 6, 'Color', 'w', 'MajorTick', 0:50:50, 'MinorTick', 0)


%% Plotting profiles
if show_profiles == 1;
% cross section

final_topo_15 = load('final_topo_15.txt');
final_topo_04 = load('final_topo_04.txt');
final_topo_00 = load('final_topo_00.txt');

final_topo_grad_15 = gradient(final_topo_15);
final_topo_grad_04 = gradient(final_topo_04);
final_topo_grad_00 = gradient(final_topo_00);

figure(8)
%for 72N use xs(84,:)
%for 73N use xs(96-97,:)
%for 74N use xs(109,:)
scatter(xs(84,:), final_topo_15(84,:), 'r')
hold on
scatter(xs(84,:), final_topo_04(84,:), 'g')
scatter(xs(84,:), final_topo_00(84,:), 'k')

figure(9)
%for 72N use xs(84,:)
%for 73N use xs(96-97,:)
%for 74N use xs(109,:)
scatter(xs(84,:), final_topo_grad_15(84,:), 'r')
hold on
scatter(xs(84,:), final_topo_grad_04(84,:), 'g')
scatter(xs(84,:), final_topo_grad_00(84,:), 'k')
end
%% Plotting loads
if show_loads == 1
load('reg_thickness_matrix_04.mat'); %loads thickness    
%%%% loads
figure(9)
worldmap(latlim, lonlim)
%contourf(xu,yu,wu)
%geoshow(reg_thickness_matrix_04(:,:,2),reg_thickness_matrix_04(:,:,1),reg_thickness_matrix_04(:,:,3), 'DisplayType', 'texturemap');
%geoshow(reg_thickness_matrix(:,:,2),reg_thickness_matrix(:,:,1),reg_thickness_matrix(:,:,3), 'DisplayType', 'texturemap');
geoshow(reg_thickness_matrix(:,:,2),reg_thickness_matrix(:,:,1),reg_thickness_matrix(:,:,3), 'DisplayType', 'contour','Fill', 'off', 'LevelStep', 50, 'ShowText', 'on', 'LineColor', 'k',  'LabelSpacing', 800, 'LineWidth', 0.1);
%geoshow(reg_thickness_matrix_04(:,:,2),reg_thickness_matrix_04(:,:,1),reg_thickness_matrix_04(:,:,3),...
%'DisplayType', 'contour','Fill', 'off', 'LevelStep', 50, 'ShowText', 'off', 'LineColor', 'k',  'LabelSpacing', 800, 'LineWidth', 0.1);


hold on
%plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
%plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
caxis([-450 1600])
colormap(parula(41))
%colorbar
%title('Loads')
end

%contourf(reg_thickness_matrix(:,:,1),reg_thickness_matrix(:,:,2),reg_thickness_matrix(:,:,3))

% hold on
% lands = Z;
% lands(lands>0)=NaN;
% lands(lands<0)=0;
% contourf(xs,ys,lands)
% title('Loads')

%% Calculations
final_topo_15 = load('final_topo_15.txt');
final_topo_07 = load('final_topo_07.txt');
final_topo_00 = load('final_topo_00.txt');
figure(99) %alt map to fig 7
worldmap(latlim, lonlim)
geoshow(ys,xs,(-final_topo_00-(-final_topo_15+50))*-1, 'DisplayType', 'surface')
%geoshow(ys,xs,final_topo_00, 'DisplayType', 'surface')
%plotm(r_struct(:,1),r_struct(:,2), 2000,'LineWidth', 0.1, 'Color','w')
%geoshow(ys,xs,tot_loads, 'DisplayType', 'contour','LevelStep', 50,'Color','k', 'ShowText', 'off','LabelSpacing', 800,'LineWidth', 0.1)
%demcmap('inc',topo_limits,50);
%demcmap([-2000,1000],400);


%caxis([-500 20])
%geoshow(ys,xs,final_topo_00, 'DisplayType', 'contour', 'Fill', 'off', 'LevelStep', 50, 'ShowText', 'off', 'LabelSpacing', 800, 'LineColor', 'k', 'LineWidth', 0.1)
%plotm(r_struct(:,1),r_struct(:,2),1000, 'LineWidth', 0.1, 'Color','w', 'LineStyle', '-')
%demcmap('inc',[-700,400],10);
end

%%
deflect = load('final_deflection_15_made_from_00_15.txt');
figure(2)
worldmap(latlim, lonlim)
geoshow(ys,xs,deflect, 'DisplayType', 'contour','Fill', 'off', 'LevelStep', 50, 'ShowText', 'on', 'LineColor', 'k',  'LabelSpacing', 800, 'LineWidth', 0.1);
geoshow(ys,xs,deflect, 'DisplayType', 'surface');
plotm(r_coastline(:,1),r_coastline(:,2),2000, 'w');
