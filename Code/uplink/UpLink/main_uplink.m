

%***************personal information**************************************
%             %Name            : Lefteris
%             %SurName         : Tsiphs
%             %UserName         : icsd12189
%             %Email            : icsd12189@icsd.aegean.gr
%             %My thesis theme : " interference study on heterogeneous networks"    
%
%************************************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-----MUE-----------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MUE.x=250;% x coordinate
MUE.y=230;% y coordinate
MUE.MAX_Power_Trasmit=23;%dBm

%%%%%%%%%%%%%%%%%%%%%%%%%%----MeNB------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MeNB(1).x=250;% x coordinate
MeNB(1).y=250;% y coordinate
MeNB(1).ChannelBandwidth=20;%MHz
MeNB(1).carrier=1.8*10^9;%MHz
MeNB(1).distancefromMUE=Distance(MeNB(1).x,MeNB(1).y,MUE().x,MUE.y);%metre
MeNB(1).receivepowerFromMUE=Power_Receive_From_MUE(MeNB(1).distancefromMUE,MUE.MAX_Power_Trasmit);%dBm

%%%%%%%%%%%%%%%%%%%%%%%%%%----configuration of  20-FeNBs------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x1=100;
s1=100;
s2=200;
s3=100;
s4=200;
s5=100;
for i=1:20
    if(i<=7)%1-7
        FeNB(i).x=x1;% x coordinate
        FeNB(i).y=100;% y coordinate
        FeNB(i).carrier=1.8*10^9;%MHz
        x1=x1+50;
    elseif (i>= 8) &&  (i<=9)%8-9
        x1=s2;
        FeNB(i).x=x1;% x coordinate
        FeNB(i).y=180;% y coordinate
        FeNB(i).carrier=1.8*10^9;%MHz
        s2=s2+100;

     elseif (i>= 10) &&  (i<=11)
        x1=s3;
        FeNB(i).x=x1;% x coordinate
        FeNB(i).y=250;% y coordinate
        FeNB(i).carrier=1.8*10^9;%MHz
        s3=s3+300;
     elseif (i>= 12) &&  (i<=13)
        x1=s4;
        FeNB(i).x=x1;% x coordinate
        FeNB(i).y=320;% y coordinate
        FeNB(i).carrier=1.8*10^9;%MHz
        s4=s4+100;
    else
        x1=s5;
        FeNB(i).x=x1;% x coordinate
        FeNB(i).y=400;% y coordinate
        FeNB(i).carrier=1.8*10^9;%MHz
        s5=s5+50;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%---- configuration of 20-FUEs------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:20
    if(i<=9)%1-7
        FUE(i).x=FeNB(i).x;% x coordinate
        FUE(i).y=FeNB(i).y+10;% y coordinate
        FUE(i).MAX_Power_Trasmit=23 ;%dBm
    elseif (i>= 10) &&  (i<=11)
        FUE(i).x=FeNB(i).x+10;% x coordinate
        FUE(i).y=FeNB(i).y;% y coordinate
        FUE(i).MAX_Power_Trasmit=23;%dBm
    else
      FUE(i).x=FeNB(i).x;% x coordinate
      FUE(i).y=FeNB(i).y-10;% y coordinate
      FUE(i).MAX_Power_Trasmit=23;%dBm
    end
    
end

%%%%%%%%%%%%%%------Noice Parameter--------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Noice_dB= -170; %dBm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%----Distances & power receive calculation ----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 for i=1:20
     FeNB(i).DistanceFromMeNB=round(Distance(MeNB(1).x,MeNB(1).y,FeNB(i).x,FeNB(i).y));%metre
     FeNB(i).DistanceFromMUE=round(Distance(MUE.x,MUE.y,FeNB(i).x,FeNB(i).y));%metre
     MeNB(1).DistanceFromFUE(i)=round(Distance(MeNB(1).x,MeNB(1).y,FUE(i).x,FUE(i).y));%metre
     MeNB(1).receivepowerFromFUEs(i)=round(Power_Receive_From_Inner_FUE(MeNB(1).DistanceFromFUE(i),FUE(i).MAX_Power_Trasmit));%dBm cross tier Interference
     MeNB(1).receivepowerFromFUEs_watt(i)=Power_Receive_watt(MeNB(1).receivepowerFromFUEs(i));%watt
    end
