%=========================== PLOT ========================================
subplot(1,2,1);
Plot_cylinder
hold on

%plot3(x_circle, y_circle, z_circle, '.c');

%lidar scan 
fill3(x,y,z,'r'); alpha(0.2)
plot3(x,y,z,'.r');
l1 = plot3([quad_x(end) x(1)],[quad_y(end) y(1)],[quad_z(end) z(1)],'r',...
    [quad_x(end) x(91)],[quad_y(end) y(91)],[quad_z(end) z(91)],'r',...
    [quad_x(end) x(181)],[quad_y(end) y(181)],[quad_z(end) z(181)],'r',...
    [quad_x(end) x(271)],[quad_y(end) y(271)],[quad_z(end) z(271)],'r');
set(l1, 'linewidth', 1.5);
%quad frame
g1 = plot3([quad_x(1) quad_x(2)],[quad_y(1) quad_y(2)],...
    [quad_z(1) quad_z(2)],[quad_x(3) quad_x(4)],...
    [quad_y(3) quad_y(4)],[quad_z(3) quad_z(4)],...
    [quad_x(5) quad_x(6)],[quad_y(5) quad_y(6)],[quad_z(5) quad_z(6)]);
set(g1, 'linewidth', 2);
set(g1, 'color', 'k');

g2 = plot3(quad_x(2), quad_y(2), quad_z(2),'.g',...
    quad_x(3), quad_y(3), quad_z(3),'.g',quad_x(4),...
    quad_y(4), quad_z(4),'.c', quad_x(1), quad_y(1),...
    quad_z(1),'.c', quad_x(6), quad_y(6), quad_z(6), '.m');
set(g2, 'MarkerSize', 30);

grid on

axis equal
view(45,45)

%figure;
subplot(1,2,2);
plot(scan_x,scan_z,'r.',0,0,'or',cx,cy,'ok', scan_x(91),scan_z(91),'ob', scan_x(271),scan_z(271),'ob')
hold on
plot([0 scan_x(91)],[0 scan_z(91)],'r',[0 scan_x(271)],[0 scan_z(271)],'r',...
     [0 scan_x(1)],[0 scan_z(1)],'r',[0 scan_x(181)],[0 scan_z(181)],'r')
axis equal
