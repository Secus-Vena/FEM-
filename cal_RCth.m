%% 网络拓扑法 热阻热容计算子函数
% 温度场计算方程 电流场计算方程
%重新设置点的坐标
%% 模块介质参数
%按照空间位置排序 z 从低到高
material=[8960 390 380;7370 226 35;8960 390 380;...
    3780 830 15;8960 390 380;7370 226 35;2329 700 124];%7x3 
%Cu 焊料层 Cu 陶瓷层 Cu 焊层 芯片  ;ρ(kg/m3) c(J/(kg K)） k（W/m K);7层
geometry=[91.4 31.4 2.8;28.5 25.8 0.12;28.5 25.8 0.3;...
   30.65 28 0.38; 28.5 25.8 0.3;7.24 6.9 0.12;7.24 6.9 0.15];%xyz每个层的长宽高 以及距离坐标点的距离
%铜基板；焊料层；下铜层；陶瓷层；上铜层；焊料层；芯片；单位mm
geometry=0.001*geometry;

%% 点的位置
xyz0=[0 0 0;0 0 2.8;0 0 2.92;0 0 3.22;0 0 3.6;0 0 3.9;0 0 4.02];
xyz0=0.01*xyz0;
%每层左下角距离坐标原点距离 xyz 7行7层；以铜基板的左下角设为坐标原点
N=[2 2 2;2 2 2;4 4 4;4 4 4;4 4 4;4 4 4;5 5 5];% 397个点;
%每一行代表一层，分别对xyz划分数目
%每层划分数xyz
dx=zeros(sum(N(:,1))+7,1);%表示点的相对坐标位置
dy=zeros(sum(N(:,2))+7,1);
dz=zeros(sum(N(:,3))+7,1);
nx0=1;
ny0=1;
nz0=1;

for i=1:7
    nx=nx0+N(i,1);
    ny=ny0+N(i,2);
    nz=nz0+N(i,3);%最后nx是dx的长度
    dx(nx0:nx)=linspace(0,geometry(i,1),N(i,1)+1);
    dy(ny0:ny)=linspace(0,geometry(i,2),N(i,2)+1);
    dz(nz0:nz)=linspace(0,geometry(i,3),N(i,3)+1);
    nx0=nx+1;
    ny0=ny+1;
    nz0=nz+1;
end
%x 分别是后一个数减去前面一个数所得，少一个首数
%%重新设置了xyz的首项 的是0
Lx=zeros(nx,1);%nx 是正常的数据划分量
Lx(2:nx,1)=diff(dx);
Ly=zeros(ny,1);
Ly(2:ny,1)=diff(dy);
Lz=zeros(nz,1);
Lz(2:nz,1)=diff(dz);
%z 去除掉中间界面相连处同一个xy平面的数 就去除z为负数的数
nn=1+N;
SN=sum(nn(:,1).*nn(:,2).*nn(:,3));%行x列 x列
Dot=zeros(SN,9);%xyz分别3列 ρc k 相对长度
%是设定的原点坐标 以铜基板的左下角设为坐标原点
nx0=1;
ny0=1;
nz0=1;
k=1;
for i=1:7
    nx=nx0+N(i,1);
    ny=ny0+N(i,2);
    nz=nz0+N(i,3);%最后nx是dx的长度;nx0 到nx是每层的长度
    
    for x=nx0:nx
        for y=ny0:ny
            for z=nz0:nz
                Dot(k,1:3)=[dx(x),dy(y),dz(z)]+xyz0(i,:);%点的坐标
                Dot(k,4:6)=material(i,:);%确认材料
                Dot(k,7:9)=[Lx(x),Ly(y),Lz(z)];%每个点的微元长宽高
                k=k+1;
            end
        end
    end   
    nx0=nx+1;
    ny0=ny+1;
    nz0=nz+1;
end

%%测试代码
% dot=[0 0 0];%微元的位置
% for i=1:7
%     dot=[dot;Dot{1,i}];
% end
% dot(1,:)=[];

%可以通过三维图直观看自己的点位置、数量是否正确
% color=repmat([1,2,3,4,5,6,7];
%dot(:,3)*10000表示按照dot(:,3)的大小绘制散点大小，10000为了更清楚一些
%是以dot(:,3)*10000的数值作为颜色判断尺标
% scatter3(dot(:,1),dot(:,2),dot(:,3),100,dot(:,3),'.');
% xlabel('x');
% ylabel('y');
% zlabel('z');
% grid on;
% view(90,0);%90度方位角和0度仰角看
%%%%………………


