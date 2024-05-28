classdef simple < handle
%SIMPLE算法的迭代控制类
%简介：
%构造函数：
%   构造函数1重载：
%   obj = simple(itera)
%   obj = simple(itera,mResCon,cResCon)
%成员函数：
%   advance_itera = loop(obj,varargin)   
%   
%成员变量：
%   end_itera   - 结束迭代步
%   begin_itera - 起始迭代步，默认值 = 0
%   local_itera - 当前迭代步
%   isLoop      - 是否继续迭代判断



    properties
        end_itera;
        begin_itera = 0;
        local_itera = 0;
        isLoop = logical(false);
    end
    
    methods
        function obj = simple(itera)
        %SIMPLE：构造函数
        %   迭代步进程统计
        %判断itera是否为整数
            if isinteger(itera)
                error('SIMPLE:初始化迭代次数必须为整数');
            end
            obj.end_itera = itera;
            obj.isLoop = true;
        end

    end



   methods(Static)
       function advance_itera = loop(obj,varargin)
       %SIMPLE：迭代循环自动控制成员函数
            if obj.local_itera == 0
                fprintf('SIMPLE算法迭代开始：\n');
            end
            %循环迭代终止判断
            if abs(obj.local_itera - obj.end_itera) < 0.0000001
                fprintf('SIMPLE算法迭代结束。\n');
                obj.isLoop = false;
                advance_itera = obj.isLoop;
            else
               fprintf('SIMPLE:当前迭代步为%d,',obj.local_itera);
                obj.local_itera = obj.local_itera + 1;
                advance_itera = true;
            end

            %循环残差终止判断
            if nargin > 2
            %SIMPLE:迭代收敛标准选择
                RES = varargin{1};
                name = varargin{2};
                if ~isfield(RES,name)
                    error('SIMPLE.resControl():RES中不包含输入的%s残差数据',name);
                end
                if nargin == 3
                    standard = 1e-6;
                elseif nargin > 3
                    standard = varargin{3};
                end

                if obj.local_itera > 1
                    nowRes = RES.(name)(obj.local_itera-1,1);
                    if nowRes < standard
                        disp('SIMPLE:Converged'); 
                        obj.isLoop = false;
                        advance_itera = obj.isLoop;
                    end
                end

            end
       end

        function RES = iteraRes(obj,RES,field,filedEqn,name)
        %SIMPLE：计算物理场迭代残差，对iterRes的simple封装
        % 函数说明见：
        % RES = iteraRes(i,RES,field,filedEqn,name)
            RES = iteraRes(obj.local_itera,RES,field,filedEqn,name);
        end
    

        function RES = massRes(obj,RES,mass,iteraSelect)
        %SIMPLE：计算连续性方程误差，对massrRes的simple封装
        % 函数说明见：
        % RES = massRes(i,RES,mass,iteraSelect)
            if nargin == 3
                iteraSelect = 5;
            end
            RES = massRes(obj.local_itera,RES,mass,iteraSelect);
        end
    

        function RES = plotRES(obj,RES)
        %SIMPLE:动态显示残差
            figure(1)
            % hold on
            %获取残差中的变量个数
            nameRES = fieldnames(RES);
            numRES = length(nameRES);
            for i = 1:numRES
                plot(1:obj.local_itera,...
                    log10(RES.(nameRES{i,1})(1:obj.local_itera,1)), ...
                    'LineWidth',2); 
            end
            legend(nameRES{:,1});

            hold on
            % hold off
        end
   end
end