Total_Interference_At_MeNB=sum(MeNB(1).receivepowerFromFUEs_watt);%total Interference in watt
Total_Interference_At_MeNB_dBm=sum(MeNB(1).receivepowerFromFUEs);
Total_Interference_At_MeNB_watt=10^(Total_Interference_At_MeNB_dBm/10)/1000;

%%%%%%%%%%%%%%     INTERFERENCE CALCULATION AT FeNBs (1-20)    %%%%%%%%%%%%%%%%%%%%%%%

for i=1:20
  for j=1:20
       
          if(i~=j)
            FeNB(i).DistanceFromEachFUE(j)=round(Distance(FeNB(i).x,FeNB(i).y,FUE(j).x,FUE(j).y));%metre 
            FeNB(i).InterferenceFromUEs(j)=round(Power_Receive_From_Diferente_House_FUE(FeNB(i).DistanceFromEachFUE(j),FUE(j).MAX_Power_Trasmit));%dBm
            FeNB(i).receivepowerFromUEs_watt(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs(j));%watt
          else
            FeNB(i).InterferenceFromUEs(j)=round(Power_Receive_From_MUE(FeNB(i).DistanceFromMUE,MUE.MAX_Power_Trasmit));%dBm
            FeNB(i).receivepowerFromUEs_watt(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs(j));%watt
            
          end
   end  
end

%%%%%%%%%%%%% receive power from FUE to the server %%%%%%%%%%%%% FeNB%%%%%%%%%%%%%%%%%%%%%%
for i=1:20
 FeNB(i).Distance_From_owner_FUE=round(Distance(FeNB(i).x,FeNB(i).y,FUE(i).x,FUE(i).y));%metre 
 FeNB(i).receive_power_From_owner_FUE=round(Power_Receive_From_FUE(FeNB(i).Distance_From_owner_FUE,FUE(i).MAX_Power_Trasmit));%dBm cross tier Interference
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SINR calculation  At MenB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 MeNB.SINR=SINR_calculation(MeNB(1).receivepowerFromMUE, Total_Interference_At_MeNB,Noice_dB);
 SINR=round(MeNB.SINR)-30;%[dB]
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SINR calculation  At FenB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:20
    Total_Interference_At_FeNB(i)=sum(FeNB(i).receivepowerFromUEs_watt);%total Interference in watt
    FeNB(i).SINR=SINR_calculation(FeNB(i).receive_power_From_owner_FUE, Total_Interference_At_FeNB(i),Noice_dB);
    FeNB_SINR(i)=round(FeNB(i).SINR)-30;%[dB]
  end
 average_SINR_At_Femto=round(mean(FeNB_SINR));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---initialization----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SINR_Current=SINR;
% SINR_Current
SINR_THRESHOLD_QPSK_1=0;
SINR_THRESHOLD_QPSK_2=2;
SINR_THRESHOLD_16QAM_1=4;
SINR_THRESHOLD_16QAM_2=6;
SINR_THRESHOLD_16QAM_3=8;
SINR_THRESHOLD_64QAM1=10;
SINR_THRESHOLD=[0,2,4,6,8,10];
Dp=1;%dBm;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------Power Control 1----- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MeNB.List_With_FUEs_1=[1:20];

for j=1:6
for i=1:20
      FUE(i).Power_Trasmit1(j)=FUE(i).MAX_Power_Trasmit;
end
end

count(1:6)=0;
for k=1:6
    SINR_Current=SINR;
 while SINR_Current <SINR_THRESHOLD(k)
       for i=1:20
              FUE(i).Power_Trasmit1(k)=FUE(i).Power_Trasmit1(k)-Dp;
              MeNB(1).receivepowerFromFUEsPower_Control_1(i)=round(Power_Receive_From_Inner_FUE(MeNB(1).DistanceFromFUE(i),FUE(i).Power_Trasmit1(k)));%dBm cross tier Interference
              MeNB(1).receivepowerFromFUEsPower_Control_1_watt(i)=Power_Receive_watt(  MeNB(1).receivepowerFromFUEsPower_Control_1(i));%watt
      end
 Total_Interference_At_MeNB_Power_Control_1=sum(MeNB(1).receivepowerFromFUEsPower_Control_1_watt);
 MeNB.SINR1=SINR_calculation(MeNB(1).receivepowerFromMUE, Total_Interference_At_MeNB_Power_Control_1,Noice_dB);
 SINR_Power_Control=round(MeNB.SINR1)-30;%[dB]
 SINR_Current=SINR_Power_Control;
 count(k)=count(k)+1;
 end
 Targets_SINR(k)=SINR_Current;
