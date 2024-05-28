function surface = outputField(mesh,select,color,field)
%�����������surface
%��飺
%�������
%   mesh - �������ݽṹ��
%   field - ���������
%   select - ���ͼ��ʽѡ��
%          - ����ͼ��⻬����(smooth)�Ͳ��⻬����(unsmooth)
%���ز���
%   surface - ������������
%          ����������
%               - surface.fields(������ά�����Ӧ�ļ�����)
  
[X,Y] = meshgrid(mesh.cells.cx,mesh.cells.cy);
if contains(field.type,'Scalar')
   surface = draw_scalar(select,field,color);
elseif contains(field.type,'Vector')
   surface = draw_vector(select,field,color);
else
   error('outputFields():field.type����');
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
            error('outputField():color���ô���')
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
            error('outputField():color���ô���')
        end
        view(2);
        colorbar();
    else
        error('outputField()��outputSelect����ѡ�����');
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
            error('outputField():color���ô���')
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
            error('outputField():color���ô���')
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
            error('outputField():color���ô���')
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
            error('outputField():color���ô���')
        end
        view(2);
        colorbar();
    else
        error('outputField()��outputSelect����ѡ�����');
    end
end

end

