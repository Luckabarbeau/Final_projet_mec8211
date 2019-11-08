function [P,T,m_vap,m_dot_out]=swirlpot(m_dot_in,X,P,T,Q_out,m_vap,dt)
%m_dot_in (kg/s), X(),P(Pa) ,T(C),Q_out(J/s),m_vap(kg),dt(s)
V=0.0001; % Volume d'air dans le swirl pot
R=8.31446261815324; %J?K?1?mol?1
mol_mass=0.01801528; %kg/mol;
R_s=R/mol_mass;
Pinitial=101300 ;%Pa Air sec
T_initial=20 ;% celcius
energie_intern_liquide=4.1902;
%hypothese toute l'energie perdu est perdu par la vapeur et permet la
%recondansation
Energie_evap=-3.1017*T + 2397.2;%kj/kg

m_vap_dot=m_dot_in*X*dt;


m_vap=m_vap+m_vap_dot-Q_out*dt/(Energie_evap*1000);
if m_vap<0
    energie_cool_liquid=-Energie_evap*1000*m_vap;
    m_vap=0;
else
    energie_cool_liquid=0;
end
% energie_cool_liquide_by_k=1.485+(P/1000)*0.0003584;%kj/kg/k
delta_t=energie_cool_liquid/(energie_intern_liquide*1000)/m_dot_in*(1-X);
T=T-delta_t;


P_vap=m_vap*R_s*(T+273.15)/V;
P=Pinitial*(T+273.15)/(T_initial+273.15)+P_vap;
m_dot_out=m_dot_in-(m_vap_dot*dt-Q_out/(Energie_evap*1000));
end