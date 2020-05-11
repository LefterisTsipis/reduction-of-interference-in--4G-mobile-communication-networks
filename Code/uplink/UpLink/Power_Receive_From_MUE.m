function PowerReceive=Power_Receive_From_MUE(Distance,power_trannsmit)

PL=15.3 + 37.6*log10(Distance);%dB
PowerReceive= power_trannsmit-PL;%dBm

end