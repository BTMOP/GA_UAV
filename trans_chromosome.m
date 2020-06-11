function [ trans_chromosome ] = trans_chromosome( chromosome,model,end2start_flag )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    trans_chromosome =chromosome;
    %ת����ƫ��
    for i=2:model.dim
        trans_chromosome.alpha(i) = chromosome.alpha(model.dim-i+2);
    end
    %������ʼ���յ���յ㵽���ĳ�ʼ����ͬ�����Ե�һ����ƫ��Ҫ����
    if end2start_flag==1
    %���һ���㵽��������
    last2start =[chromosome.pos(model.dim,1)-model.startp(1),chromosome.pos(model.dim,2)-model.startp(2),chromosome.pos(model.dim,3)-model.startp(3)];
    %�յ㵽��������
    end2start=model.endp -model.startp;
      %������ʼ��Ŀ��ĺ�ƫ��
    st_alpha = rad2deg( acos(dot(last2start(1:2),end2start(1:2))/norm(last2start(1:2))/norm(end2start(1:2)) ) );
    else
    %���һ���㵽�յ������
    last2end =[chromosome.pos(model.dim,1)-model.endp(1),chromosome.pos(model.dim,2)-model.endp(2),chromosome.pos(model.dim,3)-model.endp(3)];
    %�յ㵽��������
    start2end=model.endp -model.startp;   
    st_alpha = rad2deg( acos(dot(last2end(1:2),start2end(1:2))/norm(last2end(1:2))/norm(start2end(1:2)) ) );
    end
    trans_chromosome.alpha(1)=st_alpha;
    %ת�������Ǻ�ʱ��
    for i=1:model.dim
        trans_chromosome.beta(i)= -chromosome.beta(model.dim-i+1);
        trans_chromosome.T(i) =chromosome.T(model.dim-i+1);
    end
    
    
end

