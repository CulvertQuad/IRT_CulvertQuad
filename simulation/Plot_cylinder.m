global A

% plot cylinder 
sect = 100; % number of sectors of cylinder base

Ycylinder = meshgrid(linspace(-A.tunnel_l*0.5, A.tunnel_l*1.2, sect),...
    linspace(-A.tunnel_l*0.5, A.tunnel_l, sect))';
M = meshgrid(linspace(0, 2*pi, sect), linspace(0, 2*pi, sect)) ;
Xcylinder = A.tunnel_r .* sin(M);
Zcylinder = A.tunnel_r .* cos(M);

surf(Xcylinder,Ycylinder,Zcylinder,'FaceAlpha',0.2);

shading interp
colormap([.8 .8 .8])
camlight('right','local')

hold on

%reference plane
t = 0:0.2:360;
circle_x = A.tunnel_r * sind(t);
circle_y = zeros(1, length(t));
circle_z = A.tunnel_r * cosd(t);

fill3(circle_x, circle_y, circle_z, 'k');
alpha(0.3);
xlabel('x');
ylabel('y');
zlabel('z');
view(70, 30);
axis equal;

hold off

clear t circle_x circle_y circle_z M sect Xcylinder Zcylinder Ycylinder