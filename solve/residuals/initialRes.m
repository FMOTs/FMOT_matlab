function RES = initialRes(maxItera,varargin)
%初始化残差统计数据结构体
%简介：
%函数重载：
%   RES = initialRes(maxItera,fieldName)
%输入参数：
%   maxItera - 每部分残差矩阵记录的最大维度
%   fieldName - 每部分残差的类型，值为char的数组
%               例：['momentum','p']
%返回参数：
%   RES - 包含所有监视的残差的数据结构体

fieldNumber = length(varargin);
for i = 1:fieldNumber
   RES.(varargin{i}) = zeros(maxItera,1);
end
end

