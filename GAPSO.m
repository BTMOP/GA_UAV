function GAPSO( startp,endp,model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

model.startp=startp;
model.endp=endp;

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
%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);

%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP);
%ȫ������
p_global.cost =inf;

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
  %��ʼ��dά�ٶ�Ϊ0
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
  end
  
end
close(h);

for it=1:model.MaxIt
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
           %������Ӧ��ֵ
           [next_chromosome(i).cost,next_chromosome(i).sol] = FitnessFunction(next_chromosome(i),model);
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
       if chromosome(i).cost < p_global.cost
           p_global = chromosome(i);
       end
       seeds_fitness(i) =chromosome(i).cost;
    end
    best(it) = p_global.cost;
    disp(['it: ',num2str(it),'   best value:',num2str(p_global.cost)]);
    
end

PlotSolution(p_global.sol,model);

end

