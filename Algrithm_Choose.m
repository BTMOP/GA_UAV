function [ chromosome,globel ] = Algrithm_Choose( model )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %����Ⱦɫ��
%123


my_chromosome.pos=[];
my_chromosome.alpha=[];
my_chromosome.beta=[];
my_chromosome.atkalpha=[];
my_chromosome.atkbeta=[];
my_chromosome.T=[];
my_chromosome.sol=[];
my_chromosome.cost=[];
my_chromosome.ETA=[];
my_chromosome.IsFeasible=[];
my_chromosome.AllPos=[];
%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,model.UAV);



%��Ⱥ��ʼ��
h= waitbar(0,'initial chromosome');
for uav=1:model.UAV
startp =[model.sx(uav),model.sy(uav),model.sz(uav)];    
endp=[model.ex,model.ey,model.ez];
model.startp=startp;
model.endp=endp; 
globel(uav).cost =inf;
for i=1:model.NP
  flag =0;
  while flag ~=1
  %��ʼ���ǶȺ�ʱ��
  [chromosome(i,uav).alpha,chromosome(i,uav).T,chromosome(i,uav).beta] = InitialChromosome(model,i);
  %���ݽǶȺ�DH�����ö�Ӧ����
  [chromosome(i,uav).pos] = Angel2Pos(chromosome(i,uav),model);
    %�γɿ�ִ��·����,����ʵ�ʵ�·�����ܱ���ʼ��Ŀ���ֱ�߾���Զ,��������ʱ��T
   [chromosome(i,uav).T] =Modify_Chromosom_T(chromosome(i,uav),model);
   %���¼����µ�pos
  [chromosome(i,uav).pos] = Angel2Pos(chromosome(i,uav),model);
  %����������
  [flag,chromosome(i,uav).atkalpha,chromosome(i,uav).atkbeta] = IsReasonble(chromosome(i,uav),model);
  
  chromosome(i,uav).isFeasible = (flag==1);
  end

  %����ÿ������Э�����������Ӧ��ֵ��ÿ����ľ���������
  [chromosome(i,uav).cost,chromosome(i,uav).sol] = FitnessFunction(chromosome(i,uav),model);
  h=waitbar(i/model.NP,h,[num2str(i),':chromosomes finished']);
  if globel(uav).cost >chromosome(i,uav).cost
     globel(uav).cost =chromosome(i,uav).cost;
  end
end
end
close(h)
model.chromosome=chromosome ;
model.globel =globel;
global_gapso=GAPSO(model);
for uav=1:model.UAV
PlotSolution(global_gapso(uav).sol,model);
pause(0.01);
end
pause(0.01);
% %%����gaѡ��Ľ��Ͳ��Ľ��Ĳ���
% model.std_ga=1;
% std_globel_ga= Std_GA(model.startp,model.endp,model);
% PlotSolution(std_globel_ga.sol,model);
% model.std_ga=0;
% model.alg_choose=1;
% globel_ga=GA(model);
% PlotSolution(globel_ga.sol,model);
% pause(0.01);
% model.alg_choose=2;
% model.improve_gapso=0;
% global_gapso =GAPSO(model);
% PlotSolution(global_gapso.sol,model);
% pause(0.01);
% model.alg_choose=3;
% global_particle =PSO(model);
% PlotSolution(global_particle.sol,model);
% pause(0.01);
% model.alg_choose=4;
% model.improve_gapso=1;
% global_improve_gapso =GAPSO(model);
% PlotSolution(global_improve_gapso.sol,model);
% pause(0.01);
% 
% figure;
% % plot(globel_ga.best_plot);
% % hold on;
% plot(global_gapso.best_plot);
% hold on;
% % plot(global_particle.best_plot);
% %hold on;
% plot(global_improve_gapso.best_plot);
% % legend('GA','GAPSO','PSO','IGAPSO');
% legend('GAPSO','IGAPSO');
end

