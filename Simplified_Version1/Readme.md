## Simplified_Version1

These repository offers some files of ECOC_MDC algorithm, but only contains the core part of the algorithm,
other functions like saving data as csv format, and drawing pictures are recorded in the Later Version.

## Repository contains:
- data folder
- ECOC_MDC folder
- ecoclib folder
- Demo.m file
- Readme.md file
    1. data folder contains:
        - result, for saving the result obtained by the algorithm
        - train_test, for storing the train and test data, Demo.m file would apply the files to start the procedure.
        The data comes from the DNA genes, and details can be founded in the link wiki https://en.wikipedia.org/wiki/DNA_microarray
  
    2. ECOC_MDC folder contains:
        - get_cds.m, for generating the coding matrix of ECOC_MDC algorithm.
        - get complexity folder, for memorying a series of mat file to calculate the DATA complexity.
 
    3. ecoclib folder contains:
        - BDs folder.
        - Classifiers folder.
        - Codings.
        - Decodings.
        - Custer_Classifier_Test.m file.
        - ECOCTest.m file.
        - ECOCTrain.m file.
  
        note that: the library is provided by the others. if you want to know more about it, please look at https://www.researchgate.net/publication/220320705_Error-Correcting_Ouput_Codes_Library
    4. Demo.m 
        this file offers a clear demo of ECOC-MDC, and numerous annotation are marked on it.
  
    5. ECOC_train.m
        this file is interface file of ECOC_MDC and it calls for the ECOCTrain and ECOCTest file.
  
## Others
This repostory displays the whole work of ECOC_MDC algorithm i have worked for a two years, i hope to share my work by this platform. If you are interested this topic, welcome to interact me!
  
  

