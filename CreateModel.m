function model = CreateModel()
%��ʼ������
sx =[200];
sy =[2000];
sz =[600];
%�յ�����
ex =3000;
ey =2500;
ez =650;
%��ƫ�Ƿ�Χ
alpha_min= -30;
alpha_max = 30;
%�����Ƿ�Χ
beta_min = -10;
beta_max = 10;
%GA��Ⱥ��
NP=30;
%GA����������
MaxIt=30;
%ÿ��Ⱦɫ���ά��
dim =10;
%num�������ʼ����ʽ
num=NP*0.1;
%�������
cross_prob =0.9;
%�������
mutation_prob=0.1;
%�״�λ��
xobs =[3000,2000,4000];
yobs =[1400,2200,3600];
zobs = [300, 300, 300];
robs =[500,500,550];
%����λ��
weapon_x=[2500,3000];
weapon_y=[4000,3600];
weapon_z=[300,300];
weapon_r=[450,500];

model.weapon_x=weapon_x;
model.weapon_y=weapon_y;
model.weapon_z=weapon_z;
model.weapon_r=weapon_r;
%�����
mission_seq=[2 3 1];
mission_x=[800,410,555];
mission_y=[580,545,675];
mission_z=[278,280,280];
mission_r=[15,15,15];
model.mission_seq =mission_seq;
model.mission_x=mission_x;
model.mission_y=mission_y;
model.mission_z=mission_z;
model.mission_r=mission_r;
%��ͼ��С
%x,y,z����Χ
Xmin=0;Xmax=6000;Ymin=0;Ymax=6000;Zmin=300;Zmax=1200;
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
vel =100;
vrange=[50 150];
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
c1=1.5;
c2=1.5;
w=1;
model.w=w;
model.c1=c1;
model.c2=c2;


%matlab����
debug =1;
model.debug =debug;
std_ga=1;
model.std_ga =std_ga;
model.alg_choose=1;
end
