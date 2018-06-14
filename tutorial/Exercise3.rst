#####################
Exercise3
#####################

Download & Go - Data Science Eureka! When Lightning Strikes...

Title: Building and Running a Supervised Learning Model with Zetaris


Session Agenda

        - [ ] Typical Data Science Workflow
        - [ ] From Modelling to Production - Issues and Challenges
        - [ ] Tutorial - Building and Deploying a Model with Zetaris
        - [ ] Questions and Answers

Download & Go Tutorial (Building and Deploying a Model with Zetaris)

 This tutorial showcases a simple machine learning modelling and deployment exercise with the emphasis of showcasing how Zetaris adds value to the data science process. 

Data Preparation

Setting up Data Sources in Lightning
        
        - [ ] Creating a Topological View using Lightning GUI
        - [ ] Creating Join Script to bring all required data (attributes, features, instances) in lightning
        - [ ] Exposing a (Virtual) View of denormalized data set

Model Building

Setting up lightning Notebook

        - [ ] Brief intro to Apache Zeppelin (Lightning Notebook)
        - [ ] Bringing Virtual View(s) from Lightning to the notebook
        - [ ] Briefing the data science example experiment (Supervised Learning)
        - [ ] Running the experiment in Lightning Notebook

Model Scoring

        - [ ] Using model for scoring new records within Lightning Notebook
        - [ ] Exploratory Data Analysis using an SQL client tool
        - [ ] Plotting Results using Lightning Notebook



Data Science Tutorial
=======================

This tutorial will take you from a problem statement to extracting insights through data science using the Zetaris platform. 

The key takeaways are simplicity, power and scale of building and deploying machine learning models at scale. 


Zetaris Ligntning
-------------------

**This is Zetaris Notebook, based on Apache Zeppelin. It is a handy way to carry out big data analysis from your laptop on big and complex data sets.**

This particular notebook will go through a typical data science process but with one interesting twist

We will be connecting to enterprise data from different types of databases without actually moving data around due to Zetaris Lightning, our virtualization technology

Zetaris Lightning can streamline all processes and data 

Outline
---------

In the next 30 minutes, we will go through the following outline

 - The Problem Statement
 - The Data Set
 - The Enteprise Challenge
 - Virtual Data Connections
 - Exporatory Data Analysis
 - Unsupervised Machine Learning
 - Model Validation
 - Key Observations
 - The Zetaris Advantage

The Problem Statement
~~~~~~~~~~~~~~~~~~~~~~~~~

Medical patient's data with personal information and awkward details. 

The Data Set
~~~~~~~~~~~~~

Contains perosnal information about the patien'ts past data and their observations
 - Data Set 1 from System 1 behind a pathology system
 - Data Set 2 from System 2 beind a Patient healthcare system

**Setting Up the Data Science Environment**

We will be installing some packages to leverage the data science ecosystem in python right form within this notebook. So far this is typical work of a data scientist. 


This code imports popular and freely available python data science libraries. 
::
    %python.conda install pandas #Data Manipulation librarye
    %python.conda install psycopg2 #PostgreSQL library
    %python.conda install seaborn #Visualization library built-on top of Matplotlib
    numpy, sklearn and matplo%md

The Enterprise Challenge
--------------------------

Now come the time when the data scientist wants to carry out the analysis? 

Is it easy to get the data under one environment? 
    - Privacy 
    - Data Access
    - Risk Exposure
    - Data Breach 
    - Data Movement 
    - Resource Contention
    - Time Management

Typical vs the Zetaris Way
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Traditionally data scientists are used to getting the data moved to their local work environments, after a lot of struggle and hard work. That's why in this article, Time Magazine calls out that 80% of data scientists' work is Janitor Work (with all due respect to Janitors, data scientists prefer to analyze data more than prepare it)

Virtual Data Connections 
-------------------------

With Zetaris Lightning, data scientists can simply create 'virtual connections' to their data sets. 
The Zetaris Lightning (and Notebook) federates all queries related to data preparation to the databases that actually manage the data, instead of dealing with the above mentioned issues. 


Setting Up the data sets in Zetaris Lightning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Head over to Lightning GUI and setup the virtual views. Once done, return back to this Notebook. 


Testing the datasets connectivity via Lightning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Connection to your Zetaris Lightning environment is already made for you. Just to test this, do the following

code to select top n of the data set. 

Exploratory Data Analysis
------------------------------

Now lets explore the data before we fit a model to it. 

High level view of features and attribute labels::
    
    data.head()

Look at physical attributes of the data and null values::
    
    data.info()

Some summary statistics::

    data.describe()

Lets look at how the data is distributed across the key class
We will generate a scatter matrix (also known as a trellis) to quickly visualize correlations
::
    color_list = ['red' if i=='Abnormal' else 'green' for i in data.loc[:,'class']]
    pd.plotting.scatter_matrix(data.loc[:, data.columns != 'class'],
                                           c=color_list,
                                           figsize= [15,15],
                                           diagonal='hist',
                                           alpha=0.5,
                                           s = 200,
                                           marker = '*',
                                          edgecolor= "black")
    plt.show()

Now looking at how the key class is distributed
::
    sns.countplot(x="class", data=data)
    data.loc[:,'class'].value_counts()


Key Advantage in Machine Learning
-----------------------------------

