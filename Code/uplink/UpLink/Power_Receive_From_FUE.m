function PowerReceive=Power_Receive_From_FUE(Distance,power_trannsmit)

PL=38.46+20*log10(Distance);
PowerReceive= power_trannsmit-PL;%dBm

end