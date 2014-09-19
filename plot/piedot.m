function h = piedot(centerX, centerY, values, colors, radius, varargin)
%PICHART 
% from http://stackoverflow.com/questions/11073889/scatter-pie-plot

%for varargin use stuff from patch
%'EdgeColor','none' or 'LineWidth', 1

shiftAngle = -pi/2;
values = shiftAngle + 2 * pi * cumsum(values) / sum(values);

hold on
h = zeros(1, length(values));
for i = 1:length(values)
    %# start/end angle of arc
    if i>1
        startAngle = values(i-1);
    else
        startAngle = shiftAngle;
    end
    endAngle = values(i);

    %# steps to approximate an arc from t1 to t2
    theta = linspace(startAngle, endAngle, 50);
    %# slice (line from t2 to center, then to t1, then an arc back to t2)
    x = centerX + radius .* [cos(endAngle) ; 0 ; cos(startAngle) ; cos(theta(:))];
    y = centerY + radius .* [sin(endAngle) ; 0 ; sin(startAngle) ; sin(theta(:))];

    h(i) = patch('XData',x, 'YData',y, ...
        'FaceColor', colors(i,:), varargin{:});
end