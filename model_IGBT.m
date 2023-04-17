%% ����IGBTģ��
baseplate=[60;26;5;200];%����ߵ�λmm �ȵ���W/(m K)
solder_base=[54;22;0.2;54];
CuNi1=[54;22;0.25;398];
substrate=[56;24;1;180];
CuNi2=[50;20;0.3;398];
solder_chip=[12;12;0.2;54];
chip=[12;12;0.3;118];

%ȷ��xyz������Χ
xmax=baseplate(1);
ymax=baseplate(2);
zmax=baseplate(3)+solder_base(3)+CuNi1(3)+substrate(3)+CuNi2(3)+solder_chip(3)+chip(3);

%% Ԥ����
f=0.1;%����Ƶ����0.1Hz�� w=2pi*f T=1/f T����10s
time=0:0.1:10;
P1=sin(2*pi*f*time);
PIGBT=P1.*(P1>=0);
P2=sin(2*pi*f*time-pi);
PDiode=P2.*(P2>=0);
% �����ܺ�IGBT��İ����ң��������pi����λ
% plot(time,PIGBT);
% hold on 
% plot(time,PDiode);

%% ���񻮷�
%cube ѡȡ�� ����㣺xyz �Լ�����������ȵ��� ���û�о�������Ϊ0
Zchip=zmax-1/2*chip(3);
cube_chip=[10 10 Zchip;10 12+10+3 Zchip;10 12+10+3+12+3 Zchip];%NTC IGBT Diode
Z=Zchip-1/2*solder_chip(3);
cube_solder_chip=[10 10 Z;10 12+10+3 Z;10 12+10+3+12+3 Z];%оƬ���ϲ�
Z=Z-1/2*CuNi2(3);
cube_sCuNi2=[10 10 Z;10 12+10+3 Z;10 12+10+3+12+3 Z];%оƬ��Ӧ��CuNi��ڵ�

x=[cube_chip(:,1);cube_solder_chip(:,1);cube_sCuNi2(:,1)];
y=[cube_chip(:,2);cube_solder_chip(:,2);cube_sCuNi2(:,2)];
z=[cube_chip(:,3);cube_solder_chip(:,3);cube_sCuNi2(:,3)];
scatter3(x,y,z);