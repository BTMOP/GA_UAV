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
            high=high+10000;          
        elseif ZS(k)>375   %���Ʒ�����߸߶�              
            high=high+10000;           
        else  
            high=high+abs(ZS(k)-287); %����������߶Ȳ���      
        end        
    end
    
    %z
   
    %��һ������,��������Ϊ10e3
%     MaxDistance = norm([sx(1)-ex,sy(1)-ey,ez(1)-ez(1)]);
%     %�����ʱ��
%     MaxTime = MaxDistance/model.vrange(1);
%     %��ʼ��ÿ�����˻��Ĵ���ֵ
%     uav_cost =zeros(1,model.UAV);
    %w4 =20;
    %����������
    w1 =0.2;
     w2=0.3;
     w3=0.1;
    cost= w1*sol.Length +w2*sol.Length*sol.violation+w3*high;
    
%     for uav=1:model.UAV
% %     uav_cost(uav) = w1*sol(uav).Length +w2*sol(uav).Length*sol(uav).violation...
% %     +w3*abs( sol(uav).Length/model.vel -chromosome.ETA  );
%     uav_cost(uav) =uav_cost(uav)+ w1*sol(uav).Length/MaxDistance ;
%     end
%     %����ʱ��Эͬ����
%    
%     for uav=1:model.UAV
%        uav_cost(uav)= uav_cost(uav) +w2*abs( sol(uav).Length/model.vel -chromosome.ETA )/MaxTime;
%     end
%     
%     %�����������˻���Э��ʱ���ڵ�λ������
%     [chromosome.AllPos]=SecurityDist( chromosome,sol,model );
%     
%     AllPos = chromosome.AllPos;
%     %����λ���������������˻�֮��ľ���
%     %����һ��4dim�ľ�������,������������ʱ������2ά,���˻�i,���˻�j,��ʾĳһʱ�����˻���ľ���
%     %dist_vector = zeros(model.intervel,2,model.UAV-1,model.UAV);
%     dist_vector = zeros(model.intervel+1,3,model.UAV-1,model.UAV);
%     
%     for uav1=1:model.UAV
%         for uav2=1:model.UAV
%             if uav2~=uav1
%             dist_vector(:,:,uav2,uav1) = chromosome.AllPos(:,:,uav1) - chromosome.AllPos(:,:,uav2);
%             end
%         end
%     end
%     %����һ��2ά������,��ʾ��i��ʱ���Ƿ���������˻��ľ�����ڰ�ȫ����
%     security_vector =zeros(model.intervel,model.UAV);
%     for i=1:model.intervel
%        for uav1=1:model.UAV
%           for uav2 =1:model.UAV
%              if uav2~=uav1
%                 dist =norm(dist_vector(i,:,uav1,uav2));
%                 %�������Ƿ�ȫ
%                 if dist>model.security_dist
%                     security_vector(i,uav1) =1;
%                 else
%                     security_vector(i,uav1) =0;
%                 end
%              end
%           end
%        end
%         
%     end
%     for uav =1:model.UAV
%        sol(uav).SecurityMatrix = security_vector(:,uav);
%     end
%     %�����Ƿ��ڰ�ȫ�������ڼ�����Ӧ��ֵ
%     %�趨��ȫ�������
%     MaxSecurity = ones(model.intervel,model.UAV);
%     w4=0.1;
%     for uav=1:model.UAV
%     uav_cost(uav) = uav_cost(uav) + w4* sum(security_vector(:,uav))/sum(MaxSecurity(:,uav)) ;      
%     end
% 
%     %����߶ȴ���,���趨���߶�
%     MaxHeight = ones(model.intervel,model.UAV);
%     w5=0.2;
%     height_cost_array = zeros(model.intervel,model.UAV);
%    for uav=1:model.UAV
%        height_cost_array(uav) = 0;
%        for i=1:length(AllPos)
%           %��ȡiʱ���ĸ߶�
%           height = AllPos(i,3,uav);
%           %�߶ȴ���һ��ֵ������Ϊ1
%           if height > max(model.robs)
%           height_cost_array(i,uav) = 1; 
%           else
%           height_cost_array(i,uav) = 0;
%           end
%           
%        end
%    end
%    for uav=1:model.UAV
%    uav_cost(uav) =uav_cost(uav) + w5* sum(height_cost_array(:,uav))/sum(MaxHeight(:,uav));
%    end
%    %�趨���markov����ֵΪ10
%    MaxMarkovCost =10*ones(model.intervel,model.UAV);
%    w6=0.5;
%    %����Ʒ�����
%    for uav=1:model.UAV
%    [stateProbabilityProcess, expectedCostProcess]=MarkovEvaluate(AllPos(:,:,uav),model);
%    uav_cost(uav) = uav_cost(uav) +w6* sum(expectedCostProcess) / sum(MaxMarkovCost(:,uav));
%    sol(uav).MarkovState = stateProbabilityProcess;
%    sol(uav).MarkovCost = expectedCostProcess;
%    end
%    %�����ܵĴ���ֵ
%    fitness=0;
%    w3=0.2;
%    for uav=1:model.UAV
%      fitness =fitness+ w1*sol(uav).Length +w2*sol(uav).Length*sol(uav).violation...
%      +w3*abs( sol(uav).Length/model.vel -chromosome.ETA  ); 
%    end
%    
%    cost =fitness;
   
end

