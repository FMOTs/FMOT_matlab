function C2 = outputC2(field,FaceSelect,varargin)
%根据物理场(类型和方向)和边界(类型)，自动输出C2的值
%简介：
%函数重载:
%   C2 = outputC2(field,FaceSelect)
%   C2 = outputC2(field,FaceSelect,direction)
%输入参数
%   field - 物理场
%   FaceSelect - 物理场边界("W","E","S","N)。
%   direction - 当前计算的物理场中物理量的方向(x,y,z)，
%               仅当field.type为Vector时才需要选择。
%               例: outputC2(field,'E','x')
% 
if nargin == 2
    if strcmpi(field.type,'volVectorField')
        error('outputC2()未选择volVectorField的方向，请输入变量direction');
    end
%输出C2 
   if strcmp(FaceSelect,'W')
       C2 = field.LBC.W.c2.x;
   end 

   if strcmp(FaceSelect,'E')
       C2 = field.LBC.E.c2.x;
   end 

   if strcmp(FaceSelect,'S')
       C2 = field.LBC.S.c2.x;   
   end  

   if strcmp(FaceSelect,'N')
       C2 = field.LBC.N.c2.x; 
   end     
end


if nargin > 2 
    if isnumeric(varargin{1})
        error('outputC2()方向参数输入错误')
    end
    if~ strcmpi(field.type,'volVectorField')
        error('outputC2()物理场输入错误，应输入volVectorField');
    end

    direction = varargin{1};

    if direction == 'x'
        if strcmp(FaceSelect,'W')
            C2 = field.LBC.W.c2.x;
        end 

        if strcmp(FaceSelect,'E')
            C2 = field.LBC.E.c2.x;
        end 

        if strcmp(FaceSelect,'S')
            C2 = field.LBC.S.c2.x;   
        end  

        if strcmp(FaceSelect,'N')
            C2 = field.LBC.N.c2.x; 
        end      
    elseif direction == 'y'
        if strcmp(FaceSelect,'W')
            C2 = field.LBC.W.c2.y;
        end 

        if strcmp(FaceSelect,'E')
            C2 = field.LBC.E.c2.y;
        end 

        if strcmp(FaceSelect,'S')
            C2 = field.LBC.S.c2.y;   
        end  

        if strcmp(FaceSelect,'N')
            C2 = field.LBC.N.c2.y; 
        end   
    elseif direction == 'z'
         if strcmp(FaceSelect,'W')
            C2 = field.LBC.W.c2.z;
        end 

        if strcmp(FaceSelect,'E')
            C2 = field.LBC.E.c2.z;
        end 

        if strcmp(FaceSelect,'S')
            C2 = field.LBC.S.c2.z;   
        end  

        if strcmp(FaceSelect,'N')
            C2 = field.LBC.N.c2.z; 
        end   
    else
        error('outputC2()方向参数超过物理场维度');
    end

end

end

