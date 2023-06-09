function [varargout] = confusion_matrix(y, pred, classNames, varargin)

    dirThisFile = fileparts(matlab.desktop.editor.getActiveFilename);
    dirImages = fullfile(fileparts(dirThisFile), 'images');
    
    % Get optional values
    p = inputParser;
    addParameter(p,'cLims', [], @isnumeric);
    addParameter(p,'plotText', true, @islogical);
    addParameter(p,'saveName', fullfile(dirImages, 'confusion_matrix.png'), @isstr);
    addParameter(p,'title', '', @isstr);
    parse(p,varargin{:});
    cLims = p.Results.cLims;
    plotText = p.Results.plotText;
    saveName = p.Results.saveName;
    plotTitle = p.Results.title;
    
    % Number of classes and models
    nClass = length(classNames);
    nModels = size(pred,2);
    
    % Repeat y to have same columns as pred
    y = repmat(y, 1, nModels);

    % Confusion matrix
    confMat = nan(nClass, nClass, nModels);
    for iGroup = 1:nClass
        for jGroup = 1:nClass
            confMat(jGroup, iGroup, :) = sum(y==iGroup & pred==jGroup) ./ sum(y==iGroup);
        end
    end
    
    % Plot figure
    figure('units','norm','pos',[.2 .3 .4 .4])
    if isempty(cLims)
        imagesc(nanmean(confMat,3))
    else
        imagesc(nanmean(confMat,3), cLims)
    end
    colormap(makeColorMap([1 1 1], [0 .5 .7], 256))
    colorbar
    for iGroup = 1:nClass
        for jGroup = 1:nClass
            if plotText
                if size(y,2) == 1
                    text(jGroup, iGroup, sprintf('%.0f %%',100*confMat(iGroup, jGroup)));
                else
                    text(jGroup-0.1*nClass, iGroup, sprintf('%.0f +/- %.0f %%',100*nanmean(confMat(iGroup, jGroup, :),3), 100*nanstd(confMat(iGroup, jGroup, :),[],3)));
                end
            end
        end
    end
    % Axis
    xlabel('True label')
    ylabel('Pred label')
    set(gca, 'xtick',1:nClass, 'xticklabel', strrep(classNames,'_',' '), ...
        'ytick',1:nClass, 'yticklabel', strrep(classNames,'_',' '));
    xtickangle(-15)
    title(plotTitle)
    ax = gca; ax.FontName = 'arial'; ax.FontSize = 11;
    % Save
    if ~isempty(saveName)
        saveas(gcf, saveName);
    end
    
    % Optional output
    varargout{1} = confMat;
end