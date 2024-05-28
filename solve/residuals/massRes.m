function RES = massRes(i,RES,mass,iteraSelect)
%计算连续性方程误差
%   此处显示详细说明
    

    if nargin == 3
        iteraSelect = 5;
    end

    if ~isfield(RES,'mass')
        disp('警告：RES未初始化mass残差,massRes()进行了补充初始化,请在initialRes中初始化空间');
        RES.mass = zeros(iteraSelect,1);
    end
    %计算连续性方程的2范数
    rContinuity = norm(mass.b,2);
    %归一化连续性方程误差
    if i == 1
        nContinuity = rContinuity;
    end

    if i < iteraSelect + 1 
        if i > 1
           nContinuity = RES.mass(i-1,2);
        end
        nContinuity = max(nContinuity, rContinuity);
    end

   if i > iteraSelect
       nContinuity = RES.mass(iteraSelect,2);
   end

    %计算残差赋值
    RES.mass(i,1) = rContinuity / nContinuity;
    RES.mass(i,2) = nContinuity;
end

