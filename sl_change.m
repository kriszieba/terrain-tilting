%Writes topography after sea level change and writes difference thickness
%between present day and past sea level

latlim = [65 80];
lonlim = [10 40];


if load_past_topo == 1
    Z=load('final_topo_07.txt');
    Z_sl = Z-sl; %topo after sl change
elseif load_past_topo == 0
    [Z, refvec] = etopo('etopo5.dat', 1, latlim, lonlim);
    Z_sl = Z-sl; %topo after sl change
end

save('Z_sl.mat', 'Z_sl');

% figure(1)
% geoshow(Z, refvec, 'DisplayType', 'surface');
% demcmap(Z);
% title('Initial topo')
% 
% figure(2)
% geoshow(Z_sl, refvec, 'DisplayType', 'surface');
% demcmap(Z);
% title('Topo after sea level change')

remo_wat = zeros(size(Z)); %creates matrix of removed water

size_Z = size(Z);
for a=1:size_Z(1,1)
    for b=1:size_Z(1,2)
        if sl < 0
        if Z(a,b) < 0 %for offshore areas
            if sl<0 %negarive sl change
                if Z(a,b) < sl %if water depth is higher than sl change
                    remo_wat(a,b) = sl;
                else
                    remo_wat(a,b) = Z(a,b);
                end
            else %positive sl change
                remo_wat(a,b) = -sl;
            end
        else
            remo_wat(a,b) = 0;
        end
        
        else %if sl>0
            if Z(a,b) < 0 %for offshore areas
                remo_wat(a,b) = sl;
            elseif Z(a,b) > 0 && Z(a,b) < sl %for onshore areas that are not above the new sea level
                remo_wat(a,b) = sl-Z(a,b);
            else
                remo_wat(a,b) = 0;
            end
        end
     end
end

% figure(3)
% geoshow(remo_wat, refvec, 'DisplayType', 'surface');
% demcmap(remo_wat);
% title('Water lost due to sl change')


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
    base_map(a+(b-1)*xt_size(1,1),3) = remo_wat(a,b);
    a=a+1;    
end
end

% figure(4)
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

% figure(5)
% scatter(load_contours(:,1), load_contours(:,2), 3, load_contours(:,3))
