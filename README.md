# metast-tree

LFP analysis and classification of metastases

## process_data()

The MATLAB function `[trainingData, testData, trainingLines, testLines] = process_data(trainingDataRaw, testDataRaw)` 

* **Inputs**
	- `trainingDataRaw`: table loaded from [training_data.xlsx](https://github.com/PridaLab/metast-tree/blob/main/data/training_data.xlsx)
	- `testDataRaw`: table loaded from [training_data.xlsx](https://github.com/PridaLab/metast-tree/blob/main/data/test_data.xlsx)

* **Output**
	- `trainingLines`: name of the animal line of each row of the training sessions
	- `testLines`: name of the animal line of each row of the test sessions

## Decision trees

Already trained decision trees are loaded in [decision-trees/decision_trees.mat](https://github.com/PridaLab/metast-tree/blob/main/decision-trees/decision_trees.mat). They can be used to predict new data into `sham`, `breast`, `melanoma` or `lung` categories can be achieved with:

```
prediction = decisionTrees{iModel}.predict(trainingData.X);
```
