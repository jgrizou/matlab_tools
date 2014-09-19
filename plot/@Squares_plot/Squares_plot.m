classdef Squares_plot < handle
%SQUARES_PLOT 
%   squares are by default of size 1    

    properties
        lineWidth = 5
        squareSize = 1
        fontSize = 20
        dotSize = 500
        arrowSize = 0.5
        arrowLineWidth = 5
        
        cmap = jet(10000) % The color map used for values plotting
        
        positions = [] % x and y position of each square centers
        colors = {}
        chars = {}
        nSquares = 0
    end
    
    methods
        function self = Squares_plot(squarePositions)
            if nargin > 0
                self.add_squares(squarePositions)
            end
        end
        
        function add_squares(self, squarePositions)
            if ~ismatrix(squarePositions) && size(squarePositions, 2) ~= 2
                error('squares_plot:add_squares:PositionsNotValid','squarePositions not valid')
            end
            for i = 1: size(squarePositions, 1)
                self.positions = [self.positions; squarePositions(i, :)];
                self.nSquares = self.nSquares + 1;
                self.colors{self.nSquares} = 'w';
                self.chars{self.nSquares} = '';
            end
        end
        
        function isValid = is_id_valid(self, id)
            isValid = 1;
            if id > self.nSquares || id < 1
                isValid = 0;
            end
        end
        
        function set_color(self, id, color)
            self.colors{id} = color;
        end
        
        function reset_colors(self)
            for iPosition = 1:self.nSquares
                self.set_color(iPosition, 'w')
            end
        end
       
        function set_all_colors_by_values(self, values, limMinMax)
            if ~isvector(values) && length(values) ~= self.nSquares
                error('squares_plot:add_squares:ValuesNotValid','values must be a vector with as many elements as squares')
            end
            if nargin < 3
                limMinMax = [min(values), max(values)];
            end
            mapped_colors = values_to_colors(values, limMinMax, self.cmap);
            for iPosition = 1:self.nSquares
                self.set_color(iPosition, mapped_colors(iPosition, :))
            end
        end
        
        function set_char(self, id, char)
            self.chars{id} = char;
        end
        
        function reset_chars(self)
            for iPosition = 1:self.nSquares
                self.set_char(iPosition, '')
            end
        end
        
        function set_all_char_as_square_number(self)
            for iPosition = 1:self.nSquares
                self.set_char(iPosition, num2str(iPosition))
            end
        end
        
        function draw(self, cbar, limMinMax)
            if nargin < 2
                cbar = false;
            end
            for iPosition = 1:self.nSquares
                self.draw_square(self.positions(iPosition, :), self.colors{iPosition}, self.chars{iPosition}) 
            end
            axis equal
            axis off
            if cbar
                colorbar
            end
            if nargin > 2
                caxis(limMinMax)
            end
        end
        
        function draw_square(self, position, color, char)
            if nargin < 3
                rectangle('Position', [position(1)-self.squareSize/2, position(2)-self.squareSize/2, self.squareSize, self.squareSize], 'linewidth', self.lineWidth)
            else
                rectangle('Position', [position(1)-self.squareSize/2, position(2)-self.squareSize/2, self.squareSize, self.squareSize], 'linewidth', self.lineWidth, 'FaceColor', color)  
            end
            if nargin > 3
                text(position(1), position(2)-self.squareSize/2, char, 'fontsize', self.fontSize, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom')
            end
        end
        
        function draw_dot(self, id, color)
            holding = ishold;
            hold on
            if nargin < 3
                color = 'k';
            end
            scatter(self.positions(id,1), self.positions(id, 2), self.dotSize, 'filled', color)
            if ~holding
                hold off
            end
        end
        
        function draw_arrow(self, direction, id, color)
            holding = ishold;
            hold on
            if nargin < 3
                color = 'k';
            end
            switch direction
                case 1
                    quiver(self.positions(id,1), self.positions(id, 2), -self.arrowSize, 0, color, 'linewidth', self.arrowLineWidth)
                case 2
                    quiver(self.positions(id,1), self.positions(id, 2), self.arrowSize, 0, color, 'linewidth', self.arrowLineWidth)
                case 3
                    quiver(self.positions(id,1), self.positions(id, 2), 0, self.arrowSize, color, 'linewidth', self.arrowLineWidth)
                case 4
                    quiver(self.positions(id,1), self.positions(id, 2), 0, -self.arrowSize, color, 'linewidth', self.arrowLineWidth)
            end
            if ~holding
                hold off
            end
        end
    end
    
end

