function Std_GA( startp,endp,model )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    model.startp=startp;
    model.endp=endp;
    model.NP=40;
    model.MaxIt=50;
    %����ʼ��Ŀ�ĵ�30�ȷ֣����˳���x����
    model.dim=10;
    x= linspace(startp(1),endp(1),model.dim+2);
    slice =50;
    y =linspace(startp(2),endp(2),slice);
    z=linspace(200,350,slice);
    my_chromosome.pos=[];
    my_chromosome.cost=[];
    my_chromosome.sol=[];
    chromosome = repmat(my_chromosome,model.NP,1);
    %����Ⱦɫ��
    AllChromosome = repmat(my_chromosome,model.NP*2,1);
     %�Ӵ�Ⱦɫ��
    next_chromosome = repmat(my_chromosome,model.NP,1);
    %��Ⱥ����Ӧ��ֵ
    seeds_fitness=zeros(1,model.NP);
    %ȫ������
    globel.cost =inf;
    len =numel(x)-2;
    %��ʼ��Ⱦɫ��
    for i=1:model.NP
        if i<2
            for dim=1:len
                chromosome(i).pos(dim,1)=x(dim+1);
                chromosome(i).pos(dim,2)=y(ceil(dim*slice/len));
                chromosome(i).pos(dim,3)=z(ceil(dim*slice/len));
            end
        else
            for dim=1:len
            chromosome(i).pos(dim,1)=x(dim+1);
            chromosome(i).pos(dim,2)=y(ceil(rand*slice));
            chromosome(i).pos(dim,3)=z(ceil(rand*slice));
            end
        end
    [chromosome(i).cost,chromosome(i).sol]=FitnessFunction( chromosome(i),model );
    seeds_fitness(i) = chromosome(i).cost;
    end
    
    %��ʼ��������
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
    while flag~=1
    [parents,flag] = SelectChromosome(seeds_accumulate_probability,model,chromosome);
    %�ڸ�ĸȾɫ����л�������ͱ��������
    %����ñ�֤ÿ���Ӵ�������Լ������
    end
    %����
    sons =parents;
    if model.cross_prob > rand
        %����������Ҫ����Ļ���
        cross_prob = 0.8;
        gene_pos(:,:,1)=parents(1).pos(:,2:3);
        gene_pos(:,:,2)=parents(2).pos(:,2:3);
        sons(1).pos(:,2:3) = cross_prob*gene_pos(:,:,1)+(1-cross_prob)*gene_pos(:,:,2);
        sons(2).pos(:,2:3) = cross_prob*gene_pos(:,:,2)+(1-cross_prob)*gene_pos(:,:,1);
    end
    %����
    if model.mutation_prob>rand
    r = randi(10,1,1);
    k = 0.1;
    if mod(r,2) ==1
    sons(1).pos(:,2:3) = sons(1).pos(:,2:3) - k*(sons(1).pos(:,2:3) - ones(model.dim,1)*[model.Ymin,200])*r/10;
    sons(2).pos(:,2:3) = sons(2).pos(:,2:3) - k*(sons(2).pos(:,2:3) - ones(model.dim,1)*[model.Ymin,200])*r/10;
    else
    sons(1).pos(:,2:3) = sons(1).pos(:,2:3) + k*(ones(model.dim,1)*[model.Ymax,500]-sons(1).pos(:,2:3))*r/10;
    sons(2).pos(:,2:3) = sons(2).pos(:,2:3) + k*(ones(model.dim,1)*[model.Ymax,500]-sons(2).pos(:,2:3))*r/10;
    end
    
    end
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
        seeds_fitness(index) =chromosome(index).cost; 
        if globel.cost >chromosome(index).cost
            globel = chromosome(index);
        end
    end
  
    best(it) = globel.cost;
    disp(['it: ',num2str(it),'   best value:',num2str(globel.cost)]);
    
    
    
    end
model.std_ga=1;
PlotSolution(globel.sol,model);   
end

