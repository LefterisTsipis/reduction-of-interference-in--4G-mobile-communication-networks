

%***************personal information**************************************
%             %Name            : Lefteris
%             %SurName         : Tsiphs
%             %UserName         : icsd12189
%             %Email            : icsd12189@icsd.aegean.gr
%             %My thesis theme : " interference study on heterogeneous networks"    
%
%************************************************************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%----MeNB------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MeNB.x=100;% x coordinate
MeNB.y=400;% y coordinate
MeNB.MAX_Power_Trasmit=48;%dBm
MeNB.ChannelBandwidth=20;%MHz
MeNB.carrier=1.8*10^9;%MHz
%%%%%%%%%%%%%%------Noice Parameter--------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
noise_D = (1.5*10^(-14))*MeNB.carrier;
Noice_dB=-174;%dBm
%%%%%%%%%%%%%%%%%%%%%%%%%%----FeNB------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FeNB.x=300;% x coordinate
FeNB.y=400;% y coordinate
FeNB.MAX_Power_Trasmit=23;%dBm
FeNB.DistanceFromMeNB=Distance(MeNB.x,MeNB.y,FeNB.x,FeNB.y);%metre
FeNB.PowerReceivedFromMeNB=Power_Receive_From_Outer_Macro(FeNB.DistanceFromMeNB,MeNB.MAX_Power_Trasmit);%dBm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-----MUE-----------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MUE.x=10;% x coordinate
MUE.y=380;% y coordinate
MUE.distancefromMacro=Distance(MeNB.x,MeNB.y,MUE.x,MUE.y);%metre
MUE.distancefromFemto=Distance(FeNB.x,FeNB.y,MUE.x,MUE.y);%metre
MUE.receivepowerFromMacro=Power_Receive_From_Macro(MUE.distancefromMacro,MeNB.MAX_Power_Trasmit);%dBm
MUE.receivepowerFromFemto=Power_Receive_From_Inner_Femto(MUE.distancefromFemto,FeNB.MAX_Power_Trasmit);%dBm
MUE.SINR=SINR_calculation(MUE.receivepowerFromMacro,MUE.receivepowerFromFemto,Noice_dB);%dBm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-----------FUE-------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FUE.x=280;% x coordinate
FUE.y=400;% y coordinate
FUE.distancefromMacro=Distance(MeNB.x,MeNB.y,FUE.x,FUE.y);%metre
FUE.distancefromFemto=Distance(FeNB.x,FeNB.y,FUE.x,FUE.y);%metre
FUE.receivepowerFromMacro=Power_Receive_From_Outer_Macro(FUE.distancefromMacro,MeNB.MAX_Power_Trasmit);%dBm
FUE.receivepowerFromFemto=Power_Receive_From_Femto(FUE.distancefromFemto,FeNB.MAX_Power_Trasmit);%dBm
FUE.Interference=Interference_Receive_calculation(FUE.receivepowerFromMacro,Noice_dB);
FUE.SINR=SINR_calculation(FUE.receivepowerFromMacro,FUE.receivepowerFromFemto,Noice_dB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%----Distances And Power Calculation of MUE----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=0:599
    walk_distance(i+1)=MUE.x+i;
    D_F_MeNB(i+1)=Distance(MeNB.x,MeNB.y,walk_distance(i+1),MUE.y);%metre
    P_F_MeNB(i+1)=Power_Receive_From_Macro(D_F_MeNB(i+1),MeNB.MAX_Power_Trasmit);%dBm
    D_F_FeNB(i+1)=Distance(FeNB.x,FeNB.y,walk_distance(i+1),MUE.y);%metre
    D_F_FUE(i+1)=Distance(FUE.x,FUE.y,walk_distance(i+1),MUE.y);%metre
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% No Power Control- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 for i=0:599
     if D_F_FeNB(i+1)<31
                                                                            %(dBm,         dBm,dBm)
          Power_Received_From_Femto0(i+1)=Power_Receive_From_Inner_Femto( D_F_FeNB(i+1),FeNB.MAX_Power_Trasmit);%dBm
          SINR_MUE0(i+1)=SINR_calculation( P_F_MeNB(i+1),Power_Received_From_Femto0(i+1),Noice_dB);%dBm
          SINR_FUE0(i+1)=SINR_calculation(FUE.receivepowerFromFemto,FUE.receivepowerFromMacro,Noice_dB);%dBm
     else
         Power_Received_From_Femto0(i+1)=0;
         SINR_MUE0(i+1)=SNR_calculation( P_F_MeNB(i+1),Noice_dB); %dBm
         SINR_FUE0(i+1)=SINR_calculation(FUE.receivepowerFromFemto,FUE.receivepowerFromMacro,Noice_dB);%dBm
     end
 end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Power Control 1-taking into consideration the received power from MeNB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=0:599
    if D_F_FeNB(i+1)<31
       Power_Transmit_From_Femto1(i+1)=PowerControl1(1,70,10,20,FeNB.PowerReceivedFromMeNB);%dBm
       Power_Received_From_Femto1(i+1)=Power_Receive_From_Inner_Femto( D_F_FeNB(i+1),Power_Transmit_From_Femto1(i+1));%dBm
       SINR_MUE1(i+1)=SINR_calculation( P_F_MeNB(i+1),Power_Received_From_Femto1(i+1),Noice_dB);%dBm
       FUE_Power_Received_From_Femto1(i+1)=Power_Receive_From_Femto( D_F_FeNB(i+1),Power_Transmit_From_Femto1(i+1));%dBm
       SINR_FUE1(i+1)=SINR_calculation(FUE_Power_Received_From_Femto1(i+1),FUE.receivepowerFromMacro,Noice_dB);%dBm
    else
        Power_Transmit_From_Femto1(i+1)=1;%dBm
        Power_Received_From_Femto1(i+1)=0;%dBm
        SINR_MUE1(i+1)=SNR_calculation( P_F_MeNB(i+1),Noice_dB);%dBm
        SINR_FUE1(i+1)=SINR_calculation(FUE.receivepowerFromFemto,FUE.receivepowerFromMacro,Noice_dB);%dBm
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Power Control 2-taking into consideration the received Interference from FUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PL=38.46+20*log10(FUE.distancefromFemto);
for i=0:599
    if D_F_FeNB(i+1)<31
           Power_Transmit_From_Femto2(i+1)=PowerControl2(FeNB.MAX_Power_Trasmit,10,FUE.Interference,-4,PL);%dBm
           Power_Received_From_Femto2(i+1)=Power_Receive_From_Inner_Femto( D_F_FeNB(i+1),Power_Transmit_From_Femto2(i+1));%dBm
           SINR_MUE2(i+1)=SINR_calculation( P_F_MeNB(i+1),Power_Received_From_Femto2(i+1),Noice_dB);%dBm
           FUE_Power_Received_From_Femto2(i+1)=Power_Receive_From_Femto( D_F_FeNB(i+1),Power_Transmit_From_Femto2(i+1));%dBm
           SINR_FUE2(i+1)=SINR_calculation(FUE_Power_Received_From_Femto2(i+1),FUE.receivepowerFromMacro,Noice_dB);%dBm
     else
          Power_Transmit_From_Femto2(i+1)=1;%dBm
          Power_Received_From_Femto2(i+1)=0;%dBm
          SINR_MUE2(i+1)=SNR_calculation( P_F_MeNB(i+1),Noice_dB);%dBm
          SINR_FUE2(i+1)=SINR_calculation(FUE.receivepowerFromFemto,FUE.receivepowerFromMacro,Noice_dB);%dBm
     end
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Power Control 3 By exchanging information (MUE --> HeNB) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PSINR= SINR_MUE0(279);%dBm
for i=0:599
    if D_F_FeNB(i+1)<31
           Power_Transmit_From_Femto4(i+1)=PowerControl1(1,70,10,20,PSINR);%dBm
           Power_Received_From_Femto4(i+1)=Power_Receive_From_Inner_Femto( D_F_FeNB(i+1),Power_Transmit_From_Femto4(i+1));%dBm
           SINR_MUE4(i+1)=SINR_calculation( P_F_MeNB(i+1),Power_Received_From_Femto4(i+1),Noice_dB);%dBm
           FUE_Power_Received_From_Femto4(i+1)=Power_Receive_From_Femto( D_F_FeNB(i+1),Power_Transmit_From_Femto4(i+1));%dBm
           SINR_FUE4(i+1)=SINR_calculation(FUE_Power_Received_From_Femto4(i+1),FUE.receivepowerFromMacro,Noice_dB);%dBm
     else
          Power_Transmit_From_Femto4(i+1)=1;%dBm
          Power_Received_From_Femto4(i+1)=0;
          SINR_MUE4(i+1)=SNR_calculation( P_F_MeNB(i+1),Noice_dB);%dBm
          SINR_FUE4(i+1)=SINR_calculation(FUE.receivepowerFromFemto,FUE.receivepowerFromMacro,Noice_dB);%dBm
     end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%dBm--->dBW %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=0:599
  SINR_MUE0_dBW(i+1)=SINR_MUE0(i+1)-30;
  SINR_MUE1_dBW(i+1)=SINR_MUE1(i+1)-30;
  SINR_MUE2_dBW(i+1)=SINR_MUE2(i+1)-30;
  SINR_MUE4_dBW(i+1)=SINR_MUE4(i+1)-30;
  SINR_FUE0_dBW(i+1)=SINR_FUE0(i+1)-30;
  SINR_FUE1_dBW(i+1)=SINR_FUE1(i+1)-30;
  SINR_FUE2_dBW(i+1)=SINR_FUE2(i+1)-30;
  SINR_FUE4_dBW(i+1)=SINR_FUE4(i+1)-30;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Data Rate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=0:599
DataRate_MUE0(i+1)=DataRate_calculation(SINR_MUE0_dBW(i+1)); 
DataRate_MUE1(i+1)=DataRate_calculation(SINR_MUE1_dBW(i+1));
DataRate_MUE2(i+1)=DataRate_calculation(SINR_MUE2_dBW(i+1));
DataRate_MUE3(i+1)=DataRate_calculation(SINR_MUE4_dBW(i+1));
DataRate_FUE0(i+1)=DataRate_calculation(SINR_FUE0_dBW(i+1));
DataRate_FUE1(i+1)=DataRate_calculation(SINR_FUE1_dBW(i+1));
DataRate_FUE2(i+1)=DataRate_calculation(SINR_FUE2_dBW(i+1));
DataRate_FUE4(i+1)=DataRate_calculation(SINR_FUE4_dBW(i+1));  
    
    
    
end



%%%%%%%%%%%%%%%%%%%%----Check the results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=0;
count=1;
for i=0:599
 if SINR_MUE0_dBW(i+1)<0
    x(count)=i;
    count=count+1;
  end
end
%%%%%%%%%%%%%%%%%%%%%%---CHARTS---%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)%Distances
semilogy(walk_distance,D_F_MeNB,'-oc',...
walk_distance,D_F_FeNB,'-hm','LineWidth',2,'MarkerSize',5);
title('Distances'); 
xlabel(' Distance [m]','fontsize',16); % x-axis label
ylabel('Distance [m]','fontsize',16); % y-axis label
h=legend('Distance From MeNB','Distance From FeNB','FontSize',16);
set(gca,'FontSize',16);
grid on
set(h);


