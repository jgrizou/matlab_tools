function varargout = get_output(anonymousFunction,outputNo,varargin)
%GET_OUPUT Return only the ouputNo of the anonymousFunction run with
%argument varargin
    varargout = cell(max(outputNo),1);
    [varargout{:}] = anonymousFunction(varargin{:});
    varargout = varargout(outputNo);
end