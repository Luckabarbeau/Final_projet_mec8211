% V�rification des code de sous section

m_vap=0;
m_dot=0.6;
P=101300 ;
T_in=20;
Q_out=10;
i=1;
m_dot_out_s=m_dot;
V_specific=0.001043;
T_out=20;
temp_max=200
alpha=	1.43e-7; %water conduction
energie_intern_liquide=4.1902;
vitesse=15

Volume_m=0.0007;
Volume_rad=0.0009;
T_in_rad=50;

dt=0.1

%Verification moteur
% on suit une seul particule d'eau

Q_in_moteur=100000;
V=0
T=T_in
X=0
while V<Volume_m+Volume_m/10
    if V<Volume_m
        [T_2,X_2]=moteur(m_dot,P,T,Q_in_moteur/(Volume_m/(V_specific*m_dot*dt)));
    end
    V_2=V+V_specific*m_dot*dt;
    
    if V_2<Volume_m
    else
        T_2(i)=(1-(V_2-Volume_m)/(V_2-V))*(T_2-T)+T;
        X_2(i)=(1-(V_2-Volume_m)/(V_2-V))*(X_2-X)+X;
    end
    T=T_2;
    V=V_2;
    X=X_2;
end

T_out_exact=T_in+Q_in_moteur/(m_dot*energie_intern_liquide*1000);
E_moteur=T-T_out_exact;




%%% verification

for i=1:5
    if i~=1
        dt=dt/2;
    end
    T=T_in_rad;
    V=0;
while V<Volume_rad+Volume_rad/10
    if V<Volume_rad
        [T_2]=rad(m_dot,P,T,T_out,V_specific,Volume_rad,dt,vitesse);
    end
    V_2=V+V_specific*m_dot*dt;
    
    if V_2<Volume_rad
    else
        T_2=(1-(V_2-Volume_rad)/(V_2-V))*(T_2-T)+T;
    end
    T=T_2;
    V=V_2;
end
C1=T_in_rad-T_out;
T_out_exact=T_out+C1*exp(-(7.0757*vitesse  - 1.2056)/m_dot/energie_intern_liquide/1000*Volume_rad/Volume_rad);
delta_t(i)=dt;
E_rad(i)=T-T_out_exact;
end

numerical_order_rad=polyfit(log(delta_t),log(abs(E_rad)),1);

%verification du degazeur 





