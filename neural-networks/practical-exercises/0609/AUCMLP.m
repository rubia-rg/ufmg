%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CSLFMLP=  Cost-sensitive logistic function to MLP
% Author=   Yuri Sousa Aurélio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [theta,J] = AUCMLP(neurons,X,Y,iteration,regularization, ...
    lambda,eta_pos,eta_neg,eta_max,eta_min,eta)
    
% We will use multiclasse if we have to classify 3 or more classes, 
% so we are going to need the numbers of neurons in the output layer 
% equal to the number of classes

neurons(end) = 1;


if (length(neurons)<3)
    disp('There is not hidden neurons, you are not entering the neurons in the right way')
    return
end

if (neurons(1) ~= size(X,2))
    disp('The numbers of neurons in the first layer have to be the')
    disp('number of features of X')
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initializing the weigths theta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = cell(1,length(neurons)-1);
epsilon =  sqrt(6)/sum(neurons);     % it can be changed
for i=1:(length(neurons)-1)
    % theta is going to be matrix of n(l+1),n(l)+1] where is the number of 
    % neurons and l is the layer index
    % the +1 refers to the bias neuron
    theta{i} = -epsilon + (2*epsilon).*rand(neurons(i+1),neurons(i)+1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some useful variables in the process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n_layers = length(neurons);
m = size(X,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Making the y_aux matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y_aux = Y;
labels = 1;
if (length(labels)>2)
    disp('This model only works to two class')
    return
end
%the minority class must be one
label_1 = find(Y==labels);
label_2 = find(Y~=labels);
y_aux(label_1) = 1;
y_aux(label_2) = 0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now we will determinate the lambda in the article which is (N/M)⁻1
% lambda = pond_l and q = pond_q
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = size(X,1);
pond_l = ones(1,size(theta{end},1));
pond_q = ones(1,size(theta{end},1));
pond_l = length(find(y_aux==1));
pond_l = repmat(pond_l,m,1);
pond_q = repmat(pond_q,m,1);
pond_q = (m-pond_l);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calling the minimization function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[theta,J] = theta_min(theta,X,y_aux,neurons,iteration,lambda, ...
                    regularization,pond_l,pond_q,eta_pos,eta_neg, ...
                    eta_max,eta_min,eta);
                
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feed Forward
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = Feed_Forward(theta, X, neurons)

a = cell(1,length(neurons));
z = cell(1,length(neurons));
z{1} = X;
a{1} = X;
% adding the bias vector
a{1} = [ones(size(X,1),1),X];
for i=1:(length(neurons)-1)
    z{i+1} = a{i}*theta{i}';
    a{i+1} = logsig(z{i+1});
%     if ((i+1)<length(neurons))
%         a{i+1} = logsig(z{i+1});
%     else
%         a{i+1} = tanh(z{i+1});
%     end
    if (i+1)<length(neurons)
        a{i+1} = [ones(size(a{i+1},1),1),a{i+1}];
    else
        a{i+1} = a{i+1};
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function J = cost_J(X,a,theta,y_aux,lambda,regularization, pond_l, ...
                pond_q,neurons)

n_layers = length(neurons);
m = size(X,1);

% if it is classification problem
J = -log(1+((sum(y_aux.*a{n_layers}))./pond_l)-(sum((1-y_aux).*a{n_layers})./pond_q))...
      +log(2);
J = sum(J);
% applying regularization
if (regularization == 1)
    theta_aux = [];
    for i=1:(n_layers-1)
        theta_aux = [theta_aux,theta{i}(:,2:size(theta{i},2))];
    end
    J = J + (lambda/(2*m)).*sum(theta_aux(:).^2);
end          
            
end            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Back Propagation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [theta,eta,theta_grad_old] = Back_Propagation(X,a,theta, ...
            y_aux,regularization,lambda,pond_l,pond_q,neurons,delta_old, ...
                   eta_pos,eta_neg,eta_max,eta_min,eta,theta_grad_old)

n_layers = length(neurons);
m = size(X,1);
% Calculating errors
error = cell(n_layers,1);
J_error = (1+((sum(y_aux.*a{n_layers}))./pond_l)-(sum((1-y_aux).*a{n_layers})./pond_q));

error{n_layers} = -(((y_aux./pond_l)-((1-y_aux)./pond_q))./J_error)...
    .*a{n_layers}.*(1-a{n_layers});


% The error in the last hidden layer is
error{n_layers-1} = error{n_layers}*theta{n_layers-1}.*(a{n_layers-1}.* ...
                    (1-a{n_layers-1}));

% Otherwise we have
for i=2:(n_layers-1)
    error{n_layers-i} = error{n_layers-i+1}(:,2:end)*theta{n_layers-i} ...
                        .*(a{n_layers-i}.*(1-a{n_layers-i}));
end
% Calculating the gradients
theta_grad = cell(1,length(neurons)-1);
for i=1:(length(neurons)-2)
    theta_grad{i} = (error{i+1}(:,2:end)'*a{i});
end
theta_grad{n_layers-1} = (error{n_layers}'*a{n_layers-1});

% Apllying regularization
if (regularization == 1)
    for i=1:(n_layers-1)
        theta_grad{i}(:,2:end) = theta_grad{i}(:,2:end) + ...
                                (lambda/m)*(theta{i}(:,2:end));
    end
end
% Actualizing the parameters
for k=1:(n_layers-1)
    if (isempty(theta_grad_old{k})==1)
        produto = sign(theta_grad{k});
    else
        produto = sign(theta_grad{k}.*theta_grad_old{k});
    end
    pos_produto = find(produto>0);
    neg_produto = find(produto<0);
    zero_produto = find(produto==0);
    delta = ones(size(theta{k}));
    %Para mesmo sinal usa-se pos_produto
    if (isempty(pos_produto) == 0)
    eta{k}(pos_produto) = min(eta{k}(pos_produto)* ...
                                    eta_pos,eta_max);
    delta(pos_produto) = -(theta_grad{k}(pos_produto)).* ...
                            eta{k}(pos_produto);
    theta{k}(pos_produto) = theta{k}(pos_produto) + delta(pos_produto);
    end
    %Para sinal diferente usa-se neg_produto
    if (isempty(neg_produto) == 0)
    eta{k}(neg_produto) = max(eta{k}(neg_produto)* ...
                                    eta_neg,eta_min);
    delta(neg_produto) = -delta_old{k}(neg_produto);
    theta{k}(neg_produto) = theta{k}(neg_produto) + delta(neg_produto);
    theta_grad{k}(neg_produto) = 0;
    end
    %Para sinal diferente usa-se zero_produto
    if (isempty(zero_produto) == 0)
    delta(zero_produto) = -(theta_grad{k}(zero_produto)).* ...
                            eta{k}(zero_produto);
    theta{k}(zero_produto) = theta{k}(zero_produto) + delta(zero_produto);
    end
    delta_old{k} = delta;
end
theta_grad_old = theta_grad;
           
end            

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implementing the loop to find the minimum error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [theta,J] = theta_min(theta,X,y_aux,neurons,iteration, ...
                 lambda,regularization,pond_l,pond_q, ...
                 eta_pos,eta_neg,eta_max,eta_min,eta)

eta_aux = eta;
eta = cell(size(theta));
for j=1:length(theta)
    eta{j} = 0.*theta{j}+eta_aux;
end
delta_old = eta;
J = zeros(1,iteration);
theta_grad_old = cell(1,length(neurons)-1);
for i=1:iteration
    a = Feed_Forward(theta,X,neurons);
    J(i) = cost_J(X,a,theta,y_aux,lambda,regularization,pond_l,pond_q, ...
                  neurons);
    [theta,eta,theta_grad_old] = Back_Propagation(X,a,theta,y_aux, ...
                 regularization,lambda,pond_l,pond_q,neurons,delta_old, ...
                eta_pos,eta_neg,eta_max,eta_min,eta,theta_grad_old);
end
             
end







