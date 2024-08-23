Please **read and follow the instructions** below to complete the task.

1. Download and read dataset “

    r[andom_30000_hotel_reviews.JSON](https://myuni.adelaide.edu.au/courses/95210/files/14540182?wrap=1)[ Download andom_30000_hotel_reviews.JSON](https://myuni.adelaide.edu.au/courses/95210/files/14540182/download?download_frd=1)”. Your main task will be to predict sentiment (positive or negative) based on " overall" score using “title” field concatenated with “**text**” field.

    1. Download and use the [**template** ](https://myuni.adelaide.edu.au/courses/95210/files/14540181?wrap=1)[ Download template](https://myuni.adelaide.edu.au/courses/95210/files/14540181/download?download_frd=1)for your coding and analysis.
    2. Split data into training (first 10000 lines), development (next 10000 lines) and test (remaining 10000 lines).
    3. Use development dataset for all experiments. Use training/testing sets for the final training/testing, to obtain the final results. 
    4. From **all datasets** remove all non-alphanumeric characters and tokenise the text.

2. Perform Exploratory Data Analysis on the development dataset, such as: distribution of "overall" rating over number of instances, number of unique words, predictive words, non-predictive words. You may perform some preprocessing on a sample of data (to speed up the analysis) if that is needed for EDA.

    1. Determine what further preprocessing is required given data types.
    2. Identify data dependencies that might be useful for this task and visualise those dependencies using suitable techniques and charts.
    3. Use this analysis to select suitable processing and prediction models for data preprocessing and experimentation and justify your selection.
    4. Include the charts and diagrams together with the code in Jupyter Notebook.
    5. Make sure your charts are of good quality and useful, there is no point to make a chart or a table, if it is not referred to in your discussion. 

3. Pre-preprocessing and Machine Learning method selection

    1. Use initial processing techniques identified in EDA. Data preprocessing should be consistent with your analysis, for example, if the data is highly imbalanced, consider data balancing techniques such as upsampling or downsampling. 
        You may also consider removing non-English reviews.
    2. Consider the following Machine Learning methods: Multinomial Naïve Bayes (MNB), Random Forest (RF), Linear Regression, SVM, k-NN, Multilayer Perceptron (MLP). If you wish, you can use a deep learning model, but limit to Keras and PyTorch, and make sure that run time is suitable for running your code for marking (say, up to a couple of minutes)
        Select one of these methods that you consider the most suitable for further experiments. Select evaluation metric. Justify your selection.
    3. Use development datasets and 10-fold cross-validation to select text processing that yields the best results, considering the following methods in separation (combining these can also be done as an optional experiment):
        1. stop-word removal,
        2. lemmatisation
        3. lowercasing.
    4. Show the best results and comment why this preprocessing works best.
    5. Complete preprocessing such as scaling and transformation and anything else that you identified in EDA.

4. Use VADER on the dev dataset for sentiment prediction, compare with results from point 3.4 and comment on differences.

5. Find a method to combine VADER sentiment analysis with your best Machine Learning method from point 3.4. Implement the method and test it. Compare with 3.4 and 4. C**ite the sources and literature which you used, if any.**

6. Use the best overall method from point 3 to preprocess the training/test sets. Note, that your preprocessing should be unsupervised, that is, cannot use the target attribute.
    Train on training and test on test set to get the final model and results. Show the results and comment on the following:
    How these results compare with the best results from point 3? Why there are differences, if any?

7. The dataset you use for this assignment contains ratings of many different aspects for the hotels. Propose a method to predict each of the aspects from the title and the text of review. You do not need to implement the method, just write a short (up to about half page) proposal. Cite any sources.

**Note 1:** There is a simple [**example** ](https://myuni.adelaide.edu.au/courses/95210/files/14540192?wrap=1)[ Download example](https://myuni.adelaide.edu.au/courses/95210/files/14540192/download?download_frd=1)of using VADER and supervised Machine Learning for sentiment prediction. You may use this example for your work as a starting point. 

**Note 2: If you use any AI assistant model for your assignment,** clearly indicate which part of the code/text was used, what kind of model (e.g. GPT-3), and quote exact prompt that you used. 

**Note 3**: Do not copy code from any source, but you can look up ideas in Internet posts, e.g. Stack Exchange and use them to produce your code, fix bugs etc. Cite these sources. You are free to use code published with common libraries, such as sklearn, NLTK as examples of using their APIs, and you do not need to cite them. 

ANLP A1 Rubric 2024

| Criteria                                                     | Ratings | Pts    |
| ------------------------------------------------------------ | ------- | ------ |
| This criterion is linked to a learning outcomeTechnical Skills and Knowledge1) Pre-processing (max 5 points) 2) Dataset analysis (max 10 points) 3) Choosing machine learning method (max 10 points) 4) Experiments (max 20 point) 5) Training/testing and description of results (max 10 points) 6) Aspect method proposal (max 5 points) |         | 60 pts |
| This criterion is linked to a learning outcomeWritten communication and formatting1) Good coding practice: code readability, easy to understand commenting, runnable code (max 15 points) 2) Formatting: how your document is presented: tables, charts, text formatting, easy to navigate through the document (max 15 points) 3) Organisation of ideas: logical flow of presentation (max 5 points) 4) Citation and referencing: in-line citation, list of references at the end of document (max 5 points) |         | 40 pts |
| Total points: 100                                            |         |        |