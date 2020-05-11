function  PowerTransmit1 =PowerControl1(a,b,Pmin,Pmax,Pm)
x=a*Pm+b;
table=[Pmax,Pmin,x];
PowerTransmit1=median(table);
%PowerTransmit1= max(min(a*Pm+b,Pmax),Pmin);
end
