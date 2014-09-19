classdef StringTCP < handle
    %TCP
%     usefull args
%     'Terminator', int8(';')
%     'TimeOut', inf
%     'NetworkRole', 'client'
%     'InputBufferSize', 30000
%     'OutputBufferSize', 30000
    
    properties
        f_tcp
    end
    
    methods
        function self = StringTCP(host, port, varargin)
            self.f_tcp = tcpip(host, port, varargin{:});
        end
        
        function open(self)
            fopen(self.f_tcp);
        end
        
        function close(self)
            fclose(self.f_tcp);
        end
        
        function delete(self)
            self.close();
        end
        
        function set_callback(self, clb)
%             clb can be @mycallback or {'mycallback'}
%             Callback functions require at least two input arguments. 
%             The first argument is the f_tcp desciptor 
%             The second argument is a variable that captures the event information given in the preceding table
%             function mycallback(obj,event)
%             You pass additional parameters to the callback function by including both the callback function and the parameters as elements of a cell array. For example, to pass the MATLAB variable time to mycallback,
%             clb = {@mycallback,time} or {'mycallback',time};
            self.f_tcp.BytesAvailableFcn = clb;
        end
        
        function flush(self)
            if self.f_tcp.BytesAvailable > 0
                fread(self.f_tcp, self.f_tcp.BytesAvailable);
            end
        end
        
        function send(self, msg)
            fprintf(self.f_tcp, msg);
        end
        
        function msg = receive(self)
            msg = fscanf(self.f_tcp);
            msg = msg(1:end-1); %remove Terminator
        end
    end
end

