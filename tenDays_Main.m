%% 网络拓扑法 电热建模 时间周期0914-0924
% 温度场计算方程 电流场计算方程

%% 模块介质参数
material=[2329 700 124;7370 226 35;8960 390 380;...
    3780 830 15;8960 390 380;7370 226 35;8960 390 380];%5x3 
%芯片 焊层 Cu 陶瓷层 Cu 焊料层 Cu;ρ(kg/m3) c(J/(kg K)） k（W/m K);7层
geometry=[7.24 6.9 0.15;7.24 6.9 0.12;28.5 25.8 0.3;30.65 28 0.38;...
    28.5 25.8 0.3;28.5 25.8 0.12;91.4 31.4 2.8];%xyz每个层的长宽高 以及距离坐标点的距离
%芯片；焊料层；上铜层；陶瓷层；下铜层；焊料层；铜基板；单位mm
geometry=0.001*geometry';
%% 点的位置
xyz0=[0 0.2 4.02;0 0.2 3.9;0 0 3.6;0 0 3.22;0 0 2.92;0 0 2.8;0 0 0];
xyz0=0.001*xyz0;
%每层左下角距离坐标原点距离 xyz 7行7层；以铜基板的左下角设为坐标原点
N=[2 2 2;2 2 2;4 4 4;4 4 4;4 4 4;4 4 4;5 5 5];% 397个点;
%每一行代表一层，分别对xyz划分数目
%每层划分数xyz
dxyz=cell(3,7);%表示点的相对坐标位置
%元胞数据的创建引用 7层，行1元胞是x 行2元胞是y 3元胞是z
%{}是对元胞中某个单元的引用,寻访的是其单元内容
%例如A{1,2}(1,2)第一层{}控制cell单元引用，第二层()控制cell单元中矩阵元素引用
%A(1)=[] 删除一个单元；A(:)=[]一次性删除所有cell单元
for i=1:7
    dxyz{1,i}=linspace(0,geometry(1,i),N(i,1)+1);
    dxyz{2,i}=linspace(0,geometry(2,i),N(i,2)+1);
    dxyz{3,i}=linspace(0,geometry(3,i),N(i,3)+1);
end
Lxyz=cell(3,7);%表示微元的xyz长度 需要刨除掉最开始每层定义的相对原点(0,0,0);
for i=1:7
    Lxyz{1,i}=diff(dxyz{1,i});%z
    Lxyz{2,i}=diff(dxyz{1,i});%y
    Lxyz{3,i}=diff(dxyz{1,i});%z
    dxyz{1,i}(1)=[];%去除掉首行零元素，也就是不重复设置立方体中元素点
    dxyz{2,i}(1)=[];
    dxyz{3,i}(1)=[];
end
Dot=cell(1,7);
%是设定的原点坐标 以铜基板的左下角设为坐标原点

for i=1:7 %x y z遍历组合 固定层数，固定x,y，z变化，先变z,再变y,最后变x
     Nx=length(dxyz{1,i}); %分别表示xyz上面被划分的数目（坐标点数，不包括0）
     Ny=length(dxyz{2,i});
     Nz=length(dxyz{3,i});
    for x=1:Nx
        for y=1:Ny
            for z=1:Nz
                dot=[dxyz{1,i}(x),dxyz{2,i}(y),dxyz{3,i}(z)];
                dot=dot+xyz0(i,:);
                Dot{1,i}=[Dot{1,i};dot];
%                 Dot{1,i}=Dot{1,i}+xyz0(i,:);%D是加了坐标变换的，便于画图
%                 %换到了层的相对位置
            end
        end
    end
end

%%测试代码
dot=[0 0 0];%微元的位置
for i=1:7
    dot=[dot;Dot{1,i}];
end
dot(1,:)=[];

