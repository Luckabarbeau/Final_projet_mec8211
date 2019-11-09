function C_M=conduction_matrix(V,dv)
C_M=zeros(length(V));
for i=1:length(V)
    if i==1
    C_M(i,i)=-2/dv;
    C_M(i,i+1)=1/dv;
    C_M(i,length(V))=1/dv;
    elseif i==length(V)
    C_M(i,i)=-2/dv;
    C_M(i,i-1)=1/dv;
    C_M(i,1)=1/dv;
    else
    C_M(i,i)=-2/dv;
    C_M(i,i+1)=1/dv;
    C_M(i,i-1)=1/dv;
    end
end
end
