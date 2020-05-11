function  PowerTransmit2 =PowerControl2(Pmax,Pmin,PHUE_Received,X,PL)
table1=PHUE_Received+X+PL;
table=[Pmax,Pmin,table1];
 PowerTransmit2=median(table);

end
