function J = ur5BodyJacobian(q)
[rows, cols] = size(q);
if ((rows ~= 6) | (cols ~= 1))
  error('ur5BodyJacobian requires a 6x1 argument. Please check your dimensions.');
end
%% define angles and axis
L1 = 0.425;
L2 = 0.392;
L3 = 0.1093;
L4 = 0.09475;
L5 = 0.0825;
L0 = 0.0892;
the1 = q(1);
the2 = q(2)+pi/2;
the3 = q(3);
the4 = q(4)+pi/2;
the5 = q(5);
the6 = q(6);
e1 = [1; 0; 0];
e2 = [0; 1; 0];
e3 = [0; 0; 1];
%% calculate each intantaneous twist
w1 = e3;
q1 = [0;0;0];
w2 = expm(vec2skew(e3)*the1)*e2;
q2 = [0;0;L0];
w3 = expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*e2;
q3 = q2 + expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*[0;0;L1];
w4 = expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*expm(vec2skew(e2)*the3)*e2;
q4 = q3 + expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*expm(vec2skew(e2)*the3)*[0;0;L2];
w5 = expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*expm(vec2skew(e2)*the3)*expm(vec2skew(e2)*the4)*e3;
q5 = q4 + expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*expm(vec2skew(e2)*the3)*expm(vec2skew(e2)*the4)*[0;L3;0];
w6 = expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*expm(vec2skew(e2)*the3)*expm(vec2skew(e2)*the4)*expm(vec2skew(e3)*the5)*e2;
q6 = q5 + expm(vec2skew(e3)*the1)*expm(vec2skew(e2)*the2)*expm(vec2skew(e2)*the3)*expm(vec2skew(e2)*the4)*expm(vec2skew(e3)*the5)*[0;L5;L4];
%% calculate the manipulator body Jacobian
J_s = [-cross(w1,q1) -cross(w2,q2) -cross(w3,q3) -cross(w4,q4) -cross(w5,q5) -cross(w6,q6);
       w1 w2 w3 w4 w5 w6];
g = ur5FwdKin(q);
g_inv = [g(1:3,1:3)' -g(1:3,1:3)'*g(1:3,4); 0 0 0 1];
J = Ad(g_inv)*J_s;
end

function m = Ad(g)
R = g(1:3,1:3);
p = g(1:3,4);
m = [R vec2skew(p)*R; eye(3)-eye(3) R];
end