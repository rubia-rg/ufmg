# Rule Based Fuzzy Classifier using Fuzzy-C-Means
# By: Rúbia Reis Guerra
# @rubia-rg
# Last updated: Nov 18th, 2018

# Test Module
# Datasets:
# 1 - Synthetic Data: dataset_2d.mat
# 2 - PIMA Diabetes (http://ftp.ics.uci.edu/pub/machine-learning-databases/pima-indians-diabetes/)


import pandas as pd
import fuzzyclassification as fc
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from scipy.io import loadmat
# from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score
from sklearn.metrics import roc_auc_score
# from sklearn.metrics import confusion_matrix

if __name__ == '__main__':

    # Load synthetic data
    x_mat = loadmat('dataset_2d.mat')["x"]
    y_mat = loadmat('dataset_2d.mat')["y"]
    x_mat = pd.DataFrame(x_mat, columns=['x1', 'x2'])
    y_mat = pd.DataFrame(y_mat, columns=['y'])

    # Load PIMA Diabetes data (UCI)
    pima = pd.read_csv('diabetes.csv')
    x_pima = pima.drop('Outcome', axis=1)
    x_pima_norm = ((x_pima-x_pima.min())/(x_pima.max()-x_pima.min()))
    y_pima = pima['Outcome']

    # Define test params
    k_size = [2, 3, 5, 6, 7, 8]
    all_data = [[x_mat, y_mat], [x_pima_norm, y_pima]]
    n_iter = 30

    acc_pima = []
    acc_syn = []
    auc_pima = []
    auc_syn = []
    group_k = []
    model_k = []
    data_k = []
    labels_k = []
    pred_k = []
    train_k = []

    for data, labels in all_data:
        for k in k_size:
            acc_k = []
            auc_k = []
            best_acc = 0

            for i in range(n_iter):
                train, test, train_labels, test_labels = fc.partition(data, labels)
                model, data_groups = fc.trainfuzzyclass(train, train_labels, k)
                predictions = fc.fuzzyclassifier(test, model)
                auc_k.append(roc_auc_score(test_labels, predictions))
                acc_k.append(accuracy_score(test_labels, predictions))
                if best_acc < acc_k[i]:
                    best_acc = acc_k[i]
                    best_groups = data_groups
                    best_model = model
                    best_data = test
                    best_labels = test_labels
                    best_pred = predictions
                    best_train = train

            if np.shape(data)[1] > 2:
                auc_pima.append(auc_k)
                acc_pima.append(acc_k)
            else:
                auc_syn.append(auc_k)
                acc_syn.append(acc_k)
                group_k.append(best_groups)
                model_k.append(best_model)
                data_k.append(best_data)
                labels_k.append(best_labels)
                pred_k.append(best_pred)
                train_k.append(best_train)

    syn = sns.boxplot(k_size, acc_syn, palette="Blues")
    plt.ylim([0, 1])
    plt.ylabel("Accuracy")
    plt.xlabel("k size")
    plt.title("Synthetic Data: Test Accuracy")
    plt.savefig("acc_syn.png")
    plt.clf()

    syn_auc = sns.boxplot(k_size, auc_syn, palette="Blues")
    plt.ylim([0, 1])
    plt.ylabel("AUC")
    plt.xlabel("k size")
    plt.title("Synthetic Data: Test AUC")
    plt.savefig("auc_syn.png")
    plt.clf()

    pima = sns.boxplot(k_size, acc_pima, palette="Oranges")
    plt.ylim([0, 1])
    plt.ylabel("Accuracy")
    plt.xlabel("k size")
    plt.title("PIMA: Test Accuracy")
    plt.savefig("acc_pima.png")
    plt.clf()

    pima_auc = sns.boxplot(k_size, auc_pima, palette="Oranges")
    plt.ylim([0, 1])
    plt.ylabel("AUC")
    plt.xlabel("k size")
    plt.title("PIMA: Test AUC")
    plt.savefig("auc_pima.png")
    plt.clf()

    colors = ['red', 'navy']
    for i in range(len(k_size)):
        df = data_k[i]
        value = (pred_k[i] > 0)
        df['color'] = np.where(value == True, colors[0], colors[1])
        sns.regplot(data=df, x='x1', y='x2', fit_reg=False, scatter_kws={'facecolors': df['color']})
        for j in range(k_size[i]):
            sns.regplot(x=pd.Series(model_k[i][j]['mu'][0],name='x1'), y=pd.Series(model_k[i][j]['mu'][1],name='x2'),
                        fit_reg=False, marker="+", color=sns.color_palette()[j])
        figname = "preds" + str(i) + ".png"
        plt.savefig(figname)
        plt.clf()

    for i in range(len(k_size)):
        df = data_k[i]
        value = (labels_k[i] > 0)
        df['color'] = np.where(value == True, colors[0], colors[1])
        sns.regplot(data=df, x='x1', y='x2', fit_reg=False, scatter_kws={'facecolors': df['color']})
        figname = "labels" + str(i) + ".png"
        plt.savefig(figname)
        plt.clf()

    for i in range(len(k_size)):
        df = train_k[i]
        df['group'] = group_k[i]
        sns.lmplot(data=df, x='x1', y='x2', fit_reg=False, hue='group')
        figname = "groups" + str(i) + ".png"
        plt.savefig(figname)
        plt.clf()