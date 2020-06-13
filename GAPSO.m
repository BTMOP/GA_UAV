function p_global=GAPSO(model )
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
%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);

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
    p_global = chromosome(i).best;
    global_index =i;
  end
  
end
w=1;
wdamp=0.95;
c1=1.5;
c2=1.5;
c_max=3;
c_min=1;
w_ini=0.9;
w_end=0.4;
model.w=w;
model.c1=c1;
model.c2=c2;
for it=1:model.MaxIt
    %
%     if improve==1
%     model.w =w_ini - (w_ini-w_end)*it/model.MaxIt;
%     model.c1 = c_min + it*(c_max - c_min)/model.MaxIt;
%     model.c2 = c_max - it*(c_max - c_min)/model.MaxIt;
%     end
    %�õ�����ƽ����Ӧ��ֵ
    model.f_max =max(seeds_fitness);
    model.f_avg =mean(seeds_fitness);
   %������Ӧ�ȶ�Ⱦɫ������
    sort_array =zeros(model.NP,2);
    for i=1:model.NP
    sort_array(i,:)= [i,chromosome(i).cost];
    end
    %��cost��С�����������
    sort_array =sortrows(sort_array,2);
    model.p_global =p_global;
    %ֻ����ǰһ���Ⱦɫ��,��һ������
    for i=1:model.NP/2
           
           next_chromosome(i) =chromosome(sort_array(i,1));
      
           %����Ⱦɫ����ٶȺ�λ��
           [next_chromosome(i).vel,next_chromosome(i).alpha,next_chromosome(i).beta,next_chromosome(i).T]=Update_vel_pos( next_chromosome(i),model );
           [next_chromosome(i).pos]=Angel2Pos( next_chromosome(i),model );
           %���������Ƿ����
           [flag(i),next_chromosome(i).atkalpha,next_chromosome(i).atkbeta] = IsReasonble(next_chromosome(i),model);
      
           %������Ӧ��ֵ
           [next_chromosome(i).cost,next_chromosome(i).sol] = FitnessFunction(next_chromosome(i),model);
           next_chromosome(i).pso=1;
    end
    %��ʣ���NP/2��Ⱦɫ�����ѡ�񽻲�������
    for i=model.NP/2+1:2:model.NP
        %���ѡ��ĸ
        parents =repmat(my_chromosome,2,1);
        for p=1:2
        array =ceil(rand(1,2)*model.NP/2);
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
        next_chromosome(i) = sons(1);
        next_chromosome(i+1) =sons(2);
        next_chromosome(i).pso=0;
        next_chromosome(i+1).pso=0;
    end
  
    for i=1:model.NP
      
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
       if chromosome(i).cost < p_global.cost
           p_global = chromosome(i);
           %��¼����ֵ������
           global_index =i;
       end
       seeds_fitness(i) =chromosome(i).cost;
    end
    if improve==1 && it>20
    p_global =tabusearch(p_global,model);
    %��������Ⱦɫ��
    chromosome(global_index).cost =p_global.cost;
    chromosome(global_index).pos =p_global.pos;
    chromosome(global_index).alpha =p_global.alpha;
    chromosome(global_index).beta =p_global.beta;
    chromosome(global_index).T =p_global.T;
    chromosome(global_index).sol =p_global.sol;
           if chromosome(global_index).best.cost < chromosome(global_index).cost
              chromosome(global_index).best.pos =chromosome(global_index).pos;
              chromosome(global_index).best.alpha =chromosome(global_index).alpha;
              chromosome(global_index).best.beta =chromosome(global_index).beta;
              chromosome(global_index).best.T =chromosome(global_index).T;
              chromosome(global_index).best.sol =chromosome(global_index).sol;
           end
 
    end
    
    best(it+1) = p_global.cost;
    disp(['it: ',num2str(it),'   best value:',num2str(best(it))]);
end
p_global.best_plot =best;
%PlotSolution(p_global.sol,model);

end

