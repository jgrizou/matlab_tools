function  confusionMatrix = hard_confusion_matrix(given_plabel, predicted_plabel)
%CONFUSION_MATRIX 
nLabels = size(given_plabel, 2);
given_hard_plabel = label_to_plabel(plabel_to_label(given_plabel), 1, nLabels);
predicted_hard_plabel = label_to_plabel(plabel_to_label(predicted_plabel), 1, nLabels);
confusionMatrix = proba_confusion_matrix(given_hard_plabel, predicted_hard_plabel);