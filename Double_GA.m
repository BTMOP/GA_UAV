function [ ga_global ] = Double_GA( model )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    %UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

model.npop=2;
npop=model.npop;
%��Ӧ������ֵ����
best=zeros(model.MaxIt+1,1);
best(1)=model.globel.cost;

   for it=1:model.MaxIt
       
    for pop=1:npop
    chromosome =model.chromosome( (pop-1)*model.NP/npop+1:pop*model.NP/npop);
    for i=1:model.NP/npop
        seeds_fitness(i)=chromosome(i).cost;
    end
    globel(pop) = chromosome(1);
    %�õ�����ƽ����Ӧ��ֵ
    model.f_max =max(seeds_fitness);
    model.f_avg =mean(seeds_fitness);
    %������Ӧ��ֵԽСԽ��
    seeds_fitness = 1./seeds_fitness;
    total_fitness = sum(seeds_fitness);
    seeds_probability = seeds_fitness/ total_fitness;
    %�����ۼƸ���
    seeds_accumulate_probability = cumsum(seeds_probability, 2);    
    %�������̶�ѡ��ĸ,�ܹ�ѡ���NP���Ӵ�
    for seed=1:2:model.NP/npop
    %��֤��ĸ���Ӵ�������Ҫ��
    [parents,~] = SelectChromosome(seeds_accumulate_probability,model,chromosome);
    %�ڸ�ĸȾɫ����л�������ͱ��������
    %����ñ�֤ÿ���Ӵ�������Լ����
    [ sons] = CrossoverAndMutation( parents,model );
    %����Ҫ���Ժ�����Ӵ�����Ӧ��ֵ
    [sons(1).cost,sons(1).sol] = FitnessFunction(sons(1),model);
    [sons(2).cost,sons(2).sol] = FitnessFunction(sons(2),model);
    next_chromosome(seed) = (sons(1));
    next_chromosome(seed+1) = (sons(2));
    end
    all_chromosome(1:model.NP/npop) = chromosome;
    all_chromosome(model.NP/npop+1:model.NP) =next_chromosome;
    %��cost��С�����������
    [~,order_index]= sort([all_chromosome.cost]);
    %ѡ��������Ⱦɫ���ȫ������Ⱦɫ��
    for index =1:model.NP/npop
        next_chromosome(index) = all_chromosome(order_index(index));
        seeds_fitness(index) =chromosome(index).cost; 
        if globel(pop).cost >chromosome(index).cost
            globel(pop) = chromosome(index);
        end
    end
    %ѡ������Ⱥ���������pop_num��Ⱦɫ����н���
    pop_num=5;
    for i=1:pop_num
         pop_trans(i+(pop-1)*pop_num)=  all_chromosome(order_index(i));
    end
    %������һ�ε�������
    model.chromosome( (pop-1)*model.NP/npop+1:pop*model.NP/npop) =next_chromosome;
    end
    %�Ը�������Ⱥ�Ĳ���Ⱥ�彻��
    pop_1=pop_trans(1:pop_num);
    tp_pop =pop_trans(pop_num+1:end);
    pop_trans(1:pop_num* (npop-1)) =tp_pop;
    pop_trans(pop_num* (npop-1)+1:end)=pop_1;
    for pop=1:npop
        model.chromosome(pop*model.NP/npop - pop_num+1:pop*model.NP/npop)=pop_trans((pop-1)*pop_num+1:pop*pop_num);
    end
    for pop=1:npop
       if  model.globel.cost>globel(pop).cost
             model.globel.cost = globel(pop).cost;
       end
    end
    
    best(it)=model.globel.cost;
    disp(['it: ',num2str(it),'   best value:',num2str(best(it))]);
   end
    ga_global =globel(1);
    ga_global.best_plot =best;
end

