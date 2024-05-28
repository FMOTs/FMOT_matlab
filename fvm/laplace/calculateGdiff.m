function gdiff = calculateGdiff(mesh)
%结构网格(cavity)数据类型的面gdiff计算
    gdiff.x = mesh.faces.areas.x;
    gdiff.y = mesh.faces.areas.y;
    %网格体心距离
    cdx = mesh.cells.cx(2:1:end) - mesh.cells.cx(1:1:end-1);
    cdy = mesh.cells.cy(2:1:end) - mesh.cells.cy(1:1:end-1);
    %先处理内部面
    %A./行保证每一列对应相除
    gdiff.x(:,2:end - 1) = gdiff.x(:,2:end - 1)./cdx;
    %A.*/列保证每一行对应相除
    gdiff.y(2:end - 1,:) = gdiff.y(2:end - 1,:)./cdy';
    %再处理边界面
    endx = mesh.points.x(end);
    endy = mesh.points.y(end);    
    bcdx_b = (mesh.cells.cx(1) - 0);
    bcdx_e = (endx - mesh.cells.cx(end));
    bcdy_b = (mesh.cells.cy(1) - 0);
    bcdy_e = (endy - mesh.cells.cy(end));
    gdiff.x (:,1) = gdiff.x(:,1) ./ bcdx_b;
    gdiff.x(:,end) = gdiff.x(:,end) ./ bcdx_e;
    gdiff.y(1,:) = gdiff.y(1,:) ./ bcdy_b;
    gdiff.y(end,:) = gdiff.y(end,:) ./ bcdy_e;
end
