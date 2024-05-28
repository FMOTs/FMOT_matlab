classdef time < handle
    %TIME 非稳态时间项相关管理类

    properties
        dt;
        end_t;
        begin_t = 0;
        local_dt = 0;
        isLoop = logical(false);
    end
    
    methods
        function obj = time(dt, iter_t)
            %TIME构造函数
            %   根据时间步长(dt)和总步数(iter_t)自动计算时间相关参数
            obj.dt = dt;
            obj.isLoop = true;
            obj.end_t = obj.begin_t + iter_t*dt;
        end
    end
    methods(Static)
        function advance_t = loop(obj)
            %时间步递进自动控制成员函数
            if obj.local_dt == 0
                fprintf('时间循环开始：\n');
            end

            if abs(obj.local_dt - obj.end_t) < 0.0000001
                fprintf('时间循环结束。\n');
                obj.isLoop = false;
                advance_t = obj.isLoop;
            else
               fprintf('当前时间为%d,',obj.local_dt);
               obj.local_dt = obj.local_dt+obj.dt;
               advance_t = true;
            end
        end

    end
end

