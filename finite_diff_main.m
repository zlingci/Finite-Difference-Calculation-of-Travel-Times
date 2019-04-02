%% This programme is based on the paper
%% 'Finite-Difference Calculation of Travel Times'
%% published by John Vidale. There may be some misfits 'cause 
%% we ignored the circular wavefronts, following the plane-wave
%% assumption.
%% co-workers: Dong Sheng, Song Zhenghong, Zhao Zhiyuan
%
clc;clear all;close all
%% grid setting
grdsz = [128 255];         % [z_size x_size]
grd_s = ones(grdsz);       % slowness of grid
Moho = 30;                 % depth of Moho
grd_s = [1/6.*ones(Moho,255); 1/8.*ones(grdsz(1)-Moho,255)];
pos_A = [2,20];            % source pos (0th layer)
h = 1; % size of grid
t0 = 0;                    % source time

grd_t = zeros(grdsz);      % tt of grid

%% find the boundaries
d_rb = grdsz(1) - pos_A(1);    % distance from source to right boundary
d_lb = pos_A(1) - 1;
d_ub = grdsz(2) - pos_A(2);
d_db = pos_A(2) - 1;
d_b = [d_rb d_lb d_ub d_db];
d_min_name = strings(4,1);
d_min = zeros(4,1);
for i = 1: 1: 4
    [val pos] = min(d_b);
    d_min(i) = val;
    switch pos
        case 1
            d_min_name(i) = 'd_rb';
        case 2
            d_min_name(i) = 'd_lb';
        case 3
            d_min_name(i) = 'd_ub';
        case 4
            d_min_name(i) = 'd_db';
    end
    d_b = [d_b(1:pos-1) Inf d_b(pos+1:end)];
end
clear d_b val pos
%% 1st layer
d_B1 = [1,0];
d_B2 = [0,1];
d_B3 = [-1,0];
d_B4 = [0,-1];
pos_B1 = pos_A + d_B1;
pos_B2 = pos_A + d_B2;
pos_B3 = pos_A + d_B3;
pos_B4 = pos_A + d_B4;
pos_C1 = pos_A + d_B1 + d_B2;
pos_C2 = pos_A + d_B2 + d_B3;
pos_C3 = pos_A + d_B3 + d_B4;
pos_C4 = pos_A + d_B4 + d_B1;
%
num_r = 0; % right 
num_u = 0; % up 
num_d = 0; % down 
num_l = 0; % left 
%
if d_rb>=1
    t_B1 = (h/2) * ( grd_s(pos_A(1),pos_A(2)) + grd_s(pos_B1(1),pos_B1(2)) );
    grd_t(pos_B1(1),pos_B1(2)) = t_B1;
    num_r = num_r+1;
end
if d_ub>=1
    t_B2 = (h/2) * ( grd_s(pos_A(1),pos_A(2)) + grd_s(pos_B2(1),pos_B2(2)) );
    grd_t(pos_B2(1),pos_B2(2)) = t_B2;
    num_u = num_u+1;
end
if d_lb>=1
    t_B3 = (h/2) * ( grd_s(pos_A(1),pos_A(2)) + grd_s(pos_B3(1),pos_B3(2)) );
    grd_t(pos_B3(1),pos_B3(2)) = t_B3;
    num_l = num_l+1;
end
if d_db>=1
    t_B4 = (h/2) * ( grd_s(pos_A(1),pos_A(2)) + grd_s(pos_B4(1),pos_B4(2)) );
    grd_t(pos_B4(1),pos_B4(2)) = t_B4;
    num_d = num_d+1;
end
%
if d_rb>=1 && d_ub>=1    % havenot touch boundary
    t_C1 = t0 + sqrt( 2 * (h * grd_s(pos_C1(1),pos_C1(2)))^2 - (t_B1 - t_B2)^2 );
    grd_t(pos_C1(1),pos_C1(2)) = t_C1;
end
if d_lb>=1 && d_ub>=1
    t_C2 = t0 + sqrt( 2 * (h * grd_s(pos_C2(1),pos_C2(2)))^2 - (t_B2 - t_B3)^2 );
    grd_t(pos_C2(1),pos_C2(2)) = t_C2;
end
if d_lb>=1 && d_db>=1
    t_C3 = t0 + sqrt( 2 * (h * grd_s(pos_C3(1),pos_C3(2)))^2 - (t_B3 - t_B4)^2 );
    grd_t(pos_C3(1),pos_C3(2)) = t_C3;