%******************************************************************
figure(2)%SINR for MUE 

semilogy(walk_distance,SINR_MUE0_dBW,'-^g',...
         walk_distance,SINR_MUE1_dBW,'-oc',...
         walk_distance,SINR_MUE2_dBW,'-hy',...
         walk_distance,SINR_MUE4_dBW,'-sm','LineWidth',1,'MarkerSize',5);
title('SINR for MUE ') 
g=legend('No Power Control','Power Control Method 1','Power Control Method 2','Power Control Method 3','fontsize',5);
ylabel('SINR [dB]','fontsize',16)
xlabel(' Distance [m]','fontsize',16)
set(g);
set(gca,'FontSize',16);
grid on
%*****************************************************************
figure(3)%DataRate for MUE 

semilogy(walk_distance,DataRate_MUE0,'-^g',...
         walk_distance,DataRate_MUE1,'-oc',...
         walk_distance,DataRate_MUE2,'-hy',...
         walk_distance,DataRate_MUE3,'-sm','LineWidth',1,'MarkerSize',5);
title('DataRate for MUE ') 
l=legend('No Power Control','Power Control Method 1','Power Control Method 2','Power Control Method 3','fontsize',5);
ylabel('DataRate [Kbit/s]','fontsize',16)
xlabel(' Distance [m]','fontsize',16)
set(l);
set(gca,'FontSize',16);
grid on
%******************************************************************
figure(4)%SINR for FUE

