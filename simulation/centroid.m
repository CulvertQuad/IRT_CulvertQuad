function [x_bar, y_bar, As] = centroid(x,y)

A = x(1:end-1).*y(2:end)-x(2:end).*y(1:end-1);
As = sum(A)/2;
x_bar = (sum((x(2:end)+x(1:end-1)).*A)*1/6)/As;
y_bar = (sum((y(2:end)+y(1:end-1)).*A)*1/6)/As;

end