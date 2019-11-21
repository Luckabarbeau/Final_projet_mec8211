%% mod�lisation du swirl pot
clear all; close all
load('baseline2020results_damping.mat')
RPM=data{89}.Values
power=data{32}.Values
car_speed=data{91}.Values

m_vap=0;
m_dot=0.6;
P=101300 ;
T_in=20;
Q_out=10;
i=1;
% m_dot_out_s=m_dot;
V_specific=0.001043;
T_out=20;
temp_max=50
alpha= 0.001;%1.43e-7; %water conduction




%Volume pour eau Composante m^3
dv=0.00001;
Volume_m=0.0007;
Volume_tube_1=0.0001;
Volume_swirl=0;
Volume_tube_2=0.0001;
Volume_rad=0.0009;
Volume_tube_3=0.0001;
Volume_total=Volume_m+Volume_tube_1+Volume_swirl+Volume_tube_2+Volume_rad+Volume_tube_3;

sections=[Volume_m Volume_m+Volume_tube_1 Volume_m+Volume_tube_1+Volume_swirl Volume_m+Volume_tube_1+Volume_swirl+Volume_tube_2 Volume_m+Volume_tube_1+Volume_swirl+Volume_tube_2+Volume_rad Volume_m+Volume_tube_1+Volume_swirl+Volume_tube_2+Volume_rad+Volume_tube_3];


%Discretisation 
dt=0.01;

V=linspace(0,Volume_total,Volume_total/dv+1)
V(end)=[];
T=ones(length(V),1)*T_in;
X=zeros(length(V),1);
Volume_swirl=dv
T_2=T;
time=0
P3=P;
T3=[T]
V2=V;
V3=V';
X_2=X;
V_out=ones(length(V),1)*V_specific;
V_out2=V_out;
C_M=conduction_matrix(V,dv)*alpha;
I=eye(length(V));


ratio_heat_power=2/3;

figure(1)
figure(2)

