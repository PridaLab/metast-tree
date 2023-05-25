function accuracy = compute_accuracy_maxvoted(y_true, y_pred)
    
    % Several predictions, one per column
    if isnumeric(y_true) && isnumeric(y_pred)
        y_pred_maxvote = mode(y_pred,2);
        accuracy = mean(y_true == y_pred_maxvote);
        fprintf('Accuracy is %.2f%%\n', accuracy*100)
    
    % Several predictions, one per cell
    elseif iscell(y_true) && iscell(y_pred)
        for ii = 1:length(y_true)
            y_pred_maxvote = mode(y_pred{ii});
            accuracy(ii) = mean(y_true{ii} == y_pred_maxvote);
            fprintf('Accuracy of #%d is %.2f%%\n', ii, accuracy*100)
        end
        
    % Unknown format
    else
        accuracy = nan;
        warning('Unknown y_true y_pred format')
    end

end