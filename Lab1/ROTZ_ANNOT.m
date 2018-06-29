function ROTZ_ANNOT()
% ROTZ annotation
clear all;
%  a
figure(1);
plotr(eye(3));
hold on;
plotr(ROTZ(pi/3));
title ('PLOTR:ROTZ(pi/3)');

%  b
figure(2);
hold on;
for i = 1:10
a(1,i)=i;
a(2,i)=0;
a(3,i)=1;
plotp3(a(:,i));
b(:,i)=ROTZ(pi/3)*a(:,i);
plotp3(b(:,i),'r.-');
title ('PLOTP3:ROTZ(pi/3)');
xlabel('x');
ylabel('y');
zlabel('z');
end
legend('original points','rotated points');

%  c
figure(3);
hold on;
for i = 1:10
c(1,i)=i;
c(2,i)=0;
c(3,i)=1;
c(4,i)=1;
plotp4(c(:,i),'g*');
H = [ROTZ(pi/3),[0;0;0];0 0 0 1];
d(:,i)=H *c(:,i);
plotp4(d(:,i),'b.-');
title ('PLOTP4:ROTZ(pi/3)');
xlabel('x');
ylabel('y');
zlabel('z');
end
legend('original points','rotated points');

%  d
figure(4);
hold on;
for i = 10:30
a1(:,i) = [0,10,i]';
a2(:,i) = [0,0,20]';
plotv3(a1(:,i),a2(:,i));
b1(:,i)=ROTZ(pi/3)*a1(:,i);
b2(:,i)=ROTZ(pi/3)*a2(:,i);
plotv3(b1(:,i),b2(:,i),'r.-');
title ('PLOTV3:ROTZ(pi/3)');
xlabel('x');
ylabel('y');
zlabel('z');
end
legend('original vector','rotated vector');

%  e
figure(5);
hold on;
for i = 10:30
c1(:,i) = [0,10,i,0]';
c2(:,i) = [0,0,20,0]';
plotv4(c1(:,i),c2(:,i),'g:');
H = [ROTZ(pi/3),[0;0;0];0 0 0 1];
d1(:,i)=H*c1(:,i);
d2(:,i)=H*c2(:,i);
plotv4(d1(:,i),d2(:,i),'b.-');
title ('PLOTV4:ROTZ(pi/3)');
xlabel('x');
ylabel('y');
zlabel('z');
end
legend('original vector','rotated vector');

%  f
figure(6);
plotf([eye(3),[0;0;0];0 0 0 1]);
hold on;
new_M = ROTZ(pi/6) * eye(3);
plotf([new_M,[0;0;0];0 0 0 1]);
title ('PLOTF:ROTZ(pi/6)');