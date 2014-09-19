classdef Dispatcher < handle
%DISPATCHER Manage a dataset and return data from label
%By default the dispatcher never send twice the same data point
%If endless set to true, the dispatcher will use back old data once it first use them all
    
    properties
        X % Observations [matrix (nObservations x nFeatures)]
        labelsIndices % Organized labels [containers.Map]   
        inUseLabelsIndices % In use organized labels [containers.Map] 
        
        endless = false
    end
    
    methods
        function self = Dispatcher(X, Y, endless)
            % X - Observations [matrix (nObservations x nFeatures)]
            % Y - Labels number [vector (nObservations)]
            % endless - Allow or not to reuse data (optional)
            if nargin > 2
                self.endless = endless;
            end

            self.X = X;
            
            labels = num2cell(unique(Y));
            nLabels = length(labels);
            tmp_index = cell(nLabels, 1);
            for iLabel = 1:nLabels
               tmp_index{iLabel} = find(Y == labels{iLabel});
            end
            self.labelsIndices = containers.Map(labels, tmp_index);
            self.inUseLabelsIndices = containers.Map(labels, tmp_index);
        end
        
        function labels = get_available_labels(self)
           labels = cell2mat(self.labelsIndices.keys());
        end
        
        function isEmpty = is_empty(self, label)
            % true is no more sample for this label
            if ~self.labelsIndices.isKey(label)
                error('Dispatcher:get_sample:InvalidInput', 'label not in dispatcher.')
            end
            isEmpty = isempty(self.inUseLabelsIndices(label));
        end
        
        function [isEmpty, labels] = who_is_empty(self)
           labels = self.get_available_labels();
           isEmpty = zeros(1, length(labels));
           for iLabel = 1:length(labels)
               isEmpty(iLabel) = self.is_empty(labels(iLabel));
           end            
        end
        
        function reset(self, label)
            % reset the dispatcher for label
            % if label not define, reset all labels
            if nargin == 1 %no label defined
                self.inUseLabelsIndices = containers.Map(self.labelsIndices.keys, self.labelsIndices.values); 
                return
            end            
            if ~self.labelsIndices.isKey(label)
                error('Dispatcher:get_sample:InvalidInput', 'label not in dispatcher.')
            end                       
            self.inUseLabelsIndices(label) = self.labelsIndices(label);
        end
        
        function sample = get_sample(self, label)
            % returns a sample of label (randomly choosen)
            % If no more data are available for label:
            %   - If endless == false - returns an empty sample
            %   - If endless == true - reset label and return an already used sample

            if ~self.labelsIndices.isKey(label)
                error('Dispatcher:get_sample:InvalidInput', 'label not in dispatcher.')
            end
            
            sample = [];
            if self.is_empty(label)
                if self.endless
                    self.reset(label)
                else
                    return
                end
            end
            % sample observation
            indices = self.inUseLabelsIndices(label);
            nIndices = length(indices);            
            selectedIdx = randi(nIndices);
            sample = self.X(indices(selectedIdx), :); 
            % update indices
            indices(selectedIdx) = [];
            self.inUseLabelsIndices(label) = indices;
        end
    end
    
    methods(Static)
        function dispatcherInstance = from_matfile(matfile, endless)
            % matfile should contain
            % X - Observations [matrix (nObservations x nFeatures)]
            % Y - Labels number [vector (nObservations)]
            tmp = load(matfile);
            if nargin < 2
                dispatcherInstance = Dispatcher(tmp.X, tmp.Y);
            else
                dispatcherInstance = Dispatcher(tmp.X, tmp.Y, endless);
            end
        end
    end
end

































