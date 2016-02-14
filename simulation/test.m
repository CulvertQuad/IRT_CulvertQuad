main 



[cx, cy, ~] = xycentroid(scan_x,scan_y);

hold on
plot(cx,cy,'oc', scan_x(90), scan_y(90), 'ob',scan_x(270), scan_y(270), 'ob')
