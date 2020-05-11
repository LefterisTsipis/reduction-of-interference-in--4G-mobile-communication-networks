function[SNR]=SNR_calculation(transmit_power_from_Macro,N)
SNR=transmit_power_from_Macro-N;
%SINR=transmit_power_from_Macro/transmit_power_from_Femto+N
%SINR=10*log10(SINR1)
end

