function [ fit_array,best_fit ] = Algrithm_Choose( startp,endp,model )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %����Ⱦɫ��
%123
model.startp=startp;
model.endp=endp;

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
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);
%����Ⱦɫ��
AllChromosome = repmat(my_chromosome,model.NP*2,1);
%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP);
%ȫ������
globel.cost =inf;
%��Ⱥ��ʼ��
h= waitbar(0,'initial chromosome');
for i=1:model.NP
  flag =0;
  while flag ~=1
  %��ʼ���ǶȺ�ʱ��
  [chromosome(i).alpha,chromosome(i).T,chromosome(i).beta] = InitialChromosome(model,i);
  %���ݽǶȺ�DH�����ö�Ӧ����
  [chromosome(i).pos] = Angel2Pos(chromosome(i),model);
    %�γɿ�ִ��·����,����ʵ�ʵ�·�����ܱ���ʼ��Ŀ���ֱ�߾���Զ,��������ʱ��T
   [chromosome(i).T] =Modify_Chromosom_T(chromosome(i),model);
   %���¼����µ�pos
  [chromosome(i).pos] = Angel2Pos(chromosome(i),model);
  %����������
  [flag,chromosome(i).atkalpha,chromosome(i).atkbeta] = IsReasonble(chromosome(i),model);
  
  chromosome(i).IsFeasible = (flag==1);
  end

  %����ÿ������Э�����������Ӧ��ֵ��ÿ����ľ���������
  [chromosome(i).cost,chromosome(i).sol] = FitnessFunction(chromosome(i),model);
  %��¼���н����Ӧ��ֵ����Ϊ���̶ĵļ���
  seeds_fitness(i) = chromosome(i).cost;
  h=waitbar(i/model.NP,h,[num2str(i),':chromosomes finished']);
  if globel.cost >chromosome(i).cost
     globel.cost =chromosome(i).cost;
  end
end
close(h)
%�����ʼ������
model.seeds_fitness=seeds_fitness;
model.chromosome=chromosome ;
model.next_chromosome=next_chromosome;
model.AllChromosome=AllChromosome;
model.globel =globel;
% %%����gaѡ��Ľ��Ͳ��Ľ��Ĳ���
% model.std_ga=1;
% std_globel_ga= Std_GA(model.startp,model.endp,model);
% PlotSolution(std_globel_ga.sol,model);
% % model.std_ga=1;
% pause(0.01);
model.alg_choose=1;
global_pso =PSO(model);
PlotSolution(global_pso.sol,model);
pause(0.01);
% 
% % model.imporve_ga=1;
% % model.alg_choose=2;
% % globel_ga=GA(model);
% % PlotSolution(globel_ga.sol,model);
% % pause(0.01);
model.alg_choose=3;
model.improve_gapso=0;
global_gapso=GAPSO(model);
PlotSolution(global_gapso.sol,model);
pause(0.01);
model.alg_choose=4;
model.improve_gapso=1;
global_improve_gapso =GAPSO(model);
PlotSolution(global_improve_gapso.sol,model);
pause(0.01);

% model.alg_choose=5;
% model.improve_gapso=1;
% global_improve_gatspso =GATSPSO(model);
% PlotSolution(global_improve_gatspso.sol,model);
global Scene;
global p1;
global p3;
global p4;
figure(Scene);
legend([p1,p3,p4],'PSO','GAPSO','IGAPSO');
global fit_cmp;
fit_cmp= figure;
plot(global_pso.best_plot);
hold on;
% plot(globel_ga.best_plot);
% hold on;
plot(global_gapso.best_plot);
hold on;
plot(global_improve_gapso.best_plot);
legend('PSO','GAPSO','IGAPSO');
%legend('GAPSO','DGAPSO');
fit_array=[global_pso.cost,global_gapso.cost,global_improve_gapso.cost];
best_fit(1,:)=global_pso.best_plot;
best_fit(2,:)=global_gapso.best_plot;
best_fit(3,:)=global_improve_gapso.best_plot;
end