%可以通过三维图直观看自己的点位置、数量是否正确
% color=repmat([1,2,3,4,5,6,7];
%dot(:,3)*10000表示按照dot(:,3)的大小绘制散点大小，10000为了更清楚一些
%是以dot(:,3)*10000的数值作为颜色判断尺标
scatter3(dot(:,1),dot(:,2),dot(:,3),100,dot(:,3),'.');
xlabel('x');
ylabel('y');
zlabel('z');
grid on;
view(45,30);%90度方位角和0度仰角看
%%%%………………

%% 计算热阻 热容
Vxyz=cell(1,7);%每层计算元素体积
%kron 张量积
for i=1:7
Vxyz{1,i}=kron(kron(Lxyz{1,i}, Lxyz{2,i}), Lxyz{3,i});%同上方xyz的遍历方式
end

Cth=cell(1,7);%每个微元的热容
for i=1:7
    Cth{1,i}=material(i,1)*material(i,2)*Vxyz{1,i};
end

% 测试代码 Rth_r=cell(1,7);
Rth=cell(1,7);%每个微元的传热情况 R=L/(k*S)；S是正对传热面积；l是传热距离
% 测试代码 Rth_add=cell(1,7);%每层与层交界处的传热情况，从第二层开始；
for i=1:7 %x y z遍历组合 固定层数，固定x,y，z变化，先变z,再变y,最后变x
   Nx=length(Lxyz{1,i});%分别表示xyz上面被划分的每段线段数目
   Ny=length(Lxyz{2,i});
   Nz=length(Lxyz{3,i});
    for x=1:Nx
        for y=1:Ny
            for z=1:Nz
                dx=Lxyz{1,i}(x);%Lxyz里面每个元素表示xyz线段上点到前一个临近点的相对长度；
                dy=Lxyz{2,i}(y);
                dz=Lxyz{3,i}(z);
                %上面表示的是这个点所在元的特征
                
                zz=(z+1<=Nz);%检测是不是在边缘位置,如果z已经最大了，那么zz为0,否则为1
                yy=(y+1<=Ny);
                xx=(x+1<=Nz);
                dx2=xx*(Lxyz{1,i}(x+xx));%如果不在边缘，xx为1，实际上(x+xx)就是(x+1)
                %如果在边缘，xx为0,Lxyz索引也没有超过
                dy2=yy*(Lxyz{2,i}(y+yy));
                dz2=zz*(Lxyz{3,i}(z+zz));
                
                %1 计算Rth （不考虑层与层之间临界点处的传热）
  
%%测试 原来的想法
%                 Rth_D=1/material(i,3)*[dz/(dx*dy) dy/(dx*dz) dx/(dz*dy) ...
%                     dz2/(dx*dy) dy2/(dx*dz) dx2/(dz*dy)]
%                 Rth{1,i}=[Rth{1,i};Rth_D];
%%%%%……

                %下方、左方、后方、上方、右方、前方的热阻
                %如果是最边缘的元素，也就是xyz最大值，就认为上方、右方、前方绝热
                %注意，如果是第二层以上的层数，z最大值是每两层的接触面，
                %所以受到上方的热传导，需要考虑相对位置，
                %第二层之后，最上表面的点 上方传热情况
                 %确定哪些点,假定用Rth_up作为补充没有考虑到的情况
               
                 %2  计算Rth_up 层与层之间传热效果              
                if (i==1)||(z<Nz)
                     Rth_up=0;%默认是0 假设是步骤1中的情况
                else
                    %2.1 计算实际传热面的面积
%%测试代码
%                     Dx=Dot{1,i}(x*y*z,1);%就是对应点的坐标xyz
%                     Dy=Dot{1,i}(x*y*z,2);
%                     %确定上一层的临界坐标点 左下角位置以及上一层长宽
%                     minx0=xyz0(i-1,1);
%                     miny0=xyz0(i-1,2);
%                     dx0=geometry(1,i-1);
%                     dy0=geometry(2,i-1);
%%%%%%
                   S=cal_S(Dot{1,i}(x*y*z,1),Dot{1,i}(x*y*z,1),dx,dy,...
                       xyz0(i-1,1),xyz0(i-1,2),geometry(1,i-1),geometry(2,i-1));
             
                   %2.2 计算Rth-up
                    if S==0
                        Rth_up=0;
                    else
                    dz0=Lxyz{3,i}(1);%每层给z划分,假定的是左下角为划分起始点
                    %所以最靠近下面一层介质的是第一个z；
                    Rth_up=1/material(i-1,3)*dz0/S;
                    %dz0是上一层节点到该节点的距离 xs ys是对应上层的实际传热面积
                    end
                end  
                %3 综合叠加计算最终热阻
%%测试代码
%                 Rth_add{1,i}=[Rth_add{1,i};0 0 0 ...
%                      Rth_up 0 0];
%%%%%……                
                  Rth_D=1/material(i,3)*[dz/(dx*dy) dy/(dx*dz) dx/(dz*dy) ...
                    dz2/(dx*dy) dy2/(dx*dz) dx2/(dz*dy)];
                Rth_D=Rth_D+[0 0 0 Rth_up 0 0];
                Rth{1,i}=[Rth{1,i};Rth_D];
                %下方、左方、后方、上方、右方、前方的热阻
                
            end
        end
    end
%   测试代码  Rth_r{1,i}=Rth{1,i}+ Rth_add{1,i};
end

%% 迭代计算温度
%%% 矩阵设置 x'=A*x+B*u;y=C*x+D*u; A是nn矩阵，
%组合热阻及热容
RC=zeros(sum(N(:,1).*N(:,2).*N(:,3)),7);%前6列是热阻7是热容

n0=0;
for i=1:7
    n=n0+N(i,1)*N(i,2)*N(i,3);%最后nx是长度
    RC(n0+1:n,1:6)=Rth{1,i};
    RC(n0+1:n,7)=Cth{1,i};
    n0=n; 
end