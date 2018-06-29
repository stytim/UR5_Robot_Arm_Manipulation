function xi=getXi(g)
R=g(1:3,1:3);
p=g(1:3,4);
theta=acos((trace(R)-1)/2);
if mod(theta,2*pi)==0
    w=[0 0 0]';
    v=p;
    xi=[v;w];
else
    w1=[(R(3,2)-R(2,3))]/(2*sin(theta));
    w2=[(R(1,3)-R(3,1))]/(2*sin(theta));
    w3=[(R(2,1)-R(1,2))]/(2*sin(theta));
    w=[w1;w2;w3];
    what=[0 -w(3) w(2);w(3) 0 -w(1);-w(2) w(1) 0];
    A=(eye(3)-R)*what+w*w'*theta;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    v=inv(A)*p;
    xi=[v;w]*theta;
end