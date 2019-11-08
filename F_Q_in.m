function Q = F_Q_in(t)
%F_Q_IN Summary of this function goes here
%   Detailed explanation goes here

    if t<100
     Q=10000;
     Q=20000*(sin(t)+1);
    else
     Q=0;
    end

end