end
if d_rb>=1 && d_db>=1
    t_C4 = t0 + sqrt( 2 * (h * grd_s(pos_C4(1),pos_C4(2)))^2 - (t_B4 - t_B1)^2 );
    grd_t(pos_C4(1),pos_C4(2)) = t_C4;
end
%% before touching boundary
for i = 2: 1: d_min(1)
    line_r = grd_t(pos_A(1)+i-1, pos_A(2)-i+1:pos_A(2)+i-1);
    line_l = grd_t(pos_A(1)-i+1, pos_A(2)-i+1:pos_A(2)+i-1);
    line_u = grd_t(pos_A(1)-i+1:pos_A(1)+i-1, pos_A(2)+i-1);
    line_d = grd_t(pos_A(1)-i+1:pos_A(1)+i-1, pos_A(2)-i+1);
    % calculate the edges
    lineout_sr = grd_s(pos_A(1)+i, pos_A(2)-i+1:pos_A(2)+i-1);
    lineout_r = zlc_fd_lineout(h,lineout_sr,i,line_r);
    grd_t(pos_A(1)+i, pos_A(2)-i+1:pos_A(2)+i-1) = lineout_r;
    
    lineout_sl = grd_s(pos_A(1)-i, pos_A(2)-i+1:pos_A(2)+i-1);
    lineout_l = zlc_fd_lineout(h,lineout_sl,i,line_l);
    grd_t(pos_A(1)-i, pos_A(2)-i+1:pos_A(2)+i-1) = lineout_l;
    
    lineout_su = grd_s(pos_A(1)-i+1:pos_A(1)+i-1, pos_A(2)+i);
    lineout_u = zlc_fd_lineout(h,lineout_su,i,line_u);
    grd_t(pos_A(1)-i+1:pos_A(1)+i-1, pos_A(2)+i) = lineout_u;
    
    lineout_sd = grd_s(pos_A(1)-i+1:pos_A(1)+i-1, pos_A(2)-i);
    lineout_d = zlc_fd_lineout(h,lineout_sd,i,line_d);
    grd_t(pos_A(1)-i+1:pos_A(1)+i-1, pos_A(2)-i) = lineout_d;
    % calculate the corners
    corner_ru_s = grd_s(pos_A(1)+i, pos_A(2)+i);
    corner_lu_s = grd_s(pos_A(1)-i, pos_A(2)+i);
    corner_rd_s = grd_s(pos_A(1)+i, pos_A(2)-i);
    corner_ld_s = grd_s(pos_A(1)-i, pos_A(2)-i);
    grd_t(pos_A(1)+i, pos_A(2)+i) = grd_t(pos_A(1)+i-1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_ru_s)^2 - (grd_t(pos_A(1)+i-1, pos_A(2)+i) - grd_t(pos_A(1)+i, pos_A(2)+i-1))^2 );
    grd_t(pos_A(1)-i, pos_A(2)+i) = grd_t(pos_A(1)-i+1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_lu_s)^2 - (grd_t(pos_A(1)-i+1, pos_A(2)+i) - grd_t(pos_A(1)-i, pos_A(2)+i-1))^2 );
    grd_t(pos_A(1)+i, pos_A(2)-i) = grd_t(pos_A(1)+i-1, pos_A(2)-i+1) + sqrt( 2 * (h * corner_rd_s)^2 - (grd_t(pos_A(1)+i-1, pos_A(2)-i) - grd_t(pos_A(1)+i, pos_A(2)-i+1))^2 );
    grd_t(pos_A(1)-i, pos_A(2)-i) = grd_t(pos_A(1)-i+1, pos_A(2)-i+1) + sqrt( 2 * (h * corner_ld_s)^2 - (grd_t(pos_A(1)-i+1, pos_A(2)-i) - grd_t(pos_A(1)-i, pos_A(2)-i+1))^2 );