One of the dichotomies in machine learning is to either develop more sophisiticated (typically slower or resource intensive) algorithms on given data sets or get better data with even simpler (but typically much faster) algorithms. The whole premise of building more sophisticated algorithms stems from daily challenges of not being able to access good labeled data or augment data sets from different silos for better features and attributes for training. 

Data Augmentation at Scale
------------------------------

With Zetaris in your enterprise, you can leverage faster and more effective data augmentation which is also more privacy preserving (as you are not moving data around) and better in quality (as data is processed through a unified exceptions management process) without losing the agility and with far less resources (no need to fight over compute clusters like before) and by using simpler but scalable machine learning algorithms. 

Unsupervised Machine Learning
------------------------------------

Believe it or not, we will be running a very simple algorithm that you probably never thought of running it on your distributed data before. 

The K-Nearest Neighbour
-----------------------------

This is a typical unsupervised learning algorithm to determine clusters in yourdata. The algorithm has a weak point though, its ability to predict better outcomes is dependent on certain parameters.
We can overcome these now in an entperise grade deployment by being able to run in multiple times to saturate the issues caused by 'overfitting'. 

Quickest KNN exercise.  
----------------------::
    from sklearn.neighbors import KNeighborsClassifier
    knn = KNeighborsClassifier(n_neighbors = 3)
    x,y = data.loc[:,data.columns != 'class'], data.loc[:,'class']
    knn.fit(x,y)
    prediction = knn.predict(x)
    print('Prediction: {}'.format(prediction))

Splitting the data into training and test (on a distributed big data sets!)
This should immediately improve accuracy but you can now easily perform data splits without typical ETL for big data. 

train test split
::
    from sklearn.model_selection import train_test_split
    x_train,x_test,y_train,y_test = train_test_split(x,y,test_size = 0.3,random_state = 1)
    knn = KNeighborsClassifier(n_neighbors = 3)
    x,y = data.loc[:,data.columns != 'class'], data.loc[:,'class']
    knn.fit(x_train,y_train)
    prediction = knn.predict(x_test)
    #print('Prediction: {}'.format(prediction))
    print('With KNN (K=3) accuracy is: ',knn.score(x_test,y_test)) # accuracy

**Accuracy and Over Fitting**

We all know how important to avoid overfitting in building and deployment models that 

Model complexity
~~~~~~~~~~~~~~~~~~~~~::
    neig = np.arange(1, 25)
    train_accuracy = []
    test_accuracy = []

Loop over different values of k
::
    for i, k in enumerate(neig):
        # k from 1 to 25(exclude)
        knn = KNeighborsClassifier(n_neighbors=k)
        # Fit with knn
        knn.fit(x_train,y_train)
        #train accuracy
        train_accuracy.append(knn.score(x_train, y_train))
        # test accuracy
        test_accuracy.append(knn.score(x_test, y_test))

Plot::

    plt.figure(figsize=[13,8])
    plt.plot(neig, test_accuracy, label = 'Testing Accuracy')
    plt.plot(neig, train_accuracy, label = 'Training Accuracy')
    plt.legend()
    plt.title('-value VS Accuracy')
    plt.xlabel('Number of Neighbors')
    plt.ylabel('Accuracy')
    plt.xticks(neig)
    plt.savefig('graph.png')
    plt.show()
    print("Best accuracy is {} with K = {}".format(np.max(test_accuracy),1+test_accuracy.index(np.max(test_accuracy))))


**The Zetaris Advantage for Unsupervised Learning**

The Zetaris platform empowers data scientists to run algorithms on massively large, disjointed data sets. This includes incremental algorithms that take muliple passes over the same data set. 
Data scientists benefit form the massive time saving they achieve from data peparation but also are able to run in constraints resources as well. 

Supervised Learning
~~~~~~~~~~~~~~~~~~~~~~~

Now we will train a supervised model, one that takes multiple passes over the data set before it is trained, the famous RandomForrests algorithm.
::
    from sklearn.metrics import classification_report, confusion_matrix
    from sklearn.ensemble import RandomForestClassifier
    x,y = data.loc[:,data.columns != 'class'], data.loc[:,'class']
    x_train,x_test,y_train,y_test = train_test_split(x,y,test_size = 0.3,random_state = 1)
    rf = RandomForestClassifier(random_state = 4)
    rf.fit(x_train,y_train)
    y_pred = rf.predict(x_test)
    cm = confusion_matrix(y_test,y_pred)
    print('Confusion matrix: \n',cm)
    print('Classification report: \n',classification_report(y_test,y_pred))

lets visualize the confusion matrix
::
    ns.heatmap(cm,annot=True,fmt="d") 
    plt.show()

Key Takeaways
~~~~~~~~~~~~~~~~~

- Human Time over Machine Time
- Big data analytics for the masses
- Avoiding Resource Contention
- Avoiding Data Movemnets, Proliferation
- Working in Privacy Preserved Environments. 

Findings
Taking Notes and Observations
        
        - [ ] Monitoring Speed (Both person and machine)
        - [ ] Monitoring  effort (both person and machine)
        - [ ] Monitoring  Resources (general discussion)


References

        - [Hidden Technical Debt in Machine Learning] (https://papers.nips.cc/paper/5656-hidden-technical-debt-in-machine-learning-systems.pdf)
        - [Janitor Work in Data Science](https://www.nytimes.com/2014/08/18/technology/for-big-data-scientists-hurdle-to-insights-is-janitor-work.html)
