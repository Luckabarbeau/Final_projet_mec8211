function [T,X]=moteur(m_dot_in,P,T,Q_in)
%m_dot_in (kg/s), X(),P(Pa) ,T(C),Q_out(J/s),m_vap(kg),dt(s)
V=0.0001 ;% Volume d'air dans le swirl pot
R=8.31446261815324; %J?K?1?mol?1
mol_mass=0.01801528; %kg/mol;
R_s=R/mol_mass;
energie_intern_liquide=4.1902;

T_sat=-0.000195968466514*(P/1000)^2 + 0.246416211515595*(P/1000) + 77.628149366962575;
Energie_evap=-3.1017*T_sat + 2397.2;%kj/kg

delta_t=Q_in/(energie_intern_liquide*1000)/m_dot_in;
if (T+delta_t)>T_sat
    T=T_sat;
    Energie_to_evap=Q_in-(T_sat-T)*m_dot_in*(energie_intern_liquide*1000);
    X=Energie_to_evap/m_dot_in/(Energie_evap*1000);
else
    X=0;
    T=T+delta_t;
end



end