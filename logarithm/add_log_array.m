function logSum = add_log_array(logs)
%ADD_LOG_ARRAY
%perform ln(a + b + c + ...)

nElements = length(logs);
if nElements > 1
    logSum = add_lns(logs(1),logs(2));
    for i = 1:nElements-2
        logSum = add_lns(logSum,logs(i+2));
    end
else
    logSum = logs;
end