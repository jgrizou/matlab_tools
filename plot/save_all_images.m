function save_all_images(plotFolder, plotFormats, plotFilenames)

drawnow
handles = sort(allchild(0));

if ~exist(plotFolder, 'dir')
    mkdir(plotFolder)
end

if ~iscell(plotFormats)
    plotFormats = {plotFormats};
end

if ~iscell(plotFilenames)
    plotFilenames = {plotFilenames};
end

for iHandle = 1:length(handles)
    figure(handles(iHandle))
    if ~isempty(plotFilenames)
        filename = fullfile(plotFolder, plotFilenames{iHandle});
    else
        filename = fullfile(plotFolder, sprintf('%03d', handles(iHandle)));
    end
    
    for iFormat = 1:length(plotFormats)
        format = plotFormats{iFormat};
        switch format
            case 'fig'
                saveas(gcf, [filename,'.fig'], 'fig')
        
            case 'eps'
                saveSameSize(gcf, 'format', 'epsc2', 'file', [filename, '.eps']); 
                
            otherwise
                saveSameSize(gcf, 'format', format, 'file', [filename, '.', format]);
        end
    end
end