function [X, Y, accuracy] = generate_quality_dataset(anonymousFunctionBlankClassifier, accuracyRange, nPointPerClusters, meansRand, covsRand, maxTrial)
%GENERATE_QUALITY_DATASET

minAccuracy = accuracyRange(1);
maxAccuracy = accuracyRange(2);
nClusters = length(meansRand);

iTrial = 0;
accuracyOk = false;
while ~accuracyOk
    
%     fprintf('%4d/%4d', iTrial, maxTrial);
    
    for iCluster = 1:nClusters
        mus(1,:,iCluster) = meansRand{iCluster}();
        sigmas(:,:,iCluster) = covsRand{iCluster}();
    end
    
    [X, Y] = gaussian_clusters(mus, sigmas, nPointPerClusters, false);    
    pY = label_to_plabel(Y, 1, nClusters);
    %CV
    [predicted, given] = cross_validation(anonymousFunctionBlankClassifier, X, pY, 10);
    predicted = vertcat(predicted{:});
    given = vertcat(given{:});        
    %
    accuracy = accuracy_label(plabel_to_label(predicted), plabel_to_label(given));
    if accuracy >= minAccuracy && accuracy <= maxAccuracy
        accuracyOk = true;
    end
    
    iTrial = iTrial + 1;
    if iTrial > maxTrial
       X = -1;
       Y = -1;
       accuracy = -1;
       return
    end
    
%     disp(accuracy)
end