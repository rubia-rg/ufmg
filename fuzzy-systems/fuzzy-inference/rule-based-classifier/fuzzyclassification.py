# Rule Based Fuzzy Classifier using Fuzzy-C-Means
# By: Rúbia Reis Guerra
# @rubia-rg
# Last update: Nov 18th, 2018

import skfuzzy as fuzzy
import numpy as np

from sklearn.metrics.pairwise import euclidean_distances
from sklearn.model_selection import train_test_split


# Stratified partition
def partition(data, labels, split_size=0.3):
    x_train, x_test, y_train, y_test = train_test_split(data, labels,
                                                        stratify=labels, test_size=split_size, random_state=7)
    return x_train, x_test, y_train, y_test


# Obtain fuzzy rules using Fuzzy-C-Means:
# Calculate centroids
# Each centroid projection on X1 and X2 corresponds to the mean for MF calculation
# Mean distance of X1 and X2 projections to centroids corresponds to the standard deviation for MF calculation
# Consequent is defined as class that outputs max membership
def fuzzyruleset(data, labels, k=8, m=2):
    centroids, u, u0, d, jm, p, fpc = fuzzy.cmeans(data.T, k, m, error=0.005, maxiter=1000,
                                                   metric='euclidean', init=None)
    # Obtain each samples' group
    groups = np.argmax(u, axis=0)

    # Calculate membership for each class
    u_class = []

    try:
        nclass = labels.nunique()[0]
    except TypeError:
        nclass = labels.nunique()

    for c in range(nclass):
        index = np.argwhere(np.array(labels).flatten() == c).ravel()
        u_class.append(np.sum(u[:, index], axis=1))
        u_class[c] = u_class[c] / np.linalg.norm(u_class[c])

    # Obtain each groups' class
    group_class = np.argmax(np.array(u_class), axis=0)

    # Calculate standard deviation of each group
    group_std = []

    for i in range(k):
        index = np.argwhere(groups == i).ravel()
        if len(index) == 0:
            try:
                group_std.append(np.mean(group_std))
            except RuntimeWarning:
                group_std.append(0.25)
        else:
            group_std.append(u_class[group_class[i]][i] * np.mean(euclidean_distances(data.iloc[index, :],
                                                                                      [centroids[i, :]])))

    group_std = group_std / np.linalg.norm(group_std)

    # Create set of fuzzy rules
    # Rule: If X1 is A1 and X2 is A2 then Y = C, C = {0, 1}
    rule_set = []

    for r in range(len(group_class)):
        rule_set.append({'mu': centroids[r, :], 'std': group_std[r], 'con': group_class[r]})

    return rule_set, groups


# Calculate activation of a rule using a gaussian membership function
def activation(sample, rule):
    mf = []
    for d in range(len(sample)):
        mf.append(fuzzy.gaussmf(sample[d], rule['mu'][d], rule['std']))

    return np.prod(mf)


# S-norm: aggregate rule activation
def probabilisticsum(a, b):
    return a + b - a * b


# Classify a sample
def fuzzyclassifier(sample, fuzzyruleset, nclass=2):
    nobs, ndim = np.shape(sample)
    predictions = np.zeros(nobs)

    # Aggregate activation for each class using s-norm
    for n in range(nobs):
        w_agg = np.random.rand(nclass)
        for r in fuzzyruleset:
            w = activation(sample.iloc[n, :], r)
            w_class = w_agg[r['con']]
            w_agg[r['con']] = probabilisticsum(w_class, w)
        predictions[n] = np.argmax(w_agg)

    return predictions


# Train fuzzy classifier
def trainfuzzyclass(data, labels, k=2):
    nobs, ndim = np.shape(data)
    return fuzzyruleset(data, labels, k, ndim)