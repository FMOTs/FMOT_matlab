classdef piso < handle
%PISO算法的循环迭代控制类
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
        
        pCorrectors;
        iteraNumber;
        %时间相关
        dt;
        end_t;
        begin_t = 0;
        local_t = 0;
        isLoop = logical(false);
        %迭代相关
        end_itera;
        begin_itera = 0;
        local_itera;
        isItera = logical(false);
        iteraSum = 0;
    end
%%--------------------------PISO初始化--------------------------%%
    methods
        function obj = piso(dt,iter_t,nPCorrect)
            %PISO：构造函数
            if isinteger(nPCorrect) 
                error('PISO:压力循环修正次数必须为整数');
            end
            %PISO：nPCorrect必须大于1
            if nPCorrect < 2
                error('PISO:nPCorrect的最小值为2');
            end
            %   根据时间步长(dt)和总步数(iter_t)自动计算时间相关参数
            obj.dt = dt;
            obj.isLoop = true;
            obj.end_t = obj.begin_t + iter_t*dt;
            obj.local_itera = 1;
            %   根据时间步长(dt)和总步数(iter_t)自动计算时间相关参数
            obj.end_itera = nPCorrect;
            obj.isItera = true;
        end


    end



   methods(Static)
%%--------------------------循环和迭代控制--------------------------%%
       function advance_t = loop(obj,varargin)
       %PISO：迭代循环自动控制成员函数
            if obj.local_t == 0
                fprintf('PISO算法迭代开始：\n');
            end
            %循环迭代终止判断
            if abs(obj.local_t - obj.end_t) < 0.0000001
                fprintf('PISO算法迭代结束。\n');
                obj.isLoop = false;
                advance_t = obj.isLoop;
            else
               fprintf('PISO:当前迭代步为%d,',obj.local_t);
                obj.local_t = obj.local_t + obj.dt;
                advance_t = true;
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
                        advance_t = obj.isLoop;
                    end
                end
            end
        %重置压力修正迭代计数器
            obj.local_itera = 1;

        end
        



       function advance_itera = pCorrect(obj)
       %PISO：压力修正迭代循环自动控制成员函数
       if abs(obj.local_itera - 1) < 0.0000001
            fprintf(['PISO：当前时间步为%d：\n' ...
                     'PISO：当前压力修正次数为%d,\n'], ...
                     obj.local_t, ...
                     obj.local_itera);
       end
            %循环迭代终止判断
            if abs(obj.local_itera - obj.end_itera) < 0.0000001
                fprintf('PISO：压力修正迭代结束。\n');
                obj.local_itera = 0;
                obj.isLoop = false;
                advance_itera = obj.isLoop;
            else
               fprintf('PISO：当前压力修正次数为%d,\n',obj.local_itera+1);
                obj.local_itera = obj.local_itera + 1;
                obj.iteraSum = obj.iteraSum + 1;
                advance_itera = true;
            end
       end
%%----------------------------残差计算----------------------------%%

%------------时间推进残差
        function RES = timeRes(obj,RES,field,filedEqn,name)
        %SIMPLE:计算物理场时间步推进残差，对iterRes的PISO封装
        % 函数说明见：
        % RES = iteraRes(i,RES,field,filedEqn,name)
            RES = iteraRes(round(obj.local_t/obj.dt),RES,field,filedEqn,name);
        end

        function RES = massTimeRes(obj,RES,mass,iteraSelect)
        %PISO：计算连续性方程误差，对massrRes的PISO封装
        % 函数说明见：
        % RES = massRes(i,RES,mass,iteraSelect)
            if nargin == 3
                iteraSelect = 5;
            end
            RES = massRes(round(obj.local_t/obj.dt),RES,mass,iteraSelect);
        end

%------------迭代推进残差
        function RES = iteraRes(obj,RES,field,filedEqn,name)
        %SIMPLE:计算物理场迭代残差，对iterRes的PISO封装
        % 函数说明见：
        % RES = iteraRes(i,RES,field,filedEqn,name)
            RES = iteraRes(obj.iteraSum,RES,field,filedEqn,name);
        end

        function RES = massRes(obj,RES,mass,iteraSelect)
        %PISO：计算连续性方程误差，对massrRes的PISO封装
        % 函数说明见：
        % RES = massRes(i,RES,mass,iteraSelect)
            if nargin == 3
                iteraSelect = 5;
            end
            RES = massRes(obj.iteraSum,RES,mass,iteraSelect);
        end
    

        function RES = plotRES(obj,RES)
        %PISO：动态显示残差
            figure(1)
            % hold on
            %获取残差中的变量个数
            nameRES = fieldnames(RES);
            numRES = length(nameRES);
            for i = 1:numRES
                plot(1:obj.iteraSum,...
                    log10(RES.(nameRES{i,1})(1:obj.iteraSum,1)), ...
                    'LineWidth',2); 
            end
            legend(nameRES{:,1});

            hold on
            % hold off
        end
   end
end

