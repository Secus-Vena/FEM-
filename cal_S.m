%% ����������������ص����
function S=cal_S(Dx,Dy,dx,dy,x0,y0,dx0,dy0)
%Dx Dy�Ǿ������Ͻ�λ�ã�dx dy�Ǿ��ζ�Ӧ����
%x0��y0,dx0,dy0����һ���������½Ƕ�Ӧ�����꼰����

maxx0=x0+dx0;
maxy0=y0+dy0;

minx=Dx-dx;
start_x=min(minx,x0);
end_x=max(Dx,maxx0);
lx=dx+dx0-(end_x-start_x);

miny=Dy-dy;
start_y=min(miny,y0);
end_y=max(Dy,maxy0);
ly=dy+dy0-(end_y-start_y);

if (lx<0)||(ly<0)
    S=0;
else
    S=lx*ly;
end
end
    