function [n] = link1(i,j,Nx)
%连接表计算，当前连接表起始网格编号为1
 n = i + (j - 1) * Nx;
end
