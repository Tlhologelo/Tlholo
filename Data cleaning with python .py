#!/usr/bin/env python
# coding: utf-8

# In[17]:


#Importing Libraries
import pandas as pd
import numpy as np


# In[18]:


#Importing data
data = pd.read_csv('movies.csv')


# In[19]:


#Getting data
data.head()


# In[21]:


# Explore the size of the data set
data.shape


# In[22]:


# droping duplicates
data = data.drop_duplicates()
data.head()


# In[23]:


#Types of data
data.info()


# In[24]:


# Exploring the descriptive statistics
data.describe()


# In[25]:


#Checking for null values
data.isnull().sum()


# In[12]:


# Remove NAN
samples_before = data.shape[0]
data = data.dropna()
print('Remove %s sample' % (samples_before - data.shape[0]))


# In[26]:


#dropping column for year
data.drop(columns = 'gross')


# In[27]:


# NAN values removed
data.isnull().sum()


# In[28]:


#selecting subset columns
subset = data[['score','country','star','gross']]
subset.head()


# In[30]:


data['year'].head()


# In[31]:


data.head()


# In[34]:


#Exploring subsets of datasets
data.loc[(data['year']==1980)& (data['budget']> 1_000_000), ['year', 'budget']].head()


# In[37]:


#using loc funtion to select columns and rows
data.loc[[2,0]]


# In[ ]:




