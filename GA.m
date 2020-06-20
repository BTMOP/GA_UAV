function [globel]=GA( model )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
seeds_fitness =model.seeds_fitness;
chromosome =model.chromosome;
next_chromosome=model.next_chromosome;
AllChromosome=model.AllChromosome;
globel.cost =inf;
%��Ӧ������ֵ����
best=zeros(model.MaxIt+1,1);
best(1)=model.globel.cost;
[~,global_index ]=min(seeds_fitness);
   for it=1:model.MaxIt

    %������Ӧ��ֵԽСԽ��
    seeds_fitness = 1./seeds_fitness;
    total_fitness = sum(seeds_fitness);
    seeds_probability = seeds_fitness/ total_fitness;
    %�����ۼƸ���
    seeds_accumulate_probability = cumsum(seeds_probability, 2);    
    %�������̶�ѡ��ĸ,�ܹ�ѡ���NP���Ӵ�
    for seed=1:2:model.NP
    flag =0;
    %��֤��ĸ���Ӵ�������Ҫ��

    [parents,flag] = SelectChromosome(seeds_accumulate_probability,model,chromosome);
    %�ڸ�ĸȾɫ����л�������ͱ��������
    %����ñ�֤ÿ���Ӵ�������Լ������

    
    [ sons] = CrossoverAndMutation( parents,model );
    
    %����Ҫ���Ժ�����Ӵ�����Ӧ��ֵ
    [sons(1).cost,sons(1).sol] = FitnessFunction(sons(1),model);
    [sons(2).cost,sons(2).sol] = FitnessFunction(sons(2),model);
    next_chromosome(seed) = (sons(1));
    next_chromosome(seed+1) = (sons(2));
    end
   %���¾ɺϲ�ͬһ��Ⱥ
    AllChromosome(1:model.NP) = chromosome(1:model.NP);
    AllChromosome(model.NP+1:model.NP*2) = next_chromosome(1:model.NP);
    %��Ӣ����,�¾���Ⱥһ��Ƚ�
    

    [~,order]=sort([AllChromosome.cost]);
    
    %ѡ��������Ⱦɫ���ȫ������Ⱦɫ��
    for index =1:model.NP
        chromosome(index) = next_chromosome(index);
        seeds_fitness(index) =chromosome(index).cost; 
        if globel.cost >chromosome(index).cost
            globel = chromosome(index);
            global_index =index;
        end
    end
    %��������ֵ
    chromosome(global_index) = globel;
    best(it+1) = globel.cost;
    disp(['it: ',num2str(it),'   best value:',num2str(best(it))]);
    
    end
    globel.best_plot =best;
end

