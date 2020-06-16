function p_global=GATSPSO(model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

improve=model.improve_gapso;
my_chromosome.pos=[];
my_chromosome.alpha=[];
my_chromosome.beta=[];
my_chromosome.atkalpha=[];
my_chromosome.atkbeta=[];
my_chromosome.sol=[];
my_chromosome.cost=[];
my_chromosome.T=[];
my_chromosome.IsFeasible=[];
my_chromosome.vel=[];
my_chromosome.pso=[];
my_chromosome.best.pos=[];
my_chromosome.best.alpha=[];
my_chromosome.best.beta=[];
my_chromosome.best.T=[];
my_chromosome.best.sol=[];
my_chromosome.best.cost=[];
%��¼����������λ��
update_index=zeros(1,2);
%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP);
%ȫ������
p_global.cost=inf;
%��Ӧ������ֵ����
best=zeros(model.MaxIt+1,1);
best(1)=model.globel.cost;
%��Ⱥ��ʼ��
for i=1:model.NP
    chromosome(i).pos=model.chromosome(i).pos;
    chromosome(i).alpha=model.chromosome(i).alpha;
    chromosome(i).beta=model.chromosome(i).beta;
    chromosome(i).atkalpha=model.chromosome(i).atkalpha;
    chromosome(i).atkbeta=model.chromosome(i).atkbeta;
    chromosome(i).T=model.chromosome(i).T;
    chromosome(i).sol=model.chromosome(i).sol;
    chromosome(i).cost=model.chromosome(i).cost;
    chromosome(i).IsFeasible=model.chromosome(i).IsFeasible;
    chromosome(i).pso=1;
    seeds_fitness(i)=model.seeds_fitness(i);
  for d=1:3
  chromosome(i).vel(d,:)= zeros(1,model.dim);
  end
  %������ʷ��������
  chromosome(i).best.pos =chromosome(i).pos;
  chromosome(i).best.alpha =chromosome(i).alpha;
  chromosome(i).best.beta =chromosome(i).beta;
  chromosome(i).best.T =chromosome(i).T;
  chromosome(i).best.sol =chromosome(i).sol;
  chromosome(i).best.cost =chromosome(i).cost;
  %����ȫ����������
  if p_global.cost > chromosome(i).best.cost
    p_global = chromosome(i);
    global_index =i;
  end
  
end
%����Ⱥ
chromosome_main = chromosome(1:model.NP/2);
chromosome_assist =chromosome(model.NP/2+1:model.NP);
main_global =p_global;
assist_global =p_global;
w=0.8;
wdamp=0.95;
c1=1;
c2=1;
c_max=3;
c_min=1;
w_ini=0.9;
w_end=0.4;
model.w=w;
model.c1=c1;
model.c2=c2;

for it=1:model.MaxIt
    %�ֳ�������Ⱥ����GAPSO�㷨
    for pop=1:2
        np =model.NP/2;
        if pop==1
        chromosome = chromosome_main;
        else
        chromosome = chromosome_assist;
        end
        seeds_fitness =zeros(1,model.NP/2);
        for i=1:np
            seeds_fitness(i)=chromosome(i).cost;
        end
        [~,update_index(pop)]=min(seeds_fitness);
        %�õ�����ƽ����Ӧ��ֵ
        model.f_max =max(seeds_fitness);
        model.f_avg =mean(seeds_fitness);
       %������Ӧ�ȶ�Ⱦɫ������
        sort_array =zeros(np,2);
        for i=1:np
        sort_array(i,:)= [i,chromosome(i).cost];
        end
    %��cost��С�����������
        sort_array =sortrows(sort_array,2);
        model.p_global =p_global; 

    %ֻ����ǰһ���Ⱦɫ��,��һ������
        for i=1:np/2
               next_chromosome(i) =chromosome(sort_array(i,1));    
               %����Ⱦɫ����ٶȺ�λ��
               [next_chromosome(i).vel,next_chromosome(i).alpha,next_chromosome(i).beta,next_chromosome(i).T]=TSPSO_Update_Vel( next_chromosome(i),model,pop );
               [next_chromosome(i).pos]=Angel2Pos( next_chromosome(i),model );
               %���������Ƿ����
               [flag(i),next_chromosome(i).atkalpha,next_chromosome(i).atkbeta] = IsReasonble(next_chromosome(i),model);
               %������Ӧ��ֵ
               [next_chromosome(i).cost,next_chromosome(i).sol] = FitnessFunction(next_chromosome(i),model);
               next_chromosome(i).pso=1;
        end
    %��ʣ���NP/2��Ⱦɫ�����ѡ�񽻲�������
    for i=np/2+1:2:np
        %���ѡ��ĸ
        for p=1:2
        array =ceil(rand(1,2)*np/2);
        if next_chromosome(array(1)).cost < next_chromosome(array(2)).cost
            parents(p) = next_chromosome(array(1));
        else
            parents(p) = next_chromosome(array(2));
        end
        end
        %����������
        [ sons] = CrossoverAndMutation( parents,model );
        %����Ҫ���Ժ�����Ӵ�����Ӧ��ֵ
        [sons(1).cost,sons(1).sol] = FitnessFunction(sons(1),model);
        [sons(2).cost,sons(2).sol] = FitnessFunction(sons(2),model);
%         if improve==2
% %         next_chromosome(i) = SA(sons(1),model);
% %         next_chromosome(i+1) =SA(sons(2),model);
%         else
        next_chromosome(i) =sons(1);
        next_chromosome(i+1)=sons(2);
%         end
        next_chromosome(i).pso=0;
        next_chromosome(i+1).pso=0;
    end
  
    for i=1:np
      
        [~,order_index]= sort([next_chromosome.cost]);
        chromosome(i) =next_chromosome((order_index(i)));
   
       %���¾ֲ�����
       if chromosome(i).cost < chromosome(i).best.cost
              chromosome(i).best.pos =chromosome(i).pos;
              chromosome(i).best.alpha =chromosome(i).alpha;
              chromosome(i).best.beta =chromosome(i).beta;
              chromosome(i).best.T =chromosome(i).T;
              chromosome(i).best.sol =chromosome(i).sol;
              chromosome(i).best.cost =chromosome(i).cost;
       end
       %����ȫ������
       if pop==1 && chromosome(i).cost < main_global.cost  
           main_global = chromosome(i);
           %��¼�����µ�Ⱦɫ����
           update_index(1)=i;
       elseif pop==2 && chromosome(i).cost < assist_global.cost  
           assist_global = chromosome(i);
           update_index(2)=i;
       end
    end
    %��������Ⱥ��
    if pop==1
    chromosome_main =chromosome;
    else
    chromosome_assist =chromosome;  
    end
    
    end
 %�Ƚ�ȫ�ּ�ֵ
    if main_global.cost > assist_global.cost && p_global.cost > assist_global.cost
        main_global = assist_global;
        p_global=main_global;
        %������Ⱦɫ��
   
    elseif main_global.cost < assist_global.cost && p_global.cost > main_global.cost
        assist_global =main_global;
        p_global =assist_global;
        %���´�Ⱦɫ��
    else
        main_global = p_global;
        assist_global =p_global;
    end
    if improve==1 
    p_global =tabusearch(p_global,model);
    chromosome_assist(update_index(2))=p_global;
    chromosome_main(update_index(1)) = p_global;
    end
    
    best(it+1)=p_global.cost;
    disp(['it: ',num2str(it),'   best value:',num2str(best(it))]);
%PlotSolution(p_global.sol,model);

end
p_global.best_plot =best;
end