end
 SINR_Current
%  %%%%%% FeNB calculation SINR 
for k=1:6
for i=1:20
  for j=1:20
       
          if(i~=j)
            
            FeNB(i).InterferenceFromUEs_Power_Control_1(j)=round(Power_Receive_From_Diferente_House_FUE(FeNB(i).DistanceFromEachFUE(j),FUE(j).Power_Trasmit1(k)));%dBm
            FeNB(i).receivepowerFromUEs_watt_Power_Control_1(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs_Power_Control_1(j));%watt
          else
            FeNB(i).InterferenceFromUEs_Power_Control_1(j)=round(Power_Receive_From_MUE(FeNB(i).DistanceFromMUE,MUE.MAX_Power_Trasmit));%dBm
            FeNB(i).receivepowerFromUEs_watt_Power_Control_1(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs_Power_Control_1(j));%watt
      
          end
   end  
end

for i=1:20
 FeNB(i).receive_power_From_owner_FUE_Power_Control_1=round(Power_Receive_From_FUE(FeNB(i).Distance_From_owner_FUE,FUE(i).Power_Trasmit1(k)));%dBm cross tier Interference
end 


 for i=1:20
    Total_Interference_At_FeNB_Power_Control_1(i)=sum(FeNB(i).receivepowerFromUEs_watt_Power_Control_1);%total Interference in watt
    FeNB(i).SINR_Power_Control_1=SINR_calculation(FeNB(i).receive_power_From_owner_FUE_Power_Control_1, Total_Interference_At_FeNB_Power_Control_1(i),Noice_dB);
    FeNB_SINR_Power_Control_1(i)=round( FeNB(i).SINR_Power_Control_1)-30;%[dB]
 end
 average_SINR_At_Femto_Power_Control_1(k)=round(mean(FeNB_SINR_Power_Control_1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------Power Control 2----- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count2(1:6)=0;
SINR_Current2=SINR;


for j=1:6
for i=1:20
      FUE(i).Power_Trasmit2(j)=FUE(i).MAX_Power_Trasmit;
      MeNB(1).receivepowerFromFUEsPower_Control_2(i)=round(Power_Receive_From_Inner_FUE(MeNB(1).DistanceFromFUE(i), FUE(i).Power_Trasmit2(j)));%dBm cross tier Interference
      MeNB(1).receivepowerFromFUEsPower_Control_2_watt(i)=Power_Receive_watt(  MeNB(1).receivepowerFromFUEsPower_Control_2(i));%watt
end
end
count2(1:6)=0;

SINR_Current2=SINR;

for k=1:6
    x=median(MeNB.receivepowerFromFUEs);
 while SINR_Current2 <SINR_THRESHOLD(k)
     
      if(count2(k)<= count(k))
         for i=1:20
           if ( MeNB(1).receivepowerFromFUEsPower_Control_2(i)>=x)
           FUE(i).Power_Trasmit2(k)=FUE(i).Power_Trasmit2(k)-Dp;
           else
          FUE(i).Power_Trasmit2(k)= FUE(i).MAX_Power_Trasmit;
           end 
                   
       end
       for i=1:20
            MeNB(1).receivepowerFromFUEsPower_Control_2(i)=round(Power_Receive_From_Inner_FUE(MeNB(1).DistanceFromFUE(i),FUE(i).Power_Trasmit2(k)));%dBm cross tier Interference
            MeNB(1).receivepowerFromFUEsPower_Control_2_watt(i)=Power_Receive_watt(  MeNB(1).receivepowerFromFUEsPower_Control_2(i));%watt
       end
 Total_Interference_At_MeNB_Power_Control_2=sum(MeNB(1).receivepowerFromFUEsPower_Control_2_watt);
 MeNB.SINR2=SINR_calculation(MeNB(1).receivepowerFromMUE, Total_Interference_At_MeNB_Power_Control_2,Noice_dB);
 SINR_Power_Contro2=round(MeNB.SINR2)-30;%[dB]
 SINR_Current2=SINR_Power_Contro2;
 

      end
count2(k)=count2(k)+1;
x=x-1;
%  Dp=Dp+1;
 

 end
 Targets_SINR2(k)=SINR_Current2;
end
 %%%%% FeNB calculation SINR power control 2
for k=1:6
for i=1:20
  for j=1:20
       
          if(i~=j)
            
            FeNB(i).InterferenceFromUEs_Power_Control_2(j)=round(Power_Receive_From_Diferente_House_FUE(FeNB(i).DistanceFromEachFUE(j),FUE(j).Power_Trasmit2(k)));%dBm
            FeNB(i).receivepowerFromUEs_watt_Power_Control_2(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs_Power_Control_2(j));%watt
          else
            FeNB(i).InterferenceFromUEs_Power_Control_2(j)=round(Power_Receive_From_MUE(FeNB(i).DistanceFromMUE,MUE.MAX_Power_Trasmit));%dBm
            FeNB(i).receivepowerFromUEs_watt_Power_Control_2(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs_Power_Control_2(j));%watt
      
          end
   end  
end

for i=1:20
 FeNB(i).receive_power_From_owner_FUE_Power_Control_2=round(Power_Receive_From_FUE(FeNB(i).Distance_From_owner_FUE,FUE(i).Power_Trasmit2(k)));%dBm cross tier Interference
end 


 for i=1:20
    Total_Interference_At_FeNB_Power_Control_2(i)=sum(FeNB(i).receivepowerFromUEs_watt_Power_Control_2);%total Interference in watt
    FeNB(i).SINR_Power_Control_2=SINR_calculation(FeNB(i).receive_power_From_owner_FUE_Power_Control_2, Total_Interference_At_FeNB_Power_Control_2(i),Noice_dB);
    FeNB_SINR_Power_Control_2(i)=round( FeNB(i).SINR_Power_Control_2)-30;%[dB]
 end
 average_SINR_At_Femto_Power_Control_2(k)=round(mean(FeNB_SINR_Power_Control_2));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%--------------Power Control 3----- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x3=median(MeNB.receivepowerFromFUEs);
Dp=1;
for j=1:6
for i=1:20
      FUE(i).Power_Trasmit3(j)=FUE(i).MAX_Power_Trasmit;
      MeNB(1).receivepowerFromFUEsPower_Control_3(i)=round(Power_Receive_From_Inner_FUE(MeNB(1).DistanceFromFUE(i), FUE(i).Power_Trasmit3(j)));%dBm cross tier Interference
      MeNB(1).receivepowerFromFUEsPower_Control_3_watt(i)=Power_Receive_watt(  MeNB(1).receivepowerFromFUEsPower_Control_3(i));%watt
end
end

count3(1:6)=0;

SINR_Current3=SINR;

for k=1:6
    
 while SINR_Current3 <SINR_THRESHOLD(k)
         for i=1:20
           if ( MeNB(1).receivepowerFromFUEsPower_Control_3(i)>=x3)
           FUE(i).Power_Trasmit3(k)=FUE(i).Power_Trasmit3(k)-Dp;
           else
          FUE(i).Power_Trasmit3(k)= FUE(i).MAX_Power_Trasmit;
           end 
                       
       end
       for i=1:20
            MeNB(1).receivepowerFromFUEsPower_Control_3(i)=round(Power_Receive_From_Inner_FUE(MeNB(1).DistanceFromFUE(i),FUE(i).Power_Trasmit3(k)));%dBm cross tier Interference
            MeNB(1).receivepowerFromFUEsPower_Control_3_watt(i)=Power_Receive_watt(  MeNB(1).receivepowerFromFUEsPower_Control_3(i));%watt
       end
 Total_Interference_At_MeNB_Power_Control_3=sum(MeNB(1).receivepowerFromFUEsPower_Control_3_watt);
 MeNB.SINR3=SINR_calculation(MeNB(1).receivepowerFromMUE, Total_Interference_At_MeNB_Power_Control_3,Noice_dB);
 SINR_Power_Contro3=round(MeNB.SINR3)-30;%[dB]
 SINR_Current3=SINR_Power_Contro3;
 count3(k)=count3(k)+1;
count3
x3=x3-1;
Dp=Dp+1;
 

 end
 Targets_SINR3(k)=SINR_Current3;
end
 
 
 %%%%% FeNB calculation SINR power control 2
for k=1:6
for i=1:20
  for j=1:20
       
          if(i~=j)
            
            FeNB(i).InterferenceFromUEs_Power_Control_3(j)=round(Power_Receive_From_Diferente_House_FUE(FeNB(i).DistanceFromEachFUE(j),FUE(j).Power_Trasmit3(k)));%dBm
            FeNB(i).receivepowerFromUEs_watt_Power_Control_3(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs_Power_Control_3(j));%watt
          else
            FeNB(i).InterferenceFromUEs_Power_Control_3(j)=round(Power_Receive_From_MUE(FeNB(i).DistanceFromMUE,MUE.MAX_Power_Trasmit));%dBm
            FeNB(i).receivepowerFromUEs_watt_Power_Control_3(j)=Power_Receive_watt(FeNB(i).InterferenceFromUEs_Power_Control_3(j));%watt
      
          end
   end  
end

for i=1:20
 FeNB(i).receive_power_From_owner_FUE_Power_Control_3=round(Power_Receive_From_FUE(FeNB(i).Distance_From_owner_FUE,FUE(i).Power_Trasmit3(k)));%dBm cross tier Interference
end 


 for i=1:20
    Total_Interference_At_FeNB_Power_Control_3(i)=sum(FeNB(i).receivepowerFromUEs_watt_Power_Control_3);%total Interference in watt
    FeNB(i).SINR_Power_Control_3=SINR_calculation(FeNB(i).receive_power_From_owner_FUE_Power_Control_3, Total_Interference_At_FeNB_Power_Control_3(i),Noice_dB);
    FeNB_SINR_Power_Control_3(i)=round( FeNB(i).SINR_Power_Control_3)-30;%[dB]
 end
 average_SINR_At_Femto_Power_Control_3(k)=round(mean(FeNB_SINR_Power_Control_3));
end

 


%%%%%%%%%%%%%%%%%%%%%%---CHARTS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:6
    SINR_THRESHOLD_WATT(i)=10^(SINR_THRESHOLD(i)/10)
 capacity(i)= 15*10^3*log2(1+SINR_THRESHOLD_WATT(i))
end


for i=1:6
 capacity(i)= 15*10^3*log2(1+SINR_THRESHOLD(i))
end


figure(1)%SINR for MUE 

plot(Targets_SINR,average_SINR_At_Femto_Power_Control_1,'-^g',...
             Targets_SINR2,average_SINR_At_Femto_Power_Control_2,'-hy',...
         Targets_SINR3,average_SINR_At_Femto_Power_Control_3,'-sm','LineWidth',1,'MarkerSize',20);
axis([0 7 -6 7]);
title('Average FUE SINR value vs Target SINR ') 
g=legend('Power Control Method 1','Power Control Method 2','Power Control Method 3','fontsize',5);
xlabel('MUE Target SINR (dB)','fontsize',16); % x-axis label
ylabel(' Average FUE SINR(dB)','fontsize',16); % y-axis label
set(g);
set(gca,'FontSize',16);
grid on


figure(2)
plot(Targets_SINR,count,'-^g',...
    Targets_SINR2,count2,'-hy',...
Targets_SINR3,count3,'-sm','LineWidth',1,'MarkerSize',20);
axis([Targets_SINR(1) 10 1 20]);
title('Average iteration times vs Target SINR')
xlabel('MUE Target SINR (dB)','fontsize',16); % x-axis label
ylabel('Average iteration time)','fontsize',16); % y-axis label
h=legend('Power Control Method 1','Power Control Method 2','Power Control Method 3','fontsize',5);
set(gca,'FontSize',16);
grid on
set(h)


figure(3)
plot(Targets_SINR, capacity,'-sm','LineWidth',1,'MarkerSize',20);
title('capacity of the channel')
xlabel('MUE Target SINR (dB)','fontsize',16); % x-axis label
ylabel(' capacity','fontsize',16); % y-axis label
