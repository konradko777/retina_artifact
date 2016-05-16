classdef List < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(GetAccess=private)
        length = 0;
        data = {};
    end
    
    methods
        function l = List
            %empty list
        end
        
        function add(l, el)
            l.length = l.length + 1;
            l.data{l.length} = el;
            
        end
        
        function el = getEl(l, idx)
            el = l.data{idx};
        end
        
        function removeEl(l, idx)
            l.data(idx) = [];
            l.length = l.length - 1;
        end
        
        function el = popEl(l, idx)
            el = getEl(l, idx);
            removeEl(l,idx)
        end
    end
end


%         function l = List(data)
%             l = List();
%             for i = 1:length(data)
%                 l.length = l.length + 1;
%                 l.data(l.length) = data(l.length);                
%             end
%         end