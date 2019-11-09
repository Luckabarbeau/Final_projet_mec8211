function [T]=rad(m_dot_in,P,T,T_out,V_specific,Volume_rad,dt)
%m_dot_in (kg/s), X(),P(Pa) ,T(C),Q_out(J/s),m_vap(kg),dt(s)
V=0.0001 ;% Volume d'air dans le swirl pot
R=8.31446261815324; %J?K?1?mol?1
mol_mass=0.01801528; %kg/mol;
energie_intern_liquide=4.1902;
R_s=R/mol_mass;
H=100;
Q_out=(T-T_out)*H;

energie_cool_liquid=Q_out/(Volume_rad/(V_specific*m_dot_in*dt));
% energie_cool_liquide_by_k=1.485+(P/1000)*0.0003584;%kj/kg/k
delta_t=energie_cool_liquid/(energie_intern_liquide*1000)/m_dot_in;
T=T-delta_t;
if delta_t<0
    disp(delta_t);
end

end