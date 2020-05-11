function  PowerTransmit4 =PowerControl4(a,b,Pmin,Pmax,PSINR)
c=a*PSINR+b;
table1=[Pmax,Pmin,c];
PowerTransmit4= median(table1);
%PowerTransmit4=max(min(a*PSINR+b,Pmax),Pmin);

end