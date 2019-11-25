% Vérification des code de sous section
clear all

m_vap=0;
m_dot=0.6;
P=101420 ;
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
H_speed=7.0178;
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
        [T_2,X_2]=moteur(m_dot,P,T,X,Q_in_moteur/(Volume_m/(V_specific*m_dot*dt)));
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

%Verification moteur vapeur
% on suit une seul particule d'eau
T_in=100;
Q_in_moteur=100000;
V=0
T=T_in
X=0
while V<Volume_m+Volume_m/10
    if V<Volume_m
        [T_2,X_2]=moteur(m_dot,P,T,X,Q_in_moteur/(Volume_m/(V_specific*m_dot*dt)));
    end
    V_2=V+V_specific*m_dot*dt;
    
    if V_2<Volume_m
    else
        T_2=(1-(V_2-Volume_m)/(V_2-V))*(T_2-T)+T;
        X_2=(1-(V_2-Volume_m)/(V_2-V))*(X_2-X)+X;
    end
    T=T_2;
    V=V_2;
    X=X_2;
end


% suppose présence de vapeur
T_out_exact=-0.000195968466514*(P/1000)^2 + 0.246416211515595*(P/1000) + 77.628149366962575;
Energie_evap=-3.1017*T_out_exact + 2397.2;
X_exact=(Q_in_moteur-(T_out_exact-T_in)*energie_intern_liquide*1000*m_dot)/m_dot/(Energie_evap*1000);

E_moteur=T-T_out_exact;
E_X_moteur=X-X_exact;
R=X/X_exact;





%%% verification rad
T_in=20
for i=1:5
    if i~=1
        dt=dt/2;
    end
    T=T_in_rad;
    V=0;
while V<Volume_rad+Volume_rad/10
    if V<Volume_rad
        [T_2]=rad(m_dot,P,T,T_out,V_specific,Volume_rad,dt,vitesse,H_speed);
    end
    V_2=V+V_specific*m_dot*dt;
    
    if V_2<Volume_rad
    else
        T_2=(1-(V_2-Volume_rad)/(V_2-V))*(T_2-T)+T;
        dt_2=(1-(V_2-Volume_rad)/(V_2-V))*dt
        if V<Volume_rad
        T_2=rad(m_dot,P,T,T_out,V_specific,Volume_rad,dt_2,vitesse,H_speed)
        end
    end
    T=T_2;
    V=V_2;
end
C1=T_in_rad-T_out;
T_out_exact=T_out+C1*exp(-(7.0178*vitesse)/m_dot/energie_intern_liquide/1000*Volume_rad/Volume_rad);
delta_t(i)=dt;
E_rad(i)=T-T_out_exact;
end
plot(log(delta_t),log(abs(E_rad)))
xlabel('ln(dt)')
numerical_order_rad=polyfit(log(delta_t),log(abs(E_rad)),1);

%verification du degazeur 






