function DataRate=DataRate_calculation(SINR)


if (SINR<0)
    DataRate=0;
elseif (SINR>= 0) &&  (SINR<=1.6)
    DataRate=298.963;
elseif (SINR> 1.6) &&  (SINR<=3.5)
    DataRate=398.617;
elseif (SINR> 3.5) &&  (SINR<=5.6)
    DataRate=478.341;
elseif (SINR> 5.6) &&  (SINR<=7)
    DataRate=597.926;
elseif (SINR> 7)   &&  (SINR<=10.7)
    DataRate=797.235;
elseif (SINR> 10.7) &&  (SINR<=11.8)
    DataRate=956.682;
elseif (SINR> 11.8) &&  (SINR<=14.3)
    DataRate=1196 ;
elseif (SINR> 14.3) &&  (SINR<=16.1)
    DataRate=1345 ;
else
    DataRate=1435 ;


    end
end
