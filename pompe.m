function debit_m = pompe(debit_pompe, rpm, rho)
% debit_pompe est une table qui contient le debit de la pompe en fonction
% du rpm du moteur

debit_v = interp1(debit_pompe.rpm, debit_pompe.debit, rpm);
debit_m = debit_v / rho;

end

