clear serv
serv = ManualThresholdServer([1 2 44; 3 4 8888], [1 2 3]);


% function test()
%     a = [1 1 1; 2 2 2];
%     [b, c, d] = mat2cell(a, 2, [1 1 1])
%     cellfun(@myDisp, b, c, d)
% end
% 
% function myDisp(a, b, c)
%     sprintf('%d %d %d', a, b, c)
% end