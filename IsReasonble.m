function [ flag_r ,AttackAlpha,AttackBeta] = IsReasonble( chromosome,model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%��麽·�Ƿ����
%λ������Խ����ú�·������Ҫ����������
sum_alpha =0;
sum_beta =0;
%��¼�µĽǵ�ֵ

   for i=1:model.dim
      if  chromosome.pos(i,1) <model.Xmin || chromosome.pos(i,2) <model.Ymin || ...
          chromosome.pos(i,1) >model.Xmax || chromosome.pos(i,2) >model.Ymax||...
          chromosome.pos(i,3) <model.Zmin || chromosome.pos(i,3) > model.Zmax
          AttackAlpha=0;
          AttackBeta =0;
          flag_r =0;
         
      
          return
      end
   end

  %�������ƫ���ܷ����Ҫ��
 
     %��·���һ����
   lastpoint=chromosome.pos(model.dim,:);
   endpoint =model.endp;
   last2end = endpoint -lastpoint;
   
   %��������ƫ�Ƿ�������һ���㵽�յ�ķ���ļн�
   %�ֱ���㺽ƫ�Ǻ͸�����
   for i=1:model.dim
      sum_alpha=sum_alpha + chromosome.alpha(i);
      sum_beta  = sum_beta + chromosome.beta(i);
   end
   
    %������ʼ��Ŀ�������
   st = model.endp - model.startp;
   %ˮƽ����
   vhorizontal=[1,0];
   %������ʼ��Ŀ��ĺ�ƫ��
    st_alpha = rad2deg( acos(dot(st(1:2),vhorizontal)/norm(st(1:2))/norm(vhorizontal) )  );
    %�������ֵС��0
    if st(2)/norm(st(1:2)) <0
        st_alpha =360 - st_alpha;        
    end
    %������ʼ��Ŀ��ĸ�����
    st_beta = rad2deg(asin(st(3)/norm(st)));
   %�Ƕ�ת������
    sum_alpha = sum_alpha + st_alpha;
    sum_beta= sum_beta +st_beta;
    sum_alpha= deg2rad(sum_alpha);
    sum_beta= deg2rad(sum_beta);
    %�ܵĺ�ƫ�ǵķ�������
    lastdeg =[cos(sum_alpha),sin(sum_alpha)];
    %ͶӰ��XOY���㺽ƫ�ǵ����仯ֵ
    theta = rad2deg(acos(dot(last2end(1:2),lastdeg)/norm(last2end(1:2))/norm(lastdeg)));
    %����last2end�ĸ�����
    ag1 = rad2deg(asin(last2end(3)/norm(last2end)));
    %��last2end�ĸ����� - �ܵĸ����� = �����һ���㵽�յ�ĸ����Ǳ仯 
    ag2 =abs( ag1 - sum_beta);
    %�������Ĺ�����
    AttackAlpha = theta;
    AttackBeta = ag2;
    %����ָ�������Ǽ���ÿ����ƫ��ƽ�����ӵĽǶ�ֵ
%     average_value(uav) = (model.attack_alpha(uav) -  AttackAlpha(uav))/(model.dim+1);
   
    
    if theta >0 && theta < model.alpha_max &&...
       ag2 >0 && ag2 <model.beta_max
        flag_r = 1;
    else
        flag_r = 0;
    end
  end
  %�������������˻������㺽ƫ�Ǽ��������ڷ�Χ�ڣ�����̭
%   if sum(flag)~=model.UAV
%       flag_r =0;
%       ETA=0;
%       return;
%   end
%    %����ܷ�ﵽʱ���ϵ�Эͬ 
%   [flag_time ,ETA_r] =EstimateTime( chromosome,model ); 
%   %���߶�����˵���ý����Ҫ��
%   flag_r = flag_time ;
%   ETA =ETA_r;
  

