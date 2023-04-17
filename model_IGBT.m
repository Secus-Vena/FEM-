%% 定义IGBT模块
baseplate=[60;26;5;200];%长宽高单位mm 热导率W/(m K)
solder_base=[54;22;0.2;54];
CuNi1=[54;22;0.25;398];
substrate=[56;24;1;180];
CuNi2=[50;20;0.3;398];
solder_chip=[12;12;0.2;54];
chip=[12;12;0.3;118];

%确定xyz整个范围
xmax=baseplate(1);
ymax=baseplate(2);
zmax=baseplate(3)+solder_base(3)+CuNi1(3)+substrate(3)+CuNi2(3)+solder_chip(3)+chip(3);

%% 预定义
f=0.1;%假设频率是0.1Hz的 w=2pi*f T=1/f T就是10s
time=0:0.1:10;
P1=sin(2*pi*f*time);
PIGBT=P1.*(P1>=0);
P2=sin(2*pi*f*time-pi);
PDiode=P2.*(P2>=0);
% 二极管和IGBT损耗半正弦，并且相隔pi个相位
% plot(time,PIGBT);
% hold on 
% plot(time,PDiode);

%% 网格划分
%cube 选取点 坐标点：xyz 以及六个方向的热导率 如果没有就设置是为0
Zchip=zmax-1/2*chip(3);
cube_chip=[10 10 Zchip;10 12+10+3 Zchip;10 12+10+3+12+3 Zchip];%NTC IGBT Diode
Z=Zchip-1/2*solder_chip(3);
cube_solder_chip=[10 10 Z;10 12+10+3 Z;10 12+10+3+12+3 Z];%芯片焊料层
Z=Z-1/2*CuNi2(3);
cube_sCuNi2=[10 10 Z;10 12+10+3 Z;10 12+10+3+12+3 Z];%芯片对应的CuNi层节点

x=[cube_chip(:,1);cube_solder_chip(:,1);cube_sCuNi2(:,1)];
y=[cube_chip(:,2);cube_solder_chip(:,2);cube_sCuNi2(:,2)];
z=[cube_chip(:,3);cube_solder_chip(:,3);cube_sCuNi2(:,3)];
scatter3(x,y,z);