semilogy(walk_distance,SINR_FUE0_dBW,'-^g',...
         walk_distance,SINR_FUE1_dBW,'-oc',...
         walk_distance,SINR_FUE2_dBW,'-hy',...
         walk_distance,SINR_FUE4_dBW,'-sm','LineWidth',1,'MarkerSize',5);
title('SINR for FUE ') 
m=legend('No Power Control','Power Control Method 1','Power Control Method 2','Power Control Method 3','fontsize',5);
ylabel('SINR [dB]','fontsize',16)
xlabel(' Distance [m]','fontsize',16)
set(m);
set(gca,'FontSize',16);
grid on
%*****************************************************************
figure(5)%DataRate for FUE

semilogy(walk_distance,DataRate_FUE0,'-^g',...
         walk_distance,DataRate_FUE1,'-oc',...
         walk_distance,DataRate_FUE2,'-hy',...
         walk_distance,DataRate_FUE4,'-sm','LineWidth',1,'MarkerSize',5);
title('DataRate for FUE ') 
n=legend('No Power Control','Power Control Method 1','Power Control Method 2','Power Control Method 3','fontsize',5);
ylabel('DataRate [Kbit/s]','fontsize',16)
xlabel(' Distance [m]','fontsize',16)
set(n);
set(gca,'FontSize',16);
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(6)
subplot(3,2,1)
plot(walk_distance, D_F_MeNB,'color','r'); hold on;
title('Distance ')
xlabel('Distance (m)')
ylabel('Distance (m)')

