function confusionMatrix = proba_confusion_matrix(given_plabel, predicted_plabel)
%PROBA_CONFUSION_MATRIX

confusionMatrix = given_plabel' * predicted_plabel;
confusionMatrix = confusionMatrix ./ sum(sum(confusionMatrix));