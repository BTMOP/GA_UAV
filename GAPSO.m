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
my_chromosome.best.pos=[];
my_chromosome.best.alpha=[];
my_chromosome.best.beta=[];
my_chromosome.best.T=[];
my_chromosome.best.sol=[];
my_chromosome.best.cost=[];

%ȫ������
p_global=repmat(my_chromosome,model.UAV,1);
best=zeros(model.UAV,model.MaxIt+1);
%����Ⱦɫ��
AllChromosome = repmat(my_chromosome,model.NP*model.UAV,1);
for uav=1:model.UAV
%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);

%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP/2);
p_global(uav).cost=inf;
%��Ӧ������ֵ����
best(uav,1)=model.globel(uav).cost;
%��Ⱥ��ʼ��
for i=1:model.NP
    chromosome(i).pos=model.chromosome(i,uav).pos;
    chromosome(i).alpha=model.chromosome(i,uav).alpha;
    chromosome(i).beta=model.chromosome(i,uav).beta;
    chromosome(i).atkalpha=model.chromosome(i,uav).atkalpha;
    chromosome(i).atkbeta=model.chromosome(i,uav).atkbeta;
    chromosome(i).T=model.chromosome(i,uav).T;
    chromosome(i).sol=model.chromosome(i,uav).sol;
    chromosome(i).cost=model.chromosome(i,uav).cost;
    chromosome(i).IsFeasible=model.chromosome(i,uav).IsFeasible;

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
  if p_global(uav).cost > chromosome(i).cost
    p_global(uav) = chromosome(i);
  end
  
end

AllChromosome((uav-1)*model.NP+1:uav*model.NP)=chromosome;
end
%���е�Ⱦɫ��Ԥ�������
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
    if improve==1
    model.w =w_end + (w_ini-w_end)*it/model.MaxIt;
    model.c1 = c_min + it*(c_max - c_min)/model.MaxIt;
    model.c2 = c_max - it*(c_max - c_min)/model.MaxIt;
    end
    for uav=1:model.UAV
    startp =[model.sx(uav),model.sy(uav),model.sz(uav)];    
    endp=[model.ex,model.ey,model.ez];
    model.startp=startp;
    model.endp=endp;    
     
    chromosome =AllChromosome((uav-1)*model.NP+1:uav*model.NP);
   %������Ӧ�ȶ�Ⱦɫ������
    sort_array =zeros(model.NP,2);
    for i=1:model.NP
    sort_array(i,:)= [i,chromosome(i).cost];
    end
    %��cost��С�����������
    sort_array =sortrows(sort_array,2);
    model.p_global =p_global(uav);
    %ֻ����ǰһ���Ⱦɫ��,��һ������
    for i=1:model.NP/2
           
           
           next_chromosome(i) =chromosome(sort_array(i,1));
           %����Ⱦɫ����ٶȺ�λ��
           [next_chromosome(i).vel,next_chromosome(i).alpha,next_chromosome(i).beta,next_chromosome(i).T]=Update_vel_pos( next_chromosome(i),model );
           [next_chromosome(i).pos]=Angel2Pos( next_chromosome(i),model );
           %���������Ƿ����
           [flag,next_chromosome(i).atkalpha,next_chromosome(i).atkbeta] = IsReasonble(next_chromosome(i),model);
           if flag== 0
            next_chromosome(i) =chromosome(sort_array(i,1));
           end
               %������Ӧ��ֵ
           [next_chromosome(i).cost,next_chromosome(i).sol] = FitnessFunction(next_chromosome(i),model);
           seeds_fitness(i) = next_chromosome(i).cost;
    end
    %��ʣ���NP/2��Ⱦɫ�����ѡ�񽻲�������
    for i=model.NP/2+1:2:model.NP
        if improve==1
     %������Ӧ��ֵԽСԽ��
    seeds_fitness = 1./seeds_fitness;
    total_fitness = sum(seeds_fitness);
    seeds_probability = seeds_fitness/ total_fitness;
    %�����ۼƸ���
    seeds_accumulate_probability = cumsum(seeds_probability, 2);        
        %���ݸ������ѡ��һ��Ϊ��
       select =rand;
       index =1;
       while select > seeds_accumulate_probability(index) && index < model.NP
           index =index+1;
       end
       parents(1) = next_chromosome(index);
       %���ݸ������ѡ��һ��Ϊĸ
       select =rand;
       index =1;
       while select > seeds_accumulate_probability(index) && index < model.NP
           index =index+1;
       end
        parents(2) = next_chromosome(index);
       else
        
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
        
        end
            %�õ�����ƽ����Ӧ��ֵ
        model.f_max =max(seeds_fitness);
        model.f_avg =mean(seeds_fitness);
        %����������
        [ sons] = CrossoverAndMutation( parents,model );
        %����Ҫ���Ժ�����Ӵ�����Ӧ��ֵ
        [sons(1).cost,sons(1).sol] = FitnessFunction(sons(1),model);
        [sons(2).cost,sons(2).sol] = FitnessFunction(sons(2),model);
        next_chromosome(i) = sons(1);
        next_chromosome(i+1) =sons(2);
    end
    for i=1:model.NP
       chromosome(i) =next_chromosome(i);
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
       if chromosome(i).cost < p_global(uav).cost
           p_global(uav) = chromosome(i);
       end
    end
 
    best(uav,it+1) = p_global(uav).cost;
    disp(['uav',num2str(uav),' it: ',num2str(it),'   best value:',num2str(best(uav,it))]);
    AllChromosome((uav-1)*model.NP+1:uav*model.NP) =chromosome;
    end
    %����uavһ�ε�������
    
end
for uav=1:model.UAV
    p_global(uav).best_plot =best(uav,:);
end
%PlotSolution(p_global.sol,model);
    
end

