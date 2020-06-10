function [ cost,sol ] = FitnessFunction( chromosome,model )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    x= zeros(1,model.dim);
    y= zeros(1,model.dim);
    z = zeros(1,model.dim);
    %ȡ��uav����·������
    for i=1:model.dim
    x(i) = chromosome.pos(i,1);
    y(i) = chromosome.pos(i,2);
    z(i) = chromosome.pos(i,3);
    end
    sx = model.startp(1);
    sy = model.startp(2);
    sz = model.startp(3);
    ex = model.endp(1);
    ey =model.endp(2);
    ez=model.endp(3);
        
    
    xobs = model.xobs;
    yobs = model.yobs;
    zobs = model.zobs;
    robs = model.robs;
    
    XS=[sx x ex];
    YS=[sy y ey];
    ZS=[sz z ez];
    k =numel(XS);
    TP =linspace(0,1,k);
    tt =linspace(0,1,50);
    xx =[];
    yy =[];
    zz=[];
    for i=1:k-1
    %ÿһ�������ֳ�10����
    x_r = linspace(XS(i),XS(i+1),10);
    y_r= linspace(YS(i),YS(i+1),10);
    z_r =linspace(ZS(i),ZS(i+1),10);
    xx = [xx,x_r];
    yy = [yy,y_r];
    zz =[zz ,z_r];
    end
    
    %calc L
    dx =diff(xx);
    dy =diff(yy);
    dz = diff(zz);
    Length = sum(sqrt(dx.^2+dy.^2+dz.^2));
    nobs = numel(xobs);
     violation=0;
    for i=1:nobs
       d = sqrt( (xx-xobs(i)).^2+(yy-yobs(i)).^2 );
       v = max(1-d/robs(i),0);
       violation = violation + mean(v);
    end
    sol.TP=TP;
    sol.XS =XS;
    sol.YS=YS;
    sol.ZS=ZS;
    sol.tt=tt;
    sol.xx=xx;
    sol.yy=yy;
    sol.zz=zz;
    sol.dx=dx;
    sol.dy=dy;
    sol.dz=dz;
    sol.Length=Length;
    sol.violation=violation;
    sol.IsFeasible=(violation==0);
    
    %����Э����Ӧֵ
    % 3�����и߶�����
     high=0;
     for k=1:numel(XS)
        x=XS(k);
        y=YS(k);
        h=terrain(x,y);        
        if ZS(k)<=(h+10)  %���Ʒ�����͸߶�
            high=high+1000;          
        elseif ZS(k)>(h+620)   %���Ʒ�����߸߶�              
            high=high+1000;           
        else  
            high=high+abs(ZS(k)-600); %����������߶Ȳ���      
        end        
    end
    
    %z
  
    %w4 =20;
    %����������
     w1 =0.1;
     w2=0.3;
     w3=0.1;
     w4=0.1;
     %markov evaluatea
     %��ȡ����ά�ȵ�����
     r_xx=[];r_yy=[];r_zz=[];
    for i=1:numel(XS)-1
    %ÿһ�������ֳ�10����
    r_x = linspace(XS(i),XS(i+1),8);
    r_y= linspace(YS(i),YS(i+1),8);
    r_z =linspace(ZS(i),ZS(i+1),8);
    r_xx = [r_xx,r_x];
    r_yy = [r_yy,r_y];
    r_zz =[r_zz ,r_z];
    end
     
    Allpos = [r_xx',r_yy',r_zz'];
   [stateProbabilityProcess, expectedCostProcess]=MarkovEvaluate(Allpos,model);
   sol.MarkovState = stateProbabilityProcess;
   sol.MarkovCost = expectedCostProcess;
    sol.costs=[w1*sol.Length,w3*high,w4*150*mean(expectedCostProcess)];
    cost= w1*sol.Length+w3*high+w4*150*mean(expectedCostProcess);
    

   
end

