function [output]=SumAll(varargin)
output=0;
disp_str="";
if nargin~=0
for i=1:nargin-1
    output = output+varargin{i};
    disp_str=disp_str+num2str(varargin{i})+"+";
end
output = output+varargin{nargin};
disp_str=disp_str+num2str(varargin{nargin})+"="+num2str(output);
end
disp(disp_str);
end


