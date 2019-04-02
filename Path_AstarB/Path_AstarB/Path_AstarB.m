% Astar algorithm of route planning
% Copyright(c) 2009-2014, by Chenglong Xu, All rights reserved.
% Northeastern University, Shenyang, China
% 2018/6/6 14:36:03
function Path_AstarB
clc;
clear;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ͼ
img=imread('2.jpg');
[rows,cols,channel]=size(img);
for i=1:rows
    for j=1:cols
      if img(i,j,1)<=40&&img(i,j,2)>=230&&img(i,j,3)<=40%Start��
       StartP(1,1)=i; StartP(1,2)=j;
      end
      if 230<=img(i,j,1)&&img(i,j,2)<=40&&img(i,j,3)<=40%End��
       EndP(1,1)=i; EndP(1,2)=j;
      end
    end
end
thresh=graythresh(img);
im=im2bw(img,thresh);%01��ά��ͼ
map = ones(rows,cols); %imgΪ��ֵ�����󣬲���ֱ�Ӹı��趨���м�map����
ow=0.5;%��ɫ����
for i=1:rows
    for j=1:cols
      if im(i,j)==0
         map(i,j)=2;
      end
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�Զ����ͼ
% rows = 20;%ͼ��С
% cols = 30;
% map = ones(rows,cols); 
% % �������ϰ� 
% map(8:16,4:8) = 2; 
% map(10:18,22:26) = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  set up color map for display 
%       R/255 G/255 B/255
cmap = [0.8 1 1;    % 1 - white - clear cell ��һ��λ�� colormap1��ɫ
        0 0 0;      % 2 - black - obstacle �ϰ�
        1 0 0;      % 3 - red -  end  �յ�
        0 0 1;      % 4 - blue - new-delete �µĵ㵫���ֱ���̭��
        0 1 0;      % 5 - green - start ���
        0.5 0 0.5;  % 6 - Popul �C 
        1 0 1;      % 7 - Pitch �C lastpath ���滮�Ĺ켣
        1 1 0];     % 8 - Yellow �C history ��ʷ��������
colormap(cmap);
start_r=StartP(1,1);
start_c=StartP(1,2);
end_r=EndP(1,1);
end_c=EndP(1,2);
map(start_r,start_c) = 5; % ���������ɫ 
map(end_r,end_c) = 3; % �����յ���ɫ
%ShowMap(ow,map,cols,rows);
%��ȡʼ�㡢�յ�����
start_node = sub2ind(size(map), start_r, start_c); %��Ԫ��map��start_r, start_c)���±�ת�������������� ������
end_node = sub2ind(size(map), end_r, end_c); 
% ̽�������ʼ��
CheckPath = Inf(rows,cols); 
CheckPath(start_node) = 0; 
%����H����
[X, Y] = meshgrid (1:1:cols, 1:1:rows);
H = abs(Y - end_r) + abs(X - end_c);%H �����پ���
f = Inf(rows,cols); 
f(start_node) = H(start_node);
% ����ÿ������Ԫ��������鱣���丸�ڵ�������� 
parent=zeros(rows,cols); %���ڵ�����
num=0;
Depth=0;%�ƶ�����
%%��ѭ��
%%
t0=cputime;%��ʼ��ʱ
while 1 %���ϵ���
 num=num+1;%��������
      fprintf('��INFO:--------------�㷨���д�����%d��\n',num);
 %����״̬ͼ
 map(start_node)= 5; 
 map(end_node) = 3; 
% ShowMap(ow,map,cols,rows);
  [~, current] = min(f(:)); %���ص�ǰf��Сֵ������
  [min_dist, ~] = min(CheckPath(:)); %���ص�ǰ������������������Сֵ��min(CheckPath)Ϊ���з�����Сֵ
  if ((current == end_node) || isinf(min_dist)) %������Ŀ������ȫ�������꣬����ѭ��
    scrsz = get(0,'ScreenSize');  % ��ȡ��Ļ�ֱ���
    set(gcf,'Position',[scrsz(1) scrsz(2) ceil(cols/50*scrsz(3)/1.5) ceil(rows/30*scrsz(4)/1.5)]); 
     t1=cputime-t0;%����ʱ��
     fprintf('��INFO:--------------����ʱ��:%3.3fs ��\n',t1);
     fprintf('��INFO:--------------·���滮��ɣ�   ��\n');
       break; 
  end; 
map(current) = 8; %����ǰ��ɫ��Ϊ��ɫ
f(current) = Inf;  %��ǰ�����ھ�������������Ϊ�����ʾ������
 [i,j] = ind2sub(size(CheckPath), current); %���ص�ǰλ�õ�����
neighbor = [i-1,j; 
            i+1,j;
            i,j+1; 
            i,j-1]; %ȷ����ǰλ�õ�������������
outRangetest = (neighbor(:,1)<1) + (neighbor(:,1)>rows) +...
                   (neighbor(:,2)<1) + (neighbor(:,2)>cols ); %�ж���һ�������������Ƿ񳬳����ơ�
locate = find(outRangetest>0); %���س��޵������
neighbor(locate,:)=[]; %����һ������������ȥ�����޵㣬�������߽���
neighborIndex = sub2ind(size(map),neighbor(:,1),neighbor(:,2)); %�����´���������������š�neighbor(1,1) neighbor(1,2)---neighbor(n,1) neighbor(n,2)
for i=1:length(neighborIndex) %4��
if (map(neighborIndex(i))~=2) && (map(neighborIndex(i))~=8 && map(neighborIndex(i))~= 5) 
    map(neighborIndex(i)) = 4; %����´������ĵ㲻���ϰ���������㣬û���������ͱ�Ϊ��ɫ
 if CheckPath(neighborIndex(i))> min_dist + 1      %Inf
      CheckPath(neighborIndex(i)) = min_dist+1;%
        parent(neighborIndex(i)) = current; %����ھ����������ǰ����ѡΪ������
        Depth=Depth+1;
        f(neighborIndex(i))=H(neighborIndex(i))+Depth;%f=H+G ��ֻ��H���Ż�ʱ�ٶȿ쵫��׼�����ͼ��
  end 
 end 
end 
end
%%��ͼ
figure(1)
if (isinf(CheckPath(end_node))) 
    route = []; %��֪��route��С
else 
    %��ȡ·����������Ϊ0��
   route =end_node; 
      while (parent(route(1)) ~= 0) 
              route = [parent(route(1)), route]; %��չ
      end 
    %��̬��ʾ��·��     
        for k = 2:length(route) - 1 
          map(route(k)) = 7; 
                pause(0.1); 
              ShowMap(ow,map,cols,rows);
              end 
end

figure(2)
image(0.5, 0.5, img),grid on;
title('����ĵ�ͼ');

fprintf('��INFO:--------------ʵ�ʾ��룺%d     ��\n',length(route));
fprintf('��INFO:--------------�ƶ���������%d  ��\n',Depth);








function ShowMap(ow,map,cols,rows)
image(ow, ow, map); 
grid on;
xlimx=get(gca,'xlim');    %�õ�x���ȡֵ��Χ
ylimy=get(gca,'ylim');    %�õ�x���ȡֵ��Χ
set(gca,'Xtick',0:xlimx(2)/cols:xlimx(2)) %���ü��
set(gca,'Ytick',0:ylimy(2)/rows:ylimy(2)) %���ü��
title('A^{*}·���滮');
xlabel('����');ylabel('����');
%grid minor; 
box on;
axis image;