end
%% after the 1st boundary
switch d_min_name(1)
    case 'd_rb'
        for i = d_min(1)+1: 1: d_min(2)
            zlc_fd_l;
            zlc_fd_u;
            zlc_fd_d;
            corner_lu_s = grd_s(pos_A(1)-i, pos_A(2)+i);
            corner_ld_s = grd_s(pos_A(1)-i, pos_A(2)-i);
            grd_t(pos_A(1)-i, pos_A(2)+i) = grd_t(pos_A(1)-i+1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_lu_s)^2 - (grd_t(pos_A(1)-i+1, pos_A(2)+i) - grd_t(pos_A(1)-i, pos_A(2)+i-1))^2 );
            grd_t(pos_A(1)-i, pos_A(2)-i) = grd_t(pos_A(1)-i+1, pos_A(2)-i+1) + sqrt( 2 * (h * corner_ld_s)^2 - (grd_t(pos_A(1)-i+1, pos_A(2)-i) - grd_t(pos_A(1)-i, pos_A(2)-i+1))^2 );
        end
        zlc_fd_bound1_r;
    case 'd_lb'
        for i = d_min(1)+1: 1: d_min(2)
            zlc_fd_r;
            zlc_fd_u;
            zlc_fd_d;
            corner_ru_s = grd_s(pos_A(1)+i, pos_A(2)+i);
            corner_rd_s = grd_s(pos_A(1)+i, pos_A(2)-i);
            grd_t(pos_A(1)+i, pos_A(2)+i) = grd_t(pos_A(1)+i-1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_ru_s)^2 - (grd_t(pos_A(1)+i-1, pos_A(2)+i) - grd_t(pos_A(1)+i, pos_A(2)+i-1))^2 );
            grd_t(pos_A(1)+i, pos_A(2)-i) = grd_t(pos_A(1)+i-1, pos_A(2)-i+1) + sqrt( 2 * (h * corner_rd_s)^2 - (grd_t(pos_A(1)+i-1, pos_A(2)-i) - grd_t(pos_A(1)+i, pos_A(2)-i+1))^2 );
        end
        zlc_fd_bound1_l;
    case 'd_ub'
        for i = d_min(1)+1: 1: d_min(2)
            zlc_fd_r;
            zlc_fd_l;
            zlc_fd_d;
            corner_rd_s = grd_s(pos_A(1)+i, pos_A(2)-i);
            corner_ld_s = grd_s(pos_A(1)-i, pos_A(2)-i);
            grd_t(pos_A(1)+i, pos_A(2)-i) = grd_t(pos_A(1)+i-1, pos_A(2)-i+1) + sqrt( 2 * (h * corner_rd_s)^2 - (grd_t(pos_A(1)+i-1, pos_A(2)-i) - grd_t(pos_A(1)+i, pos_A(2)-i+1))^2 );
            grd_t(pos_A(1)-i, pos_A(2)-i) = grd_t(pos_A(1)-i+1, pos_A(2)-i+1) + sqrt( 2 * (h * corner_ld_s)^2 - (grd_t(pos_A(1)-i+1, pos_A(2)-i) - grd_t(pos_A(1)-i, pos_A(2)-i+1))^2 );
        end
        zlc_fd_bound1_u;
    case 'd_db'
        for i = d_min(1)+1: 1: d_min(2)
            zlc_fd_r;
            zlc_fd_l;
            zlc_fd_u;
            corner_ru_s = grd_s(pos_A(1)+i, pos_A(2)+i);
            corner_lu_s = grd_s(pos_A(1)-i, pos_A(2)+i);
            grd_t(pos_A(1)+i, pos_A(2)+i) = grd_t(pos_A(1)+i-1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_ru_s)^2 - (grd_t(pos_A(1)+i-1, pos_A(2)+i) - grd_t(pos_A(1)+i, pos_A(2)+i-1))^2 );
            grd_t(pos_A(1)-i, pos_A(2)+i) = grd_t(pos_A(1)-i+1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_lu_s)^2 - (grd_t(pos_A(1)-i+1, pos_A(2)+i) - grd_t(pos_A(1)-i, pos_A(2)+i-1))^2 );
        end
        zlc_fd_bound1_d;
end

    %%

figure;contour(grd_t,'LevelStep',3,'LineWidth',1.5)
axis equal
set(gca,'YDir','reverse')
hold on;
plot([1 grdsz(2)],[Moho Moho],'LineWidth',1.5);
hold on;
plot(pos_A(2),pos_A(1), 'p', 'MarkerFaceColor', 'r', 'MarkerSize',16);
xlabel('Distance (km)','FontSize',14,'FontWeight','bold');
ylabel('Depth (km)','FontSize',14,'FontWeight','bold');
annotation('textbox',[0.9 0.49 0.1 0.2],'String','Moho','FitBoxToText','on','EdgeColor','none','FontSize',12);














