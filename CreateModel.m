function model = CreateModel()
%��ʼ������
sx =[1.2];
sy =[1.2];
sz =[0.4];
%�յ�����
ex =29;
ey =28;
ez =0.4;
%��ƫ�Ƿ�Χ
alpha_min= -45;
alpha_max = 45;
%�����Ƿ�Χ
beta_min = -1;
beta_max = 1;
%GA��Ⱥ��
NP=30;
%GA����������
MaxIt=80;
%ÿ��Ⱦɫ���ά��
dim =12;
%num�������ʼ����ʽ
num=NP*0.1;
%�������
cross_prob =0.9;
%�������
mutation_prob=0.1;
%�״�λ��
xobs =[7.5,10,17.5,24,25];
yobs =[15,4.5,14,23,9];
zobs = [0.3, 0.3, 0.3,0.3,0.3];
robs =[4,3,4.5,4,3.5];
%����λ��
weapon_x=[1400,2500,3800,2700];
weapon_y=[2500,1600,2500,3200];
weapon_z=[300,300,300,300];
weapon_r=[450,450,450,450];

model.weapon_x=weapon_x;
model.weapon_y=weapon_y;
model.weapon_z=weapon_z;
model.weapon_r=weapon_r;
%�����
mission_seq=[2 3 1];
mission_x=[1500,3000,4500];
mission_y=[1800,1900,2200];
mission_z=[600,550,550];
mission_r=[15,15,15];
model.mission_seq =mission_seq;
model.mission_x=mission_x;
model.mission_y=mission_y;
model.mission_z=mission_z;
model.mission_r=mission_r;
%��ͼ��С
%x,y,z����Χ
Xmin=0;Xmax=30;Ymin=0;Ymax=30;Zmin=0.3;Zmax=1;
model.Xmin =Xmin;
model.Xmax =Xmax;
model.Ymin =Ymin;
model.Ymax =Ymax;
model.Zmin =Zmin;
model.Zmax =Zmax;
mapmin=[0 0 0];
mapmax=[700e3 600e3 500e3];
%ָ��������alpha
attack_alpha =[60 -60];
model.attack_alpha = attack_alpha;
model.beta_max =beta_max;
model.beta_min = beta_min;
model.sz =sz;
model.ez =ez;
model.zobs =zobs;
model.mapmin =mapmin;
model.mapmax =mapmax;
model.xobs=xobs;
model.yobs=yobs;
model.robs=robs;
model.mutation_prob=mutation_prob;
model.cross_prob=cross_prob;
model.num=num;
model.dim=dim;
model.NP=NP;
model.MaxIt=MaxIt;
model.sx =sx;
model.sy =sy;
model.ex =ex;
model.ey=ey;
model.alpha_min =alpha_min;
model.alpha_max =alpha_max;


%%�������˻�
UAV = numel(sx);
vel =0.2;
vrange=[0.18 0.22];
%Эͬʱ���Ϊintervel��ʱ����֮��
intervel=20;
%���˻���ȫ����
security_dist =5;
model.security_dist =security_dist;
model.intervel=intervel;
%������㵽Ŀ��ľ����������ٶ�
Tmax = norm([sx(1)-ex,sy(1)-ey,ez(1)-ez(1)])/vrange(1)/(model.dim+1);
Tmin =0;
model.Tmin =Tmin;
model.Tmax =Tmax;
model.vrange =vrange;
model.vel = vel;
model.UAV=UAV;
%pso
c1=1;
c2=1;
w=0.8;
model.w=w;
model.c1=c1;
model.c2=c2;

improve_gapso=0;
model.improve_gapso=improve_gapso;
%matlab����
debug =1;
model.debug =debug;
std_ga=0;
model.std_ga =std_ga;
model.alg_choose=1;
end
