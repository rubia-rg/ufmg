% Rúbia Reis Guerra
% ELE075 - Sistemas Nebulosos - TP3
% Dataset: breast-cancer-wisconsin

close all;
clear all;

load './data/breast-cancer/data.csv';
load './data/breast-cancer/labels.csv';

global figCounter;
figCounter = 1;

colors = {'k','b','r','g','y',[.5 .6 .7],[.8 .2 .6]};

step_sens = 0.3;
max_train_iterations = 300;
max_clustering_iter = 60;
threshold = 75;

% Plot original data set
C = unique(labels);
for i=0:(length(C))
   classidx = find(labels == i);
   plot(data(classidx, 9), data(classidx, 21), 'Marker', 'o', 'LineStyle','none')
   hold on
end

title('Original data set');

figure(figCounter);
figCounter = figCounter + 1;


[n, dim] = size(data);
stdout = 1;

k = 10;
p = 0.3;
max_iter = 30;
error_train = zeros(max_iter,1);
error_test = zeros(max_iter,1);

for iteration = 1:max_iter
    % Split data in training set and test set
    train_test_partitions = cvpartition(labels,'HoldOut',p);
    trnIdx = train_test_partitions.training(1);
    tstIdx = train_test_partitions.test(1);
    x_train = data(trnIdx, :);
    y_train = labels(trnIdx);
    x_test = data(tstIdx, :);
    y_test = labels(tstIdx);


    % Stratified k-Fold partitions
    cvFolds = cvpartition(y_train, 'Kfold', k);
    n_rules = {2, 3, 4};
    memb_functions = {'gaussmf','gauss2mf','gbellmf'};

    mse_all = zeros(length(n_rules), length(memb_functions));

    for rule = 1:length(n_rules)
        for mf = 1:length(memb_functions)
            mse_cv = zeros(cvFolds.NumTestSets,1);
            for i = 1:cvFolds.NumTestSets
                trIdx = cvFolds.training(i);
                teIdx = cvFolds.test(i);


                anfisModel = genfis3(...             % genfis3: Compute rules using FCM clustering
                             x_train(trIdx,:), ...
                             y_train(trIdx), ...
                             'sugeno', ...   % Use sugeno fuzzy model
                             n_rules{rule}, ...
                             [2.0 ...        % Exponent for fuzzy partition matrix
                              max_clustering_iter ...   % Max number of iterations
                              1e-4 ...       % Min improvement in objective function per iteration
                              false]);        % Verbose

                [anfisModel, errorConv, stepConv] = anfis([x_train(trIdx,:) y_train(trIdx)],...% Matrix with input-outputs in training set
                                              anfisModel, ...      % Initial model
                                              [max_train_iterations ...      % Number of epochs in training
                                               0 ...               % Error goal in training
                                               0.1 ...             % Initial step size
                                               1 - step_sens ...   % Step size decrease rate
                                               1 + step_sens], ... % Step size increase rate
                                              [false ...            % Display ANFIS info
                                               false ...            % Display error values
                                               false ...            % Display step size on each update
                                               false], ...          % Display results
                                              [x_train(trIdx,:) y_train(trIdx)],...% Validation data
                                              false);      % Optimization method. True = Hybrid, False = Back-propagation
                y_hat = evalfis(x_train(teIdx, :), anfisModel);
                y_hat_classes = (y_hat > threshold)*1;
                mse_cv(i) = immse(y_train(teIdx), y_hat_classes);
            end
            mse_all(rule, mf) = mean(mse_cv);
        end
    end

    [min_val,idx] = min(mse_all(:));
    [rule,mf] = ind2sub(size(mse_all),idx);
    error_train(iteration) = min_val;


    anfisModel = genfis3(...             % genfis3: Compute rules using FCM clustering
                             x_train, ...
                             y_train, ...
                             'sugeno', ...   % Use sugeno fuzzy model
                             n_rules{rule}, ...
                             [2.0 ...        % Exponent for fuzzy partition matrix
                              max_clustering_iter ...   % Max number of iterations
                              1e-4 ...       % Min improvement in objective function per iteration
                              false]);        % Verbose

    [anfisModel, errorConv, stepConv] = anfis([x_train y_train],...% Matrix with input-outputs in training set
                                              anfisModel, ...      % Initial model
                                              [max_train_iterations ...      % Number of epochs in training
                                               0 ...               % Error goal in training
                                               0.1 ...             % Initial step size
                                               1 - step_sens ...   % Step size decrease rate
                                               1 + step_sens], ... % Step size increase rate
                                              [false ...            % Display ANFIS info
                                               false ...            % Display error values
                                               false ...            % Display step size on each update
                                               false], ...          % Display results
                                              [x_train y_train],...% Validation data
                                              false);      % Optimization method. True = Hybrid, False = Back-propagation
    y_hat = evalfis(x_test, anfisModel);
    y_hat_classes = (y_hat > threshold)*1;
    error_test(iteration) = immse(y_test, y_hat_classes);    
end

plot(y_hat)

for i=0:(length(C))
   classidx = find(y_hat_classes == i);
   plot(x_test(classidx, 9), x_test(classidx, 21), 'Marker', 'o', 'LineStyle','none')
   hold on
end

% Plot convergence curves
figure(figCounter);
figCounter = figCounter + 1;
hold on;
plot(errorConv);
plot(stepConv);
title('ANFIS error and step convergence');
xlabel('Iteration number');
legend('Error convergence', 'Step size convergence');
hold off;
    
input('Press any key to close classification data...');
close all;