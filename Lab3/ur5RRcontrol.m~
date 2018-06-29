function ur5RRcontrol(ur5,gdesired,K)
T=0.5;
q=ur5.get_current_joints();
ginv=inv(gdesired);
Frame_desire = tf_frame('base_link', 'Frame_desire', gdesired);
a=5;
b=15;
while (a>0.01) 
    J=ur5BodyJacobian(q);
    g=ur5FwdKin(q);
    xi=getXi(ginv*g);
    q=q-K*T*inv(J)*xi;
    if abs(det(J))<0.01
        a=0;
        b=0;
    else
        ur5.move_joints(q,2);
        pause(2);
        a=norm(xi(1:3,1));
        b=norm(xi(4:6,1));
    end
  
end
a
b
end