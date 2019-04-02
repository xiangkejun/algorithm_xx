% Astar algorithm of route planning
% Copyright(c) 2009-2014, by Chenglong Xu, All rights reserved.
% Northeastern University, Shenyang, China
% 2018/6/6 14:36:03
function Path_AstarB
clc;
clear;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%读入地图
img=imread('2.jpg');
[rows,cols,channel]=size(img);
for i=1:rows
    for j=1:cols
      if img(i,j,1)<=40&&img(i,j,2)>=230&&img(i,j,3)<=40%Start点
       StartP(1,1)=i; StartP(1,2)=j;
      end
      if 230<=img(i,j,1)&&img(i,j,2)<=40&&img(i,j,3)<=40%End点
       EndP(1,1)=i; EndP(1,2)=j;
      end
    end
end
thresh=graythresh(img);
im=im2bw(img,thresh);%01二维地图
map = ones(rows,cols); %img为二值化矩阵，不能直接改变需定义中间map矩阵
ow=0.5;%颜色中心
for i=1:rows
    for j=1:cols
      if im(i,j)==0
         map(i,j)=2;
      end
    end
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%自定义地图
% rows = 20;%图大小
% cols = 30;
% map = ones(rows,cols); 
% % 设置障障碍 
% map(8:16,4:8) = 2; 
% map(10:18,22:26) = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  set up color map for display 
%       R/255 G/255 B/255
cmap = [0.8 1 1;    % 1 - white - clear cell 第一个位置 colormap1颜色
        0 0 0;      % 2 - black - obstacle 障碍
        1 0 0;      % 3 - red -  end  终点
        0 0 1;      % 4 - blue - new-delete 新的点但是又被淘汰的
        0 1 0;      % 5 - green - start 起点
        0.5 0 0.5;  % 6 - Popul – 
        1 0 1;      % 7 - Pitch – lastpath 最后规划的轨迹
        1 1 0];     % 8 - Yellow – history 历史搜索方向
colormap(cmap);
start_r=StartP(1,1);
start_c=StartP(1,2);
end_r=EndP(1,1);
end_c=EndP(1,2);
map(start_r,start_c) = 5; % 设置起点颜色 
map(end_r,end_c) = 3; % 设置终点颜色
%ShowMap(ow,map,cols,rows);
%获取始点、终点索引
start_node = sub2ind(size(map), start_r, start_c); %将元素map（start_r, start_c)的下标转换成线性索引号 列搜索
end_node = sub2ind(size(map), end_r, end_c); 
% 探索矩阵初始化
CheckPath = Inf(rows,cols); 
CheckPath(start_node) = 0; 
%定义H函数
[X, Y] = meshgrid (1:1:cols, 1:1:rows);
H = abs(Y - end_r) + abs(X - end_c);%H 曼哈顿距离
f = Inf(rows,cols); 
f(start_node) = H(start_node);
% 对于每个网格单元，这个数组保存其父节点的索引。 
parent=zeros(rows,cols); %父节点索引
num=0;
Depth=0;%移动步数
%%主循环
%%
t0=cputime;%开始计时
while 1 %不断迭代
 num=num+1;%搜索次数
      fprintf('【INFO:--------------算法运行次数：%d】\n',num);
 %更新状态图
 map(start_node)= 5; 
 map(end_node) = 3; 
% ShowMap(ow,map,cols,rows);
  [~, current] = min(f(:)); %返回当前f最小值的索引
  [min_dist, ~] = min(CheckPath(:)); %返回当前距离数组所有数的最小值。min(CheckPath)为按列返回最小值
  if ((current == end_node) || isinf(min_dist)) %搜索到目标点或者全部搜索完，结束循环
    scrsz = get(0,'ScreenSize');  % 获取屏幕分辨率
    set(gcf,'Position',[scrsz(1) scrsz(2) ceil(cols/50*scrsz(3)/1.5) ceil(rows/30*scrsz(4)/1.5)]); 
     t1=cputime-t0;%计算时间
     fprintf('【INFO:--------------运行时间:%3.3fs 】\n',t1);
     fprintf('【INFO:--------------路径规划完成！   】\n');
       break; 
  end; 
map(current) = 8; %将当前颜色标为黄色
f(current) = Inf;  %当前区域在距离数组中设置为无穷，表示已搜索
 [i,j] = ind2sub(size(CheckPath), current); %返回当前位置的坐标
neighbor = [i-1,j; 
            i+1,j;
            i,j+1; 
            i,j-1]; %确定当前位置的上下左右区域
outRangetest = (neighbor(:,1)<1) + (neighbor(:,1)>rows) +...
                   (neighbor(:,2)<1) + (neighbor(:,2)>cols ); %判断下一次搜索的区域是否超出限制。
locate = find(outRangetest>0); %返回超限点的行数
neighbor(locate,:)=[]; %在下一次搜索区域里去掉超限点，搜索到边界了
neighborIndex = sub2ind(size(map),neighbor(:,1),neighbor(:,2)); %返回下次搜索区域的索引号。neighbor(1,1) neighbor(1,2)---neighbor(n,1) neighbor(n,2)
for i=1:length(neighborIndex) %4个
if (map(neighborIndex(i))~=2) && (map(neighborIndex(i))~=8 && map(neighborIndex(i))~= 5) 
    map(neighborIndex(i)) = 4; %如果下次搜索的点不是障碍，不是起点，没有搜索过就标为蓝色
 if CheckPath(neighborIndex(i))> min_dist + 1      %Inf
      CheckPath(neighborIndex(i)) = min_dist+1;%
        parent(neighborIndex(i)) = current; %如果在距离数组里，当前索引选为父索引
        Depth=Depth+1;
        f(neighborIndex(i))=H(neighborIndex(i))+Depth;%f=H+G 当只有H最优化时速度快但不准（大地图）
  end 
 end 
end 
end
%%画图
figure(1)
if (isinf(CheckPath(end_node))) 
    route = []; %不知道route大小
else 
    %提取路线索引，不为0的
   route =end_node; 
      while (parent(route(1)) ~= 0) 
              route = [parent(route(1)), route]; %扩展
      end 
    %动态显示出路线     
        for k = 2:length(route) - 1 
          map(route(k)) = 7; 
                pause(0.1); 
              ShowMap(ow,map,cols,rows);
              end 
end

figure(2)
image(0.5, 0.5, img),grid on;
title('输入的地图');

fprintf('【INFO:--------------实际距离：%d     】\n',length(route));
fprintf('【INFO:--------------移动步数数：%d  】\n',Depth);








function ShowMap(ow,map,cols,rows)
image(ow, ow, map); 
grid on;
xlimx=get(gca,'xlim');    %得到x轴的取值范围
ylimy=get(gca,'ylim');    %得到x轴的取值范围
set(gca,'Xtick',0:xlimx(2)/cols:xlimx(2)) %设置间隔
set(gca,'Ytick',0:ylimy(2)/rows:ylimy(2)) %设置间隔
title('A^{*}路径规划');
xlabel('像素');ylabel('像素');
%grid minor; 
box on;
axis image;