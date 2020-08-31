ages = ['16  ';'16.5';'17  ';'17.5';'18  ';'18.5';'19  ';'19.5';'20  ';'20.5';'21  ';'22  ';'23  ';'24  ';'25  ';'26  '];

%for q = 1:16

q = 9

inpname = strcat('I6_C.VM5a_1deg.',ages(q,:),'.nc');

%ncdisp('I6_C.VM5a_1deg.20.nc');
org_lat = ncread(inpname,'lat');
org_long = ncread(inpname,'lon');
ice_thick = ncread(inpname,'stgit');


latlim = [65 80]; %limits for displaying AOI
lonlim = [10 40];

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

figure(q)
contourf(matrix_long, matrix_lat, mod_ice_thick)
title('at 20 ka')
colorbar
%end