function   plotmap( model )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global zcubic;
global wi;
global di;
global Scene;
    Scene=figure(1);
    scale=[model.Xmin,model.Xmax,model.Ymin,model.Ymax,0,model.Zmax];
    axis(scale);
    hold on;
    %������
width=0:1000:model.Xmax;%x
depth=0:1000:model.Ymax;%y
height=abs(peaks(7)*80)+300;
    wi=0:100:6000;
    di=0:100:6000;
    di=di';
    %��ֵ���  ����
    zcubic=interp2(width,depth,height,wi,di,'cubic');
    %��ά������ʾ
    surfc(wi,di,zcubic);
    shading flat;
    xlabel('Width')  
    ylabel('Depth')  
    zlabel('Heitht')  
    %alpha(0.6);
    %����㡢�յ�
    plot3(model.sx,model.sy,model.sz,'*');
    plot3(model.ex,model.ey,model.ez,'*');
    % ���״�
for k=1:numel(model.xobs)   
    [x,y,z]=sphere(16);
    z(z<0)=nan;
    r=model.robs(k);
    x0=model.xobs(k);    y0=model.yobs(k);    z0=model.zobs(k);
    X=x*r+x0;    Y=y*r+y0;    Z=z*r+z0; 
    surf(X,Y,Z,'EdgeColor','b','FaceColor','none');
    hold on;
end
%������
    [x,y,z]=sphere(30);  
    r=2;
    x0=model.ex;    y0=model.ey;    z0=model.ez;
    X=x*r+x0;    Y=y*r+y0;    Z=z*r+z0; 
    surf(X,Y,Z,'EdgeColor','none','FaceColor',[0.929,0.694,0.125]);
    hold on;

%������
for k=1:numel(model.weapon_x)
    [x,y,z]=sphere(12);
    z(z<0)=nan;
    r=model.weapon_r(k);
    x0=model.weapon_x(k);    y0=model.weapon_y(k);   z0=model.weapon_z(k);
    X=x*r+x0;    Y=y*r+y0;    Z=z*r+z0; 
    surf(X,Y,Z,'EdgeColor','r','FaceColor','none');  
    hold on;
end

end

