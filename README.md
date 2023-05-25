# metast-tree

LFP analysis and classification of metastases

## Load LFP data

The MATLAB function `[trainingData, testData, trainingLines, testLines] = process_data(trainingDataRaw, testDataRaw)`.

* **Inputs**
	- `trainingDataRaw`: table loaded from [training_data.xlsx](https://github.com/PridaLab/metast-tree/blob/main/data/training_data.xlsx)
	- `testDataRaw`: table loaded from [test_data.xlsx](https://github.com/PridaLab/metast-tree/blob/main/data/test_data.xlsx)

* **Output**
	- `trainingLines`: name of the animal line of each row of the training sessions
	- `testLines`: name of the animal line of each row of the test sessions

## Decision trees

Already trained decision trees are loaded in [decision-trees/decision_trees.mat](https://github.com/PridaLab/metast-tree/blob/main/decision-trees/decision_trees.mat). They can be used to predict new data into `sham`, `breast`, `melanoma` or `lung` categories can be achieved with:

```
prediction = decisionTrees{iModel}.predict(trainingData.X);
```
## Confusion matrix

The MATLAB function `confusion_matrix(ytrue, ypred, classNames, <optional>)` computes and plots a confusion matrix with predictions of all models. 

* **Mandatory Inputs**
	- `ytrue`: `N x 1` vector of true classes
	- `ypred`: `N x #models` vector of predicted classes. Each column is prediction from a particular model
	- `classNames`: names of classes (e.g. {`sham`, `breast`, `melanoma`, `lung`})

* **Optional Inputs**
	- `title`: plot title. None by default
	- `cLims`: color limits. Non by default
	- `plotText`: boolean indicating whether to show confusion matrix numbers. True by default
	- `saveName`: complete path for saving the confusion matrix. [images/confusion_matrix.png](https://github.com/PridaLab/metast-tree/blob/main/images/confusion_matrix.png) by default

* **Optional Outputs**
	- `confMat`: `#classes x #classes` confusion matrix.

Output example

![alt text](https://github.com/PridaLab/metast-tree/blob/main/images/confusion_matrix.png)
