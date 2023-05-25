function [trainingData, testData, varargout] = process_data(trainingDataRaw, testDataRaw)

    % GLOBAL VARIABLES
   
    % Columns of features to be used for analysis:
    featureColumn = [10:11 19:25 27 28];
    % Which corresponds to: run_still, cx_hc, delta_db, theta_db, alfa_db, 
    % gammaS_db, gammaF_db, ripple_db, HFO_db, delta_over_theta, and
    % gammaS_over_gammaF
    
    % Maximum explained variance to select the number of PC components
    maxExplainedVariance = 99; 
    
    % We take data of hemisphere with tumor (hemisphere = 1) and recorded
    % in a later stage (early_late = 2)
    validTrainingData = (trainingDataRaw.hemisphere == 1) & ...
                        (trainingDataRaw.early_late == 2);
    validTestData = (testDataRaw.hemisphere == 1) & ...
                    (testDataRaw.early_late == 2);
    

    % GET FEATURE DATA

    % Select variables that will be used for prediction
    trainingDataFeatures = trainingDataRaw{:, featureColumn};
    testDataFeatures = testDataRaw{:, featureColumn};

    % Project to PCA space made from training data
    [newPCAspace, projectedTrainingData, ~, ~, explainedVariance] = pca(trainingDataFeatures);
    % - Find how many PCs explain maxExplainedVariance
    nPCs = find(cumsum(explainedVariance) > maxExplainedVariance, 1);
    trainingDataPCA = projectedTrainingData(:,1:nPCs);
    % - Apply PCA to test data
    projectedTestData = testDataFeatures/newPCAspace';
    testDataPCA = projectedTestData(:,1:nPCs);

    % zscore projected data
    zscoreMean = nanmean(trainingDataPCA);
    zscoreSD = nanstd(trainingDataPCA);
    % - zscore for training data using their own mean and SD
    trainingDataX = (trainingDataPCA - zscoreMean) ./ zscoreSD;
    % - zscore for test data using training mean and SD
    testDataX = (testDataPCA - zscoreMean) ./ zscoreSD;
    
    
    % GET CLASS DATA
    
    % Get class of training data
    trainingDataY = nan(size(trainingDataX,1),1);
    for iclass = 1:4
        trainingDataY(trainingDataRaw{:,2+iclass}==1) = iclass;        
    end
    
    % Get class of test data
    testDataY = nan(size(testDataX,1),1);
    for iclass = 1:4
        testDataY(testDataRaw{:,2+iclass}==1) = iclass;        
    end
    
    
    % FORMAT OUTPUT DATA
    trainingData = {};
    trainingData.X = trainingDataX(validTrainingData,:);
    trainingData.y = trainingDataY(validTrainingData,:);
    testData = {};
    testData.X = testDataX(validTestData,:);
    testData.y = testDataY(validTestData,:);
    
    % OPTIONAL OUTPUT
    % Training lines
    namesDecomposed = cellfun(@(x) strsplit(x,'_'), trainingDataRaw.ID, 'UniformOutput', false);
    namesDecomposed = cellfun(@(x) x{2}, namesDecomposed, 'UniformOutput', false);
    trainingLines = namesDecomposed(validTrainingData);
    % Test lines
    namesDecomposed = cellfun(@(x) strsplit(x,'_'), testDataRaw.ID, 'UniformOutput', false);
    namesDecomposed = cellfun(@(x) x{2}, namesDecomposed, 'UniformOutput', false);
    testLines = namesDecomposed(validTestData);
    % Output
    varargout{1} = trainingLines;
    varargout{2} = testLines;
    
end