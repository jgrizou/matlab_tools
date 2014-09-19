function oriented_rectangle(center, width, height, theta, filled, color, varargin)
% Input: 
% center - the pixel location of the center of rectangle 2x1 vector
% width - width of rectangle in pixels
% height - height of rectangle in pixels
% angle - rotation angle of rectangle in degrees
% filled - true or false
% color - if not filled, will not be used
% varragin are given to the fill or line function 

% inspired from Sudarshan Ramenahalli, Johns Hopkins University (sudarshan@jhu.edu)

coords = [  -(width/2), -(height/2); ...
            -(width/2), +(height/2); ...
            (width/2), +(height/2); ...  
            (width/2), -(height/2)];
        
matRot = [  cos(theta), sin(theta); ...
            -sin(theta), cos(theta)];

rot_coords = coords * matRot;

shifted_rot_coords = rot_coords + repmat(center, 4, 1);

if filled
    fill(shifted_rot_coords(:,1),shifted_rot_coords(:,2), color, varargin{:})
else
    line(shifted_rot_coords(:,1),shifted_rot_coords(:,2), varargin{:})
end