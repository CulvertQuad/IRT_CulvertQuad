close all; clear all; clc

r = 10; % cylinder radius
sect = 100; % number of sectors of cylinder base
h = 30; %cylinder height

Xcylinder = meshgrid(linspace(-h, h, sect), linspace(-h, h, sect))';
A = meshgrid(linspace(0, 2*pi, sect), linspace(0, 2*pi, sect)) ;
Ycylinder = r .* sin(A);
Zcylinder = r .* cos(A);

subplot(2,5,[1,2,3,6,7,8])

surf(Xcylinder,Ycylinder,Zcylinder,'FaceAlpha',0.8),axis equal
xlabel('x')
ylabel('y')
zlabel('z')


shading interp
colormap([.8 .8 .8])
camlight('right','local')



hold on

%------------ plot cycle

fi = 0:360;
Xcycle = zeros(1,length(fi));
Ycycle = r.* sind(fi);
Zcycle = r.* cosd(fi);

scatter3(Xcycle,Ycycle,Zcycle,'k.')

%-------------

pitch = 30;
roll = -40;
yaw = 30;

Rx = [1 0 0
    0 cosd(roll) -sind(roll)
    0 sind(roll) cosd(roll)];

Ry = [cosd(pitch) 0 sind(pitch)
    0 1 0
    -sind(pitch) 0 cosd(pitch)];

Rz = [cosd(yaw) -sind(yaw) 0
    sind(yaw) cosd(yaw) 0
    0 0 1];

% y^2 + z^2 = r^2
% ny + mz = x

P1 = Rz*Ry*Rx*[1;0;0]; % finding the tilted plane
P2 = Rz*Ry*Rx*[0;1;0]; % by rotating 2 points

A = [P1(1) P1(2)
    P2(1) P2(2)];

B = [P1(3)
    P2(3)];

sol = linsolve(A,B);

t = -10:0.1:10;

x1 = sol(2) .*t + sol(1) .* sqrt(r^2 - t.^2);
x2 = sol(2) .*t - sol(1) .* sqrt(r^2 - t.^2);
y = t;
z = sqrt(r^2 - t.^2);


x = [x1 x2];
y = [y y];
z = [z -z];

scatter3(x,y,z,'r.');


%------------

nvector = -cross([x(1) y(1) z(1)], [x(40) y(40) z(40)]);
nvector = 5 * nvector / norm(nvector);


hold on
subplot(2,5,[1,2,3,6,7,8])

plot3([0 nvector(1)], [0 nvector(2)], [0 nvector(3)],'r','LineWidth',3)

hold off
subplot(2,5,[4,5,9,10])

for i = 1 :402
    N(i) = norm([x(i); y(i); z(i)]);

end
plot(N)

iMax = max(N);
iMin = min(N);

t = -pi:0.01:pi;

xoval = iMax *cos(t);
yoval = iMin *sin(t);

plot(xoval,yoval,'r'); axis equal






