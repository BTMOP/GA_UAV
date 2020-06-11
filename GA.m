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

   for it=1:model.MaxIt
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
    for seed=1:2:model.NP
    flag =0;
    %��֤��ĸ���Ӵ�������Ҫ��
    while flag~=1
    [parents,flag] = SelectChromosome(seeds_accumulate_probability,model,chromosome);
    %�ڸ�ĸȾɫ����л�������ͱ��������
    %����ñ�֤ÿ���Ӵ�������Լ������
    end
    
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
    
    for i=1:model.NP*2
    eval_array(i,:) = [i,AllChromosome(i).cost];
    end
    %��cost��С�����������
    eval_array =sortrows(eval_array,2);
    last_cost=eval_array(1,2);
    cnt =1;
    chromosome(cnt) = AllChromosome(eval_array(1,1));
    %�´ε�����Ⱦɫ��Ϊ���ظ�cost������Ⱦɫ��
    for i=2:model.NP*2
        current_cost = eval_array(i,2);
        if current_cost ~= last_cost
        cnt = cnt+1;
        chromosome(cnt) = AllChromosome(eval_array(i,1));
        last_cost = current_cost;
        end
    end
    %����´ε�����Ⱦɫ����Ŀ�������͸������̶Ĳ�Ⱦɫ�塣
    cnt_r =cnt;
    while cnt <model.NP
        cnt= cnt+1;
        chromosome(cnt) = AllChromosome(eval_array(cnt - cnt_r,1));
    end
    %ѡ��������Ⱦɫ���ȫ������Ⱦɫ��
    for index =1:model.NP
        if model.std_ga==1
            chromosome(index) =next_chromosome(index);
        end
        seeds_fitness(index) =chromosome(index).cost; 
        if globel.cost >chromosome(index).cost
            globel = chromosome(index);
        end
    end

    best(it+1) = globel.cost;
    globel.best_plot =best;
    disp(['it: ',num2str(it),'   best value:',num2str(best(it))]);
    
    end

end

