function [x, y, z, scan_x, scan_z] = lidar_scan_gen(quad_x, quad_y, quad_z, pitch ,roll , yaw)

global A

fi = 0:359;

x_circle = 400 * sind(fi);
y_circle = zeros(1,length(fi));
z_circle = 400 * cosd(fi);


[x_circle, y_circle, z_circle] = rotation3(x_circle,y_circle,z_circle,pitch,roll,yaw);


x_circle = x_circle + quad_x(end);
y_circle = y_circle + quad_y(end);
z_circle = z_circle + quad_z(end);

count = 1;
for i = 1:length(fi)
    a = (quad_x(end)-x_circle(i))^2 + (quad_z(end)-z_circle(i))^2;
    b = 2*quad_x(end)*(quad_x(end)-x_circle(i)) +2*quad_z(end)*(quad_z(end)-z_circle(i));
    c = quad_x(end)^2+quad_z(end)^2-A.tunnel_r^2;
    
    t = (-b + sqrt(b^2 - 4*a*c))/(2*a);
    xtemp = quad_x(end) + t*(quad_x(end)-x_circle(i));
    ytemp = quad_y(end) + t*(quad_y(end)-y_circle(i));
    ztemp = quad_z(end) + t*(quad_z(end)-z_circle(i));
    
    if norm([xtemp ytemp ztemp]) <= 6000;
        x(count) = xtemp;
        y(count) = ytemp;
        z(count) = ztemp;
        
        count = count + 1;
    end
end


for i = 1:length(x)  
    EuclidDistance(i) = EuclidDist(quad_x(end),quad_y(end),quad_z(end), x(i), y(i), z(i));
end

scan_x = EuclidDistance .* -sind(fi);
scan_z = EuclidDistance .* -cosd(fi);

end

