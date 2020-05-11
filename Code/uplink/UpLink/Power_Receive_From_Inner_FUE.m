function PowerReceive=Power_Receive_From_Inner_FUE(Distance,power_trannsmit)

PL=15.3+37.6*log10(Distance)+10;
PowerReceive= power_trannsmit-PL;%dBm

end 