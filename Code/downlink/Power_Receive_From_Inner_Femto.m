function PowerReceiveFromFemto=Power_Receive_From_Inner_Femto(Distance,power_trannsmit)
%power_trannsmit_dBm=10*log10(power_trannsmit);
%PowerReceive=power_trannsmit*((3*10^8)/((carrier)*4*3.14*Distance))^2
%l=(3*10^8)/carrier
%PowerReceive= power_trannsmit-21.98+20*log10(l)-20*log10(Distance)
PL=(38.46 + 20 *log10(Distance)+10);%dB
PowerReceiveFromFemto= power_trannsmit-PL;%dBm

end