for convergence=1:3
    if i~=1
        dv=dv/2;
    end
    
    V=linspace(0,Volume_total,Volume_total/dv+1)
    V(end)=[];
    T=ones(length(V),1)*T_in;
    X=zeros(length(V),1);
    Volume_swirl=dv
    T_2=T;
    time=0
    P3=P;
    T3=[T]
    V2=V;
    V3=V';
    X_2=X;
    V_out=ones(length(V),1)*V_specific;
    V_out2=V_out;
    C_M=conduction_matrix(V,dv)*alpha;
    I=eye(length(V));
    
    for t=0:dt:temp_max
        Q_in=interp1(power.Time,power.Data,mod(t,max(RPM.Time)),'makima')*ratio_heat_power;
        m_dot_in=1.140e-04*interp1(RPM.Time,RPM.Data,mod(t,max(RPM.Time)),'makima') - 5.895e-02;
        vitesse=interp1(car_speed.Time,car_speed.Data,mod(t,max(RPM.Time)),'makima');
        %     P2=P;
        %     m_vap2=m_vap;
        %resolution swirl
        courant_number=V_specific*m_dot_in*dt/dv;
        cell_in_swirl=find(V>=(Volume_tube_1+Volume_m)& V<(Volume_tube_1+Volume_m+Volume_swirl));
        if isempty(cell_in_swirl)
            cell_in_swirl=find(V>=(Volume_tube_1+Volume_m-dv/10)& V<=(Volume_tube_1+Volume_m+Volume_swirl));
            if isempty(cell_in_swirl)
                error('Time_step_to big')
            else
                [P2,T_2(cell_in_swirl),m_vap2,m_dot_out]=swirlpot(m_dot_in,X(cell_in_swirl),P,T(cell_in_swirl),Q_out,m_vap,dt);
                X_2(cell_in_swirl)=0;
                V2(cell_in_swirl)=V(cell_in_swirl)+V_specific*m_dot_in*dt;
            end
        else
            
            [P2,T_2(cell_in_swirl),m_vap2,m_dot_out]=swirlpot(m_dot_in,X(cell_in_swirl),P,T(cell_in_swirl),Q_out,m_vap,dt);
            X_2(cell_in_swirl)=0;
            V2(cell_in_swirl)=V(cell_in_swirl)+V_specific*m_dot_in*dt;
        end
        
        m_dot_out=m_dot_in; % perte de masse negligable
        for i=1:length(T)
            if V(i)<Volume_m
                %Moteur
                
                [T_2(i),X_2(i)]=moteur(m_dot_in,P,T(i),Q_in/(Volume_m/(V_specific*m_dot_in*dt)));
                V2(i)=V(i)+V_specific*m_dot_in*dt;
                if V2(i)<Volume_m
                else
                    T_2(i)=(1-(V2(i)-Volume_m)/(V2(i)-V(i)))*(T_2(i)-T(i))+T(i);
                    X_2(i)=(1-(V2(i)-Volume_m)/(V2(i)-V(i)))*(X_2(i)-X(i))+X(i);
                end
                
            elseif V(i)>=Volume_m & V(i)<(Volume_tube_1+Volume_m)
                %Tube1
                T_2(i)=T(i);
                X_2(i)=X(i);
                V2(i)=V(i)+V_specific*m_dot_in*dt;
            elseif V(i)>=(Volume_tube_1+Volume_m+Volume_swirl) & V(i)<(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2)
                %Tube 2
                T_2(i)=T(i);
                X_2(i)=X(i);
                V2(i)=V(i)+V_specific*m_dot_in*dt;
                Vmax=(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2);
                if V2(i)<(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2)
                else
                    T_2(i)=rad(m_dot_in,P,T(i),T_out,V_specific,Volume_rad,dt*(V2(i)-Vmax)/(V2(i)-V(i)),vitesse);
                end
                
            elseif V(i)>=(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2) & V(i)<(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2+Volume_rad)
                %rad
                T_2(i)=rad(m_dot_in,P,T(i),T_out,V_specific,Volume_rad,dt,vitesse);
                X_2(i)=X(i);
                V2(i)=V(i)+V_specific*m_dot_in*dt;
                Vmax=(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2+Volume_rad);
                if V2(i)<(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2+Volume_rad)
                else
                    T_2(i)=rad(m_dot_in,P,T(i),T_out,V_specific,Volume_rad,dt*(1-(V2(i)-Vmax)/(V2(i)-V(i))),vitesse);
                end
                
            elseif V(i)>=(Volume_tube_1+Volume_m+Volume_swirl+Volume_tube_2+Volume_rad)
                %tube3
                T_2(i)=T(i);
                X_2(i)=X(i);
                V2(i)=V(i)+V_specific*m_dot_in*dt;
                
                if V2(i)<Volume_total
                else
                    [T_2(i),X_2(i)]=moteur(m_dot_in,P,T(i),Q_in/(Volume_m/(V_specific*m_dot_in*(dt*(V2(i)-Volume_total)/(V2(i)-V(i))))));
                end
                
            end
        end
        T3=[T3 T_2];
        T=T_2;
        X=X_2;
        V=V2;
        V3=[V3 V'];
        P3(length(P3)+1,1)=P;
        m_vap=m_vap2;
        P=P2;
        V_out=V_out2;
        time=[time t];
        V(V>Volume_total)=V(V>Volume_total)-Volume_total;
        disp('time solved')
        disp(t)
        %     disp('volume displacement')
        %     disp(V_specific*m_dot_in*dt)
        hold off
        
        %Conduction in water
        
        T=(I/dt-C_M)\(T/dt);
        
        %check degazeur
        select=V>(Volume_tube_1+Volume_m+Volume_swirl+dv);
        check_degaz=find(X(select)~=0);
        if isempty(check_degaz)==1
        else
            disp('degaz_not_respected')
            error('degazage non respecte')
        end
        %     if V(17)-V(16)~=dv
        %         disp('here');
        %     end
        
        
        %     if mod(t,2)==0
        %         z3 = ones(size(V(:)));
        %         figure(1)
        %     color_line3(V(:)',z3,X(:)',X(:)','LineWidth',4);
        %
        %     colorbar;
        %     figure(2)
        %     plot(V(1),T(1));
        %     hold on
        %     z2 = zeros(size(V(:)));
        %
        %     color_line3(V(:)',z2,T(:)',T(:)','LineWidth',4);
        %
        %     plot([sections(1) sections(1)],[-1 1])
        %     plot([sections(2) sections(2)],[-1 1])
        %     plot([sections(3) sections(3)],[-1 1])
        %     plot([sections(4) sections(4)],[-1 1])
        %     plot([sections(5) sections(5)],[-1 1])
        %     plot([sections(6) sections(6)],[-1 1])
        %     xlim([0 Volume_total]);
        %     colorbar;
        %     ylim([-1 1]);
        %     pause(0.01);
        %     end
    end
    
    T_final(convergence)=(mean(T));
    T_error(convergence)=abs(mean(T)-71.375630660228140);
    delta_t(convergence)=dt;
    delta_v(convergence)=dv;
    figure(3)
    hold on
    plot(time,mean(T3))
    pause(0.1)
end

delta_v(convergence)=dv
% T_exact_approx=71.375630660228140;
approximate_order=polyfit(log(delta_v),log(T_error),1)
ordre_approx=log((T_final(3)-T_final(2))/(T_final(2)-T_final(1)))/log(0.5);