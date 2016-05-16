classdef ClassTest < handle
   
    methods
        function classTestObj = ClassTest()
            classTestObj.a()
%             classTestObj.b()
            
        end
        
        function a(obj)
            function b()
                disp('b')
            end
            disp('a')
            b
        end
        
        

        
    end
    
end