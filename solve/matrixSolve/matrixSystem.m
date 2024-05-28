function [solve,field] = matrixSystem(field,operator,sign,varargin)
%��װ������������������
%ע�⣡����b���ɳ���Ϊû�ж��������������ֱ���ɳ��ˣ�����Ҫ��������
%��飺
%�������أ�
%   solve = matrixSystem(operator)
%   solve = matrixSystem(operator,isSolve)
%   solve = matrixSystem(operator,isSolve,alpha)
%���������
%   field - ��������
%   operator - ������������ɢ��������
%              ����[ddt_F,div_F,lap_F]
%   sign - ������������ɢ���ӷ�������
%              ����['+','+','-']
%   isSolve - �����Ƿ�Ծ���ϵͳ�������
%             Ĭ��ֵ = 0(�����) 
%   alpha - �����ɳ�����
%             Ĭ��ֵ = 1
%--------------------------------------------------------------------------
%   operator��sign������һһ��Ӧ�ģ�sign�����Ӧ��ɢ�����ڹ�ʽ�еļӼ�
%           [ddt_F,div_F,lap_F],['+','+','-']
%           = ddt_F + div_F - lap_F
%--------------------------------------------------------------------------
%���ز�����
%   solve - ����ϵͳ
%           ����������
%               - solve.A(����)��fieldΪscalarʱΪsolve.A��
%                               vectorʱ����A.x��A.y��A.z����
%               - solve.b(Դ��)��fieldΪscalarʱΪsolve.b��
%                                vectorʱ����b.x��b.y��b.z����
%               - solve.type(����ϵͳ����)
%   solve - ��������1����A��b
%   solve - ��������2����A��b��field
%   solve - ��������3�����ɳں��A��b��field
%   field - �����������matlab�﷨����


global Nx Ny;
warning('off');
%��ʼ��
doSolve = 0;
alpha = 1;

if nargin == 4 && isnumeric(varargin{1})
    doSolve = varargin{1};
end

if nargin == 5 && isnumeric(varargin{2})
    doSolve = varargin{1};
    alpha = varargin{2};
end

%�ж���������(����ϵͳֻ�ܴ����峡)
if strcmpi(field.type,'volScalarField')
    solve = generateScalarM(operator,sign);
    solve.type = 'scalarMatrix';
    if doSolve
       %�����ʱ�䲽����
       solve.oldFields = field.fields.x;
       %�������
       % ֱ�ӷ�
       field.fields.x = solve.A\solve.b;
       %˫�ȶ������ݶ�
       % field.fields.x = bicgstab(solve.A,solve.b);
    end
elseif strcmpi(field.type,'volVectorField')
    solve = generateVectorM(operator,sign);
    solve.type = 'vectorMatrix';
    if doSolve
       %�����ʱ�䲽����
       solve.oldFields.x = field.fields.x;
       solve.oldFields.y = field.fields.y;
       solve.oldFields.z = field.fields.z;
       %�������
       % field.fields.x = solve.A.x\solve.b.x;
       % field.fields.y = solve.A.x\solve.b.y;
       % field.fields.z = solve.A.x\solve.b.z;
       %˫�ȶ������ݶ�
       field.fields.x = bicgstab(solve.A.x,solve.b.x);
       field.fields.y = bicgstab(solve.A.y,solve.b.y);
       % field.fields.z = bicgstab(solve.A,solve.b);
    end
else
    error('������װʧ�ܣ������������ʹ���')
end


function solve = generateScalarM(operator,sign)
%��װ������(Scalar)�ľ���ϵͳ:A,b
    %��ʼ���ڴ�
    dim = Nx*Ny;
    solve.A = sparse(dim,dim);
    solve.b = sparse(dim,1);
    %��װ����
    for i = 1:numel(operator)
        if sign(i) == '+'
            solve.A = solve.A + operator(i).A;
            solve.b = solve.b + operator(i).b;
        elseif sign(i) == '-'
            solve.A = solve.A - operator(i).A;
            solve.b = solve.b - operator(i).b;
        else
            error('matrixSystem()�������sign����');
        end
    end
    %ʩ���ɳ�
    if alpha ~= 1
        %��ȡ��Ԫ
        diagA_x = diag(solve.A.x);
        p = sparse(Nx*Ny,Nx*Ny,pi);
        I = eye(Nx*Ny,'like',p);
        solve.A.x(I == 1) = solve.A.x(I == 1)./alpha;
        solve.b = solve.b + ((1-alpha)/alpha) .*diagA_x .* field.fields.x;
    end
end

function solve = generateVectorM(operator,sign)
%��װ������(Vector)�ľ���ϵͳA.x,A.y,A.z,b.x,b.y.b.z
    %��ʼ���ڴ�
    dim = Nx*Ny;
    solve.A.x = sparse(dim,dim);
    solve.A.y = sparse(dim,dim);
    solve.A.z = sparse(dim,dim);
    solve.b.x = sparse(dim,1);
    solve.b.y = sparse(dim,1);
    solve.b.z = sparse(dim,1);
    %��װ����
    for i = 1:numel(operator)
        if sign(i) == '+'
            solve.A.x = solve.A.x + operator(i).A.x;
            solve.A.y = solve.A.y + operator(i).A.y;
            % solve.A.z = solve.A.z + operator(i).A.z;
            solve.b.x = solve.b.x + operator(i).b.x;
            solve.b.y = solve.b.y + operator(i).b.y;
            % solve.b.z = solve.b.z + operator(i).b.z;
        elseif sign(i) == '-'
            solve.A.x = solve.A.x - operator(i).A.x;
            solve.A.y = solve.A.y - operator(i).A.y;
            % solve.A.z = solve.A.z - operator(i).A.z;
            solve.b.x = solve.b.x - operator(i).b.x;
            solve.b.y = solve.b.y - operator(i).b.y;
            % solve.b.z = solve.b.z - operator(i).b.z;
        else
            error('matrixSystem()�������sign����');
        end
    end

    %ʩ���ɳ�
    if alpha ~= 1
        %��ȡ��Ԫ
        diagA_x = diag(solve.A.x);
        diagA_y = diag(solve.A.y);
        %ʩ���ɳ�
        p = sparse(Nx*Ny,Nx*Ny,pi);
        I = eye(Nx*Ny,'like',p);
        solve.A.x(I == 1) = solve.A.x(I == 1)./alpha;
        solve.A.y(I == 1) = solve.A.y(I == 1)./alpha;
        solve.b.x = solve.b.x + ((1-alpha)/alpha) .*diagA_x .*field.fields.x;
        solve.b.y = solve.b.y + ((1-alpha)/alpha) .*diagA_y .*field.fields.y;
    end

end
end

