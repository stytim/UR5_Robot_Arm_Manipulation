function gst = ur5FwdKin(q)
% input: joints is 6*1 vector where joints (i) correspond to joint i in
% gazebo setting.
[rows, cols] = size(q);
if ((rows ~= 6) | (cols ~= 1))
  error('ur5FwdKin requires a 6x1 argument. Please check your dimensions.');
end
% output: gst is 4*4 transformation matrix relative to base_link
%% define links and xi
L1 = 0.425;
L2 = 0.392;
L3 = 0.1093;
L4 = 0.09475;
L5 = 0.0825;
L0 = 0.0892;
e1 = [1; 0; 0];
e2 = [0; 1; 0];
e3 = [0; 0; 1];
e1_hat = [0 0 0; 0 0 -1; 0 1 0];
e2_hat = [0 0 1; 0 0 0; -1 0 0];
e3_hat = [0 -1 0; 1 0 0; 0 0 0];
w1 = e3;
w2 = e2;
w3 = e2;
w4 = e2;
w5 = e3;
w6 = e2;
q1 = [0;0;0];
q2 = [0;0;L0];
q3 = [0;0;L1+L0];
q4 = [0;0;L1+L2+L0];
q5 = [0;L3;0];
q6 = [0;0;L1+L2+L4+L0];
the1 = q(1);
the2 = q(2)+pi/2;
the3 = q(3);
the4 = q(4)+pi/2;
the5 = q(5);
the6 = q(6);
xi1 = [e3_hat, -cross(w1,q1); 0 0 0 0];
xi2 = [e2_hat, -cross(w2,q2); 0 0 0 0];
xi3 = [e2_hat, -cross(w3,q3); 0 0 0 0];
xi4 = [e2_hat, -cross(w4,q4); 0 0 0 0];
xi5 = [e3_hat, -cross(w5,q5); 0 0 0 0];
xi6 = [e2_hat, -cross(w6,q6); 0 0 0 0];
g01 = expm(the1 * xi1);
g12 = expm(the2 * xi2); 
g23 = expm(the3 * xi3);
g34 = expm(the4 * xi4); 
g45 = expm(the5 * xi5);
g56 = expm(the6 * xi6); 
%% POE formula to calculate gst
gst0 = [0 -1 0 0; 1 0 0 L3+L5; 0 0 1 L1+L2+L4+L0; 0 0 0 1];
gst = g01*g12*g23*g34*g45*g56*gst0;
end