subplot(3,2,1)
plot(walk_distance,D_F_FeNB,'color','b') ;  hold on;
title('Distance ')
xlabel(' Distance (m)')
ylabel('SINR (dB)')

subplot(3,2,2)
plot(walk_distance,SINR_MUE0_dBW,'color','r'); hold on;
title('Distance From Femto')
xlabel(' Distance (m)')
ylabel('Distance (m)')

subplot(3,2,2)
plot(walk_distance,SINR_MUE1_dBW,'color','b') ;  hold on;
title('No power control vs Power Control Method 1') 
xlabel(' Distance (m)')
ylabel('SINR (dB)')

subplot(3,2,3)
plot(walk_distance,SINR_MUE0_dBW,'color','r') ;  hold on;
title('power control 2') 
xlabel(' Distance (m)')
ylabel('SINR (dB)')

subplot(3,2,3)
plot(walk_distance,SINR_MUE2_dBW,'color','b') ;  hold on;
title('No power control vs Power Control Method 2') 
xlabel(' Distance (m)')
ylabel('SINR (dB)')

subplot(3,2,4)
plot(walk_distance,SINR_MUE0_dBW,'color','r') ;  hold on;
title('power control 2') 
xlabel(' Distance (m)')
ylabel('SINR (dB)')

subplot(3,2,4)
plot(walk_distance,SINR_MUE4_dBW,'color','b') ;  hold on;
title('No power control vs Power Control Method 2') 
xlabel(' Distance (m)')
ylabel('SINR (dB)')
%}
