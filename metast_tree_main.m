% Add paths of this project
clear all; clc; close all
dirMain = fileparts(matlab.desktop.editor.getActiveFilename);
addpath(genpath(dirMain))


% -- IMPORT AND PROCESS ---------------------------------------------------

% Import data
trainingDataRaw = readtable(fullfile(dirMain, 'data', 'training_data.xlsx'));
testDataRaw = readtable(fullfile(dirMain, 'data', 'test_data.xlsx'));
classNames = trainingDataRaw.Properties.VariableNames(3:6);
classColors = [0 0 0; 57 158 57; 255 0 0; 0 108 255]/255;

% Process data
[trainingData, testData, trainingLines, testLines] = process_data(trainingDataRaw, testDataRaw);

% Import decision trees
load(fullfile(dirMain, 'decision-trees', 'decision_trees.mat'))
n_models = length(decisionTrees);


% -- PREDICT --------------------------------------------------------------

% Predict training data with each model
trainingData.pred = nan(length(trainingData.y), n_models);
for imodel = 1:n_models
    trainingData.pred(:,imodel) = decisionTrees{imodel}.predict(trainingData.X);
end

% Predict test data with each model
testData.pred = nan(length(testData.y), n_models);
for imodel = 1:n_models
    testData.pred(:,imodel) = decisionTrees{imodel}.predict(testData.X);
end


% -- EVALUATE -------------------------------------------------------------

% Plot confusion matrix
confMatTraining = confusion_matrix(trainingData.y, trainingData.pred, classNames, ...
    'title', 'Training data', 'cLims', [0 0.7], 'plotText', false);

% Compute accuracy of test data (max-voted strategy)
compute_accuracy_maxvoted(testData.y, testData.pred);

% Compute accuracy of each test class (max-voted strategy)
testNames = unique(testLines);
for iclass = 1:length(testNames)
    compute_accuracy_maxvote(testData.y(strcmp(testLines,testNames{iclass})), ...
        testData.pred(strcmp(testLines,testNames{iclass}),:));
end
