function niceColor = get_nice_color(colorStr)

switch colorStr    
    case 'g'
        niceColor = [0.4, 0.8, 0.2];        
    case 'r'
        niceColor = [1, 0.2, 0.2];        
    case 'b'
        niceColor = [0.2, 0.4, 0.8];        
    case 'o'
        niceColor = [0.9, 0.5, 0];        
    case 'k'
        niceColor = [0.07, 0.06, 0.2];        
    case 'p'
        niceColor = [0.6, 0.07, 0.86];        
    case 'd'
        niceColor = [0.5, 0.5, 0.5];   
    otherwise
        warning('%s unknown, returning random color', colorStr)
        niceColor = get_random_color();
end