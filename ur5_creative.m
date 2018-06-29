%% drawing 1: house
function [a,b,c,d]=ur5_creative()
RGB  = imread('test.jpeg');
I = rgb2gray(RGB);
BW = edge(I,'canny');
[H,T,R] = hough(BW);
P  = houghpeaks(H,6,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,T,R,P,'FillGap',10,'MinLength',7);
% figure, imshow(I), hold on

benchmark_x = lines(1).point1(1);
benchmark_y = lines(1).point1(2);
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   begin_x(k)=xy(1,1);
   begin_y(k)=xy(1,2);
   end_x(k)=xy(2,1);
   end_y(k)=xy(2,2);
   
   end_x(k)=(end_x(k)-benchmark_x)/7500;
   end_y(k)=(end_y(k)-benchmark_y)/7500;
   begin_x(k)=(begin_x(k)-benchmark_x)/7500;
   begin_y(k)=(begin_y(k)-benchmark_y)/7500;

end
a=begin_x;
b=begin_y;
c=end_x;
d=end_y;
%     figure, hold on
%     for k = 1:length(lines)
%         xy = [a(k) b(k);c(k) d(k)];
%         plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
%         axis equal;
%     end
end


%% drawing 2: abstract art
% function [a,b,c,d]=ur5_creative()
% I  = imread('test2.jpg');
%I = rgb2gray(RGB);
% BW = edge(I,'canny');
% [H,T,R] = hough(BW);
% P  = houghpeaks(H,18,'threshold',ceil(0.1*max(H(:))));
% lines = houghlines(BW,T,R,P,'FillGap',30,'MinLength',60);
%  %figure, imshow(I), hold on
% 
% benchmark_x = lines(1).point1(1);
% benchmark_y = lines(1).point1(2);
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%  %   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    begin_x(k)=xy(1,1);
%    begin_y(k)=xy(1,2);
%    end_x(k)=xy(2,1);
%    end_y(k)=xy(2,2);
%    
%    end_x(k)=(end_x(k)-benchmark_x)/3000;
%    end_y(k)=(end_y(k)-benchmark_y)/3000;
%    begin_x(k)=(begin_x(k)-benchmark_x)/3000;
%    begin_y(k)=(begin_y(k)-benchmark_y)/3000;
% 
% end
% a=begin_x;
% b=begin_y;
% c=end_x;
% d=end_y;
% %     figure, hold on
% %     for k = 1:length(lines)
% %         xy = [a(k) b(k);c(k) d(k)];
% %         plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
% %         axis equal;
% %     end
% end