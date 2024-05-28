function surface = outputField(mesh,select,color,field)
%将计算结果输出surface
%简介：
%输入参数
%   mesh - 网格数据结构体
%   field - 输出的物理场
%   select - 输出图像方式选择：
%          - 包含图像光滑处理(smooth)和不光滑处理(unsmooth)
%返回参数
%   surface - 计算结果数据体
%          包含变量：
%               - surface.fields(与网格维度相对应的计算结果)
  
[X,Y] = meshgrid(mesh.cells.cx,mesh.cells.cy);
if contains(field.type,'Scalar')
   surface = draw_scalar(select,field,color);
elseif contains(field.type,'Vector')
   surface = draw_vector(select,field,color);
else
   error('outputFields():field.type错误');
end


function surface = draw_scalar(select,field,color)
    figure
    surface.fields.x = coltoFiled(field.fields.x);
    hold on
    if select == 1
        surf(X,Y,surface.fields.x);
        if color == 1
            colormap(othercolor('RdBu11'));
        elseif color == 2
            colormap(othercolor('RdYIBu10'));
        elseif color == 3
            colormap(othercolor('BuDRd_18'));
        elseif color == 4
            colormap('jet');
        else
            error('outputField():color设置错误')
        end
        view(2);
        colorbar();
        shading interp;
    elseif select == 2
        surf(X,Y,surface.fields.x);
        if color == 1
            colormap(othercolor('RdBu11'));
        elseif color == 2
            colormap(othercolor('RdYIBu10'));
        elseif color == 3
            colormap(othercolor('BuDRd_18'));
        elseif color == 4
            colormap('jet');
        else
            error('outputField():color设置错误')
        end
        view(2);
        colorbar();
    else
        error('outputField()：outputSelect类型选择错误');
    end
end

function surface = draw_vector(select,field,color)
    surface.fields.x = coltoFiled(field.fields.x);
    surface.fields.y = coltoFiled(field.fields.y);
    if select == 1
        figure
        surf(X,Y,surface.fields.x);
        if color == 1
            colormap(othercolor('RdBu11'));
        elseif color == 2
            colormap(othercolor('RdYIBu10'));
        elseif color == 3
            colormap(othercolor('BuDRd_18'));
        elseif color == 4
            colormap('jet');
        else
            error('outputField():color设置错误')
        end
        shading interp;
        view(2);
        colorbar();

        figure
        surf(X,Y,surface.fields.y);
        if color == 1
            colormap(othercolor('RdBu11'));
        elseif color == 2
            colormap(othercolor('RdYIBu10'));
        elseif color == 3
            colormap(othercolor('BuDRd_18'));
        elseif color == 4
            colormap('jet');
        else
            error('outputField():color设置错误')
        end
        shading interp;
        view(2);
        colorbar();
    elseif select == 2
        figure
        surf(X,Y,surface.fields.x);
        if color == 1
            colormap(othercolor('RdBu11'));
        elseif color == 2
            colormap(othercolor('RdYIBu10'));
        elseif color == 3
            colormap(othercolor('BuDRd_18'));
        elseif color == 4
            colormap('jet');
        else
            error('outputField():color设置错误')
        end
        view(2);
        colorbar();

        figure
        surf(X,Y,surface.fields.y);
        if color == 1
            colormap(othercolor('RdBu11'));
        elseif color == 2
            colormap(othercolor('RdYIBu10'));
        elseif color == 3
            colormap(othercolor('BuDRd_18'));
        elseif color == 4
            colormap('jet');
        else
            error('outputField():color设置错误')
        end
        view(2);
        colorbar();
    else
        error('outputField()：outputSelect类型选择错误');
    end
end

end

