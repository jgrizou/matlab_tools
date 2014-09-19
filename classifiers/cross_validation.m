function [given, predicted] = cross_validation(blankClassifier, X, pY, nCrossValidation)
%CROSS_VALIDATION - Split the dataset in nCrossValidation train and test
%set and returns predicted and given pLabels per pair
%
%   Syntax:  [given, predicted] = cross_validation(classifier, X, pY, nCrossValidation)
%
%   Inputs:
%       blankClassifier - A anonymous function returning a classifier instance which should include the fit and predict function
%       X - Observation [matrix (nObservations, nFeatures)]
%       pY - Probability of each label [matrix (nObservations, nLabels)]
%       nCrossValidation - Number of Cross validation to perform [scalar]
%
%   Outputs:
%       given - Given probability of each label per cross validation set [cell matrix (1, nCrossValidation)] 
%                     We must use cell here because all test set may not have the same length
%       predicted - Predicted probability of each label per cross validation set [cell matrix (1, nCrossValidation)]
%                     We must use cell here because all test set may not have the same length
%
%   TODO:
%       Add tests, examples

%   Author: Jonathan Grizou
%   Equipe Flowers
%   200 Avenue de la vieille tour
%   33405 Talence
%   France
%   email: jonathan.grizou@inria.fr
%   Website: https://flowers.inria.fr/jgrizou/

if nCrossValidation < 1
    error('cross_validation:Input', 'nCrossValidation should be postive')
end
if ~ismatrix(X)
    error('cross_validation:InputDim', 'X must be 2-D.'); 
end
if size(X, 1) ~= size(pY, 1)
    error('cross_validation:InputDim', 'X and pY must have the same number of elements.'); 
end

[nObservations, nFeatures] = size(X);
nLabels = size(pY, 2);

if nCrossValidation > nObservations
   warning('cross_validation:NotEnoughData', 'There is less observation that number of cross validation asked, the number of cross validation is reduce to the number of observation') 
    nCrossValidation = nObservations;
end

shuffledIdx = randperm(nObservations); % I prefer to randomise the data as sometime we tend to receive them ordered per class
endIdx = floor(linspace(1, nObservations, nCrossValidation + 1));
startIdx = endIdx + 1;
endIdx = endIdx(2:end);
startIdx = startIdx(1:end-1);
startIdx(1) = 1;

given = cell(1, nCrossValidation);
predicted = cell(1, nCrossValidation);
for iCrossValidation = 1:nCrossValidation
    testIdx = startIdx(iCrossValidation):endIdx(iCrossValidation);
    trainIdx = setxor(1:nObservations, testIdx);
    testIdx = shuffledIdx(testIdx);
    trainIdx = shuffledIdx(trainIdx);
    
    classifier = blankClassifier();
    classifier.fit(X(trainIdx, :), pY(trainIdx, :))
    predicted{iCrossValidation} = classifier.logpredict(X(testIdx, :));
    given{iCrossValidation} = pY(testIdx, :);
end