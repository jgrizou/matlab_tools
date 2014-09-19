classdef Logger < dynamicprops
    %@LOGGER
    %
    %   I took inspiration from logger-1.0 by Pavan Mallapragada, MIT, Otcober, 2011
    %   scalar and cell are stacked variable in one column
    
    properties % All properties are public, you should know what you are doing if modifying one of them
        fields = {} % A cell array that stores all the fields that are being logged by the object currently, as strings.
        nElementsFields = [] % Only for the sake of the disp method, count the number of element pushed
        metaFields = {} % Meta dynamis property of each user fields
        % new field property will be added dynamically
        
        infos = {} % Cell array to store info messages
        warnings = {} % Cell array to store warning messages
        errors = {} % Cell array to store error messages
        
        msgFunc = @warning % function used by the logger when problems occur
        
        silent = true % logger print message when adding elements
    end
    
    methods
        function self = Logger()
        end
        
        function logit(self, variable)
            % Should be enough for most use, the name of the variable is used as fieldName
            fieldName = inputname(2);
            self.log_field(fieldName, variable)
        end
        
        function log_from_workspace(self, variableNames, workspaceName)
            % variableNames must be a cell vector of string
            variableNames = self.ensure_cell_of_string(variableNames);
            if nargin < 3
                workspaceName = 'base';
            end
            for iVariableName = 1:length(variableNames)
                try
                    variable = evalin(workspaceName, variableNames{iVariableName});
                    self.log_field(variableNames{iVariableName}, variable)
                catch exception
                    if ~self.silent
                        fprintf(['Logger: ', variableNames{iVariableName}, ' not in workspace, skip to next field\n']);
                    end
                end
            end
            
        end
        
        function log_all_registered(self, workspaceName)
            if nargin < 2
                workspaceName = 'base';
            end
            self.log_from_workspace(self.fields, workspaceName)
        end
        
        function valid = is_prop(self, propertyName)
            % Return true is propertyName exist
            % the built-in isprop does not work for me...
            valid = false;
            p = findprop(self, propertyName);
            if ~isempty(p) && strcmpi(p.Name, propertyName)
                valid = true;
            end
        end
        
        function add_field(self, fieldNames)
            % Add a user field to the logger (may use several fields if needed in a cell vector)
            fieldNames = self.ensure_cell_of_string(fieldNames);
            for iFieldName = 1: length(fieldNames)
                fieldName = fieldNames{iFieldName};
                if ~self.is_prop(fieldName)
                    meta = addprop(self, fieldName);
                    self.fields{end + 1} = fieldName;
                    self.metaFields{end + 1} = meta;
                    self.nElementsFields(end + 1) = 0;
                    if ~self.silent
                        fprintf(['Logger: new field added to the logger object: ', fieldName,'\n']);
                    end
                else
                    self.msgFunc('Logger:add_fields', ['"', fieldName, '" is already registered'])
                end
            end
        end
        
        function increment_field(self, fieldName)
            % Only for the sake of the disp method, count the number of element pushed
            % this is due to the fact we log different type of variable and the length of an array correspond to the biggest dimension
            % which means that is you log 5 row_vectors of dimension 50, by estimating the length you will receive 5
            % as we also log for colum_vectors and matrix we never which dimension correspong to the number of log
            % therefore we need to track this number
            self.nElementsFields(strcmp(self.fields, fieldName)) = self.nElementsFields(strcmp(self.fields, fieldName)) + 1;
        end
        
        function nElementsField = n_elements_field(self, fieldName)
            nElementsField = self.nElementsFields(strcmp(self.fields, fieldName));
        end
        
        function rm_field(self, fieldNames)
            % Remove a user field and all its content to the logger (may use several fields if needed in a cell vector)
            fieldNames = self.ensure_cell_of_string(fieldNames);
            for iFieldName = 1: length(fieldNames)
                fieldName = fieldNames{iFieldName};
                if self.is_prop(fieldName)
                    fieldIdx = strcmp(self.fields, fieldName);
                    if ~self.silent && any(fieldFind)
                        fprintf(['Logger: field removed from the logger object: ', fieldName,'\n']);
                    end
                    self.metaFields{fieldIdx}.delete
                    self.fields(fieldIdx) = [];
                    self.metaFields(fieldIdx) = [];
                    self.nElementsFields(fieldIdx) = [];
                else
                    self.msgFunc('Logger:rm_fields', ['"', fieldName, '" is not a current property'])
                end
            end
        end
        
        function replace_field(self, fieldName, value)
            % simply remove and log the field
            % only for one field
            % if field does not exist create it
            if self.is_prop(fieldName) 
                self.rm_field(fieldName)
            end
            self.log_field(fieldName, value)
        end
        
        function log_field(self, fieldName, value)
            % Try to find a match according to the type of the variable
            % Currently implemented:
            %   - scalars are stored in array
            %   - row vectors are stored in matrix
            %   - column vectors are stored matrix
            %   - matrix are stored in 3D array
            %   - others are stored in a cell vector
            % We choosed to stack variable in a column for scalar and cell
            if isnumeric(value) || islogical(value)
                if isscalar(value)
                    self.log_scalar(fieldName, value)
                elseif isvector(value)
                    if size(value, 1) == 1 % its a row vector
                        self.log_row_vector(fieldName, value)
                    else % its a column vector
                        self.log_column_vector(fieldName, value)
                    end
                elseif ismatrix(value)
                    self.log_matrix(fieldName, value)
                else
                    self.log_in_cell(fieldName, value)
                end
            else
                self.log_in_cell(fieldName, value)
            end
        end
        
        function log_multiple_fields(self, fieldNames, values)
            % same as log field but for multiple field at once
            % this is separate as log_field can not known if a values that
            % is vector cell is for one or several values!
            fieldNames = self.ensure_cell_of_string(fieldNames);
            values = self.ensure_cell_of_values(values);
            for iElement = 1: length(fieldNames)
                fieldName = fieldNames{iElement};
                value = values{iElement};
                self.log_field(fieldName, value)
            end
        end
        
        function log_from_struct(self, structToLog)
            % log each struct field value with its field name 
            fieldNames = fieldnames(structToLog);
            for iElement = 1: length(fieldNames)
                fieldName = fieldNames{iElement};
                value = structToLog.(fieldName);
                self.log_field(fieldName, value)
            end
        end
        
        function log_from_logger(self, logger, fieldNames)
            % log each logger field value with its field name 
            if nargin < 3
                fieldNames = logger.fields;
            else
                fieldNames = self.ensure_cell_of_string(fieldNames);
            end
            values = logger.get_cell_of_fields(fieldNames);
            self.log_multiple_fields(fieldNames, values)
        end
        
        function log_scalar(self, fieldName, scalar)
            if ~self.is_prop(fieldName)
                self.add_field(fieldName)
            end
            if self.n_elements_field(fieldName) == 0
                self.(fieldName) = scalar;
            else
                self.(fieldName)(end+1, 1) = scalar;
            end
            self.increment_field(fieldName)
        end
        
        function log_row_vector(self, fieldName, rowVector)
            if ~self.is_prop(fieldName)
                self.add_field(fieldName)
            end
            if self.n_elements_field(fieldName) == 0
                self.(fieldName) = rowVector;
            else
                self.(fieldName)(end+1, :) = rowVector;
            end
            self.increment_field(fieldName)
        end
        
        function log_column_vector(self, fieldName, columnVector)
            if ~self.is_prop(fieldName)
                self.add_field(fieldName)
            end
            if self.n_elements_field(fieldName) == 0
                self.(fieldName) = columnVector;
            else
                self.(fieldName)(:, end+1) = columnVector;
            end
            self.increment_field(fieldName)
        end
        
        function log_matrix(self, fieldName, matrix)
            if ~self.is_prop(fieldName)
                self.add_field(fieldName)
            end
            if self.n_elements_field(fieldName) == 0
                self.(fieldName) = matrix;
            else
                self.(fieldName)(:, :, end+1) = matrix;
            end
            self.increment_field(fieldName)
        end
        
        function log_in_cell(self, fieldName, stuff)
            if ~self.is_prop(fieldName)
                self.add_field(fieldName)
            end
            if self.n_elements_field(fieldName) == 0
                % not yet a cell to facilitate access
                self.(fieldName) = stuff;
            else
                if self.n_elements_field(fieldName) == 1
                    %make it a cell
                    self.(fieldName) = {self.(fieldName)};
                end
                self.(fieldName){end+1, 1} = stuff;
            end
            self.increment_field(fieldName)
        end
        
        function log_string(self, fieldName, string)
            % Sting are stored in cell vector
            self.log_in_cell(fieldName, string)
        end
        
        function log_info(self, msg)
            self.log_string('infos', msg)
        end
        
        function log_warning(self, msg)
            self.log_string('warnings', msg)
        end
        
        function log_error(self, msg)
            self.log_string('errors', msg)
        end
        
        function cellFields = get_cell_of_fields(self, fieldNames)
            %return a cell vector that contains the required fields in order
            fieldNames = self.ensure_cell_of_string(fieldNames);
            nFieldName = length(fieldNames);
            cellFields = cell(1, nFieldName);
            for iFieldName = 1: nFieldName
                fieldName = fieldNames{iFieldName};
                if self.is_prop(fieldName)
                    cellFields{iFieldName} = self.(fieldName);
                else
                    cellFields{iFieldName} = [];
                    self.msgFunc('Logger:get_cell_of_fields', ['"', fieldName, '" is not a valid property, append [], other fields will be included'])
                end
            end
        end
        
        function save(self, filename)
            % save Logger instance in filename.
            % the instance name when loading filename will be the same name
            % than the logger instance who called it
            % e.g l = Logger(); l.save('here.mat')
            % inside here.mat, the logger will be saved as 'l'
            % this is interresting for code that uses 'l' later
            % and yes it is the same thing as save('here.mat', 'l')
            loggerName = inputname(1);
            eval([loggerName, ' = self;']) % ok its ugly
            save(filename, loggerName)
        end
        
        function save_all_fields(self, filename)
            fieldNames = {self.fields{:}, 'infos', 'warnings', 'errors'};
            self.save_fields(filename, fieldNames);
        end
        
        function save_fields(self, filename, fieldNames)
            % save several fields in filename
            % this function allow for more flexible reuse of the data as
            % there is no need to have the Logger class file
            % fieldNames is a cell vector
            fieldNames = self.ensure_cell_of_string(fieldNames);
            toSave = struct;
            for iFieldName = 1:length(fieldNames)
                fieldName = fieldNames{iFieldName};
                if self.is_prop(fieldName)
                    toSave.(fieldName) = self.(fieldName);
                else
                    self.msgFunc('Logger:save_fields', ['"', fieldName, '" is not a valid property, other fields will be saved'])
                end
            end
            save(filename, '-struct', 'toSave')
        end
        
        function disp(self)
            fprintf('Logger object\n\n');
            fprintf('User Fields:\n');
            
            for i = 1:numel(self.fields)
                fprintf('%5d log entries for %s\n', self.n_elements_field(self.fields{i}), self.fields{i});
            end
            
            fprintf('OTHERS:\n');
            
            fprintf('%5d infos\n', length(self.infos));
            fprintf('%5d warnings\n', length(self.warnings));
            fprintf('%5d errors\n', length(self.errors));
        end
        
        function structToSave = saveobj(self)
            % structToSaveave property values in struct
            % Return struct for save function to write to MAT-file
            structToSave = struct;
            structToSave.fields = self.fields; 
            structToSave.nElementsFields = self.nElementsFields;

            structToSave.infos = self.infos;
            structToSave.warnings = self.warnings;
            structToSave.errors = self.errors;

            structToSave.msgFunc = self.msgFunc;
            structToSave.silent = self.silent;
            
            structToSave.userProperties = struct;
            for iField = 1:length(self.fields)
               structToSave.userProperties.(self.fields{iField}) = self.(self.fields{iField});
            end
        end
        
    end
    
    methods(Static)
        
        function self = loadobj(savedStruct)
            % Constructs a MySuper object
            % loadobj used when a superclass object is saved directly
            % Calls reload to assign property values retrived from struct
            % loadobj must be Static so it can be called without object
            self = Logger();
            for iField = 1:length(savedStruct.fields)
                fieldName = savedStruct.fields{iField};
                self.add_field(fieldName)
                self.(fieldName) = savedStruct.userProperties.(fieldName);
            end
            self.nElementsFields = savedStruct.nElementsFields;
            
            self.infos = savedStruct.infos;
            self.warnings = savedStruct.warnings;
            self.errors = savedStruct.errors;

            self.msgFunc = savedStruct.msgFunc;
            self.silent = savedStruct.silent;            
        end      
        
        function names = ensure_cell_of_string(names)
            if ischar(names)
                names = {names};
            end
            if ~iscellstr(names) || ~isvector(names)
                error('Logger:ensure_cell_of_string', 'names should be a cell vector of string')
            end
        end
        
        function values = ensure_cell_of_values(values)
            %warning only ensure the values are a vector of cell
            if ~iscell(values) && ~isvector(values)
                error('Logger:ensure_cell_of_values', 'values should be a cell vector')
            end
        end
    end
end