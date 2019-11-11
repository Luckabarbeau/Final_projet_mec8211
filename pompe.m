function debit = pompe(debit_pompe, rpm)
% debit_pompe est une table qui contient le debit de la pompe en fonction
% du rpm du moteur

debit = interp1(debit_pompe.rpm, debit_pompe.debit, rpm);

end

