# Load libraries
import numpy as np
from sklearn.naive_bayes import MultinomialNB, BernoulliNB
from sklearn.feature_extraction.text import CountVectorizer
from sklearn import tree

import nltk
# nltk.download('vader_lexicon')
from nltk.sentiment.vader import SentimentIntensityAnalyzer

def predict_and_test(model, X_test_bag_of_words):
    predicted_y = model.predict(X_test_bag_of_words)
    print((y_test==predicted_y)/len(y_test))

# Create text
text_data = np.array(['I love Brazil. Brazil is best',
                      'I like Italy, because Italy is beautiful',
                      'Malaysia is ok, but I do not like spicy food',
                      'I like Germany more, Germany beats all',
                      'I do not like hot weather in Singapore'])
X = text_data
# Create target vector
y = ['positive','positive','negative','positive','negative']

# analyse with VADER
analyser = SentimentIntensityAnalyzer()
for text in text_data:
    score = analyser.polarity_scores(text)
    if score['pos'] > score['neg'] :
        print(text+": "+"VADER positive")
    else:
        print(text+": "+"VADER negative")

# split into train and test
X_train = X[:3]
X_test = X[3:]
y_train = y[:3]
y_test = y[3:]

# create count vectorizer and fit it with training data
count = CountVectorizer()
X_train_bag_of_words = count.fit_transform(X_train)

# transform the test data into bag of words creaed with fit_transform
X_test_bag_of_words = count.transform(X_test)

print("----bnb")
clf = BernoulliNB()
model = clf.fit(X_train_bag_of_words, y_train)
predict_and_test(model, X_test_bag_of_words)

print("----mnb")
clf = MultinomialNB()
model = clf.fit(X_train_bag_of_words, y_train)
predict_and_test(model, X_test_bag_of_words)

# if random_state id not set. the feaures are randomised, therefore tree may be different each time
print("----dt")
clf = tree.DecisionTreeClassifier(min_samples_leaf=20,criterion='entropy',random_state=0)
model = clf.fit(X_train_bag_of_words, y_train)
predict_and_test(model, X_test_bag_of_words)
    

