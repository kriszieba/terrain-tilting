clear all
close all

ice_response = 1;
load_response = 0;
sea_level_change = 1;
load_past_topo = 0; %past topo map loading in sl_change.m

% INPUT
latlim = [65 80];
lonlim = [10 40];
lcm = 0.1571;
set_zone = '32 V';
ice_density = 917;
sed_density = 2200;
water_density = 1025;
sl = -91.7; %sea level change
%-50.2 at 1.5 Ma, -22.2 at 700 ka, -101.7 at 0.44 Ma, -91.7 at 24 ka
%in order to change elastic thickness goto tecontours.txt
%%
if ice_response == 1;
    if sea_level_change == 1;
    sl_effect = 1;
    water_effect = 0;
    uncomp_water_effect = 0;
    run('sl_change')
    density = water_density;
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    run('sl_change_resp')
    end
    
    uncomp_water_effect = 0;
    water_effect = 1;
    sl_effect = 0;
    density = water_density;
    run('ice_thickness') % writes thickness_matrix.mat
    run('repl_water_ice')
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    
    water_effect = 0;
    run('ice_i6') %writes ice_map.txt
    run('ice_to_flex_modelling_v3') %writes loadcontours.txt
    density = ice_density;
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    
    uncomp_water_effect = 1;
    density = water_density;
    run('uncompensated_water')
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    clear all
    run('topo_ice')
    
else
    if sea_level_change == 1;
    sl_effect = 1;
    water_effect = 0;
    uncomp_water_effect = 0;
    run('sl_change') %writes Z_sl.mat
    density = water_density;
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    run('sl_change_resp')
    end
    
    water_effect = 1;
    uncomp_water_effect = 0;
    sl_effect = 0;
    density = water_density;
    run('repl_water_load') %calculates repleaced water from Z_sl and provided erosion/deposition map. saves repleaced water to loadcontours.txt, ...
    % writes load thickness matrix to reg_thickness_matrix.mat
    density = water_density;
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    
    water_effect = 0;
    sl_effect = 0;
    run('load_to_flex_modelling') %writes loads to loadcontours.txt from provided erosion/deposition map
    density = sed_density;
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    
    uncomp_water_effect = 1;
    density = water_density;
    run('uncompensated_water')
    run('test7')
    run('flex3d')
    run('plotTest_v3')
    clear all
    run('topo_load_v2')
end