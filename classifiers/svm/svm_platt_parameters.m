function [A,B] = svm_platt_parameters(deci,label,prior1,prior0)
%%This implementation have been extracted from:
% A NOTE ON PLATT'S PROBABILISTIC OUTPUTS FOR SUPPORT VECTOR MACHINES
%(Hsuan-Tien Lin , Chih-Jen Lin,Ruby C. Weng)
%
% Input parameters:
% deci = array of SVM decision values
% label = array of booleans: is the example labeled +1?
% prior1 = number of positive examples
% prior0 = number of negative examples
%
% Outputs:
% A, B = parameters of sigmoid
%
%REMINDER :     the sigmoid is 1 / ( 1 + exp( A*f+B)  where f is the 
%decision function output of the SVM

%Parameter setting
maxiter = 100; %Maximum number of iterations
minstep = 1e-10; %Minimum step taken in line search
sigma = 1e-12; %Set to any value > 0

%Construct initial values: target support in array t,
% initial function value in fval
hiTarget = (prior1 + 1) / (prior1 + 2);
loTarget = 1 / (prior0+2);
len = prior1 + prior0; % Total number of data

t = ones(len,1) * loTarget;
t(label > 0) = hiTarget;

A = 0;
B = log( (prior0 + 1) / (prior1 + 1) );

fApB = deci * A + B ;
fval = sum((t(fApB<0,1)-1).*fApB(fApB<0,1) + log(1+exp(fApB(fApB<0,1))));
fval = fval + sum((t(fApB>=0,1)).*fApB(fApB>=0,1) + log(1+exp(-fApB(fApB>=0,1))));

for  it = 1:maxiter
    %Update Gradient and Hessian (use H??? = H + sigma I)
    fApB = deci * A + B ;
    
    p = exp(-fApB) ./ (1 +exp(-fApB));
    p(fApB<0) = 1 ./ (1 + exp(fApB(fApB<0)));
    
    q = 1 ./ (1 + exp(-fApB));
    q(fApB<0) = exp(fApB(fApB<0)) ./ (1 + exp(fApB(fApB<0)));
        
    d2 = p.*q;
    h11 = sigma + sum(deci.*deci.*d2);
    h22 = sigma + sum(d2);
    h21 = sum(deci.*d2);
    d1 = t - p ;
    g1 = sum(deci.*d1);
    g2 = sum(d1);
               
    if (abs(g1) < 1e-5 && abs(g2) < 1e-5) %Stopping criteria
        break
    end
    
    %Compute modified Newton directions
    det = h11*h22 - h21*h21;
    dA = - (h22*g1 - h21*g2) / det;
    dB = -( -h21*g1 + h11*g2) / det;
    gd = g1*dA + g2*dB;
    stepsize = 1;
    
    while (stepsize > minstep) %Line search initially (stepsize >= minstep)
        newA = A + stepsize*dA;
        newB = B + stepsize*dB;
        
        fApB = deci * newA + newB ;
        newf = sum((t(fApB<0,1)-1).*fApB(fApB<0,1) + log(1+exp(fApB(fApB<0,1))));
        newf = newf + sum((t(fApB>=0,1)).*fApB(fApB>=0,1) + log(1+exp(-fApB(fApB>=0,1))));
        
        if (newf < (fval + 0.0001*stepsize*gd))
            A = newA;
            B = newB;
            fval = newf;
            break %Sufficient decrease satisfied        
        else
            stepsize = stepsize/2;
        end
    end
    
    if (stepsize < minstep)
        fprintf('Line search fails \n')
        break
    end
    
end

if (it >= maxiter)
fprintf('Reaching maximum iterations \n')

end




