%ncdisp('I6_C.VM5a_1deg.24.nc');
org_lat = ncread('I6_C.VM5a_1deg.24.nc','lat');
org_long = ncread('I6_C.VM5a_1deg.24.nc','lon');
ice_thick = ncread('I6_C.VM5a_1deg.24.nc','stgit');
topo = ncread('I6_C.VM5a_1deg.24.nc','Topo_Diff');

% latlim = [65 80]; %limits for displaying AOI
% lonlim = [10 40];

mod_lat = org_lat; %180
mod_lat(mod_lat<=latlim(1,1))=0;
mod_lat(mod_lat>=latlim(1,2))=0;

mod_long = org_long; %360
mod_long(mod_long<=lonlim(1,1))=0;
mod_long(mod_long>=lonlim(1,2))=0;

mod_ice_thick = ice_thick;
for a = 1:180
    if mod_lat(a,1) == 0
    mod_ice_thick(:,a) = 0;
    end
end

for a = 1:360
    if mod_long(a,1) == 0
    mod_ice_thick(a,:) = 0;
    end
end

% eliminate zeros from matrices
mod_lat(mod_lat==0)=[];
mod_long(mod_long==0)=[];

s = size(mod_ice_thick);
a = 1;
while a <= s(1,1)
    if mod_ice_thick(a,:) == 0
       mod_ice_thick(a,:) = [];
    else
        a=a+1;
    end
       s = size(mod_ice_thick);
      
end

a = 1;
while a <= s(1,2)
    if mod_ice_thick(:,a) == 0
       mod_ice_thick(:,a) = [];
    else
        a=a+1;
    end
       s = size(mod_ice_thick);
end

matrix_dim = size(mod_ice_thick);

matrix_lat = zeros(matrix_dim);
max = matrix_dim(1,1);
for a = 1:max
    matrix_lat(a,:) = mod_lat;
end

matrix_long = zeros(matrix_dim);
max = matrix_dim(1,2);

for a = 1:max
    matrix_long(:,a) = mod_long;
end

thickness_matrix = zeros(matrix_dim(1,1),matrix_dim(1,2),3);
thickness_matrix(:,:,1) = matrix_long;
thickness_matrix(:,:,2) = matrix_lat;
thickness_matrix(:,:,3) = mod_ice_thick;
save('thickness_matrix.mat','thickness_matrix')