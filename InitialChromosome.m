function [ alpha,T,beta ] = InitialChromosome( model,num)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    startp =model.startp;
    endp =model.endp;
    %������ʼ��Ŀ�������
   st = endp-startp;
   dist = norm(st);
   %�������ʼ��Ŀ���ƽ��ʱ��
   deltaT = dist/model.vel/(model.dim+1);
   %������ʼ��Ŀ��ĺ�ƫ��
    st_alpha = rad2deg(atan((startp(2)-endp(2))/(startp(1)-endp(1))));
    %������ʼ��Ŀ��ĸ�����
    st_beta = rad2deg(asin(st(3)/norm(st)));
%��ʼ��Ⱦɫ�����    
alpha = zeros(model.dim,1);
beta = zeros(model.dim,1);
T=zeros(model.dim,1);
%%ǰnum��Ⱦɫ���ʼ��
if num <= model.num
sum_alpha =st_alpha;
sum_beta =st_beta;
for i =1:model.dim 
   if sum_alpha < st_alpha
       %alpha(i)��(0,alpha_max)
      alpha(i) = rand*(model.alpha_max - (model.alpha_max+model.alpha_min)/2)+(model.alpha_max+model.alpha_min)/2;
   else
       %alpha(i)��(alpha_min,0)
      alpha(i) = rand*( (model.alpha_max+model.alpha_min)/2-model.alpha_min )+model.alpha_min;
   end
   %ͬ��
   if sum_beta < st_beta
      beta(i) = rand*(model.beta_max - (model.beta_max+model.beta_min)/2)+(model.beta_max+model.beta_min)/2;
   else
      beta(i) = rand*((model.beta_max+model.beta_min)/2 -model.beta_min )+model.beta_min;
   end
      sum_beta = sum_beta + beta(i);
      sum_alpha = sum_alpha+ alpha(i);

      T(i)= (rand*(2*deltaT)-deltaT)*0.1 + deltaT;
 
end
%%num��Ⱦɫ�������ʼ��
else
    for i=1:model.dim
          alpha(i)=  (rand*2 -1)*model.alpha_max;
          beta(i)=  (rand*2 -1)*model.beta_max;
%         if last_alpha>0
%             alpha(i) = -rand *model.alpha_max;
%         else
%             alpha(i) = rand *model.alpha_max;
%         end
%         if last_beta>0
%              beta(i) = -rand*(model.beta_max);
%         else
%             beta(i) = rand*(model.beta_max);
%         end
        
        T(i)=(rand*(2*deltaT)-deltaT)*0.1+ deltaT;
%         last_alpha =  alpha(i);
%         last_beta =  beta(i);
    end
end

end


