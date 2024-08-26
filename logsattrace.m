 I=y;
 V=x;
 diff3
 color_box2=['r','g','c','b','k','.r','.m'];
 call_color_box=0;
 f_size=15;
 astarisk_size=12;
 ee=2.7182818284590452353602874713;
 disp('logsattrace')
 aa=0;
 ss=0;
 for iii=1:length(V)-1
   aa=aa+abs(V(iii)-V(iii+1));
 endfor
 aa=aa/(length(V)-1);
 %V_inflec=0.8;
 %Vpn_volt=3;
 %V_inflec=-2;
 %Vpn_volt=3;
 [inflec_point]=findPointA(block_i3(V_inflec-1,-40,40),V,[0 1],aa);
 delta=(Vpn_volt-Vpp_volt)*0.5*0.5;
 %delta=2;
 left=1;
 V_index_max=length(V);
 %------------------------------------------------------------------------------
 figure('Position', [10 10 900 600],'visible','off')
 disp('positive')
 [inflec_point_pos]=findPointA(block_i3(V_inflec-delta-left,-40,40),V,[0 1],aa);
 %[inflec_point2]=findPointA(V_inflec-delta*2-left*2,V,[0 1],aa);
 [inflec_point2]=findPointA(block_i3(Vpp_volt,-40,40),V,[0 1],aa);
 [satpoint_pos]=findPointA(block_i3(V_inflec+delta-left,-40,40),V,[0 1],aa);
 [kneesat_pos]=findPointA(block_i3(Vpn_volt+10,-40,40),V,[0 1],aa);
 [headsat_pos]=findPointA(block_i3(Vpn_volt+20,-40,40),V,[0 1],aa);
 Ibias_pos=-I(inflec_point2);
 h1=semilogy(Vpn_volt,block_i2(IVpn+Ibias_pos),'*b','markersize',astarisk_size);
 hold on
 h1=semilogy(Vpp_volt,block_i2(IVpp+Ibias_pos),'*r','markersize',astarisk_size);
 hold on
 [rawstart]=findPointA(block_i3(Vpp_volt,-40,40),V,[0 1],aa);
 h1=semilogy(V(rawstart:end),block_i2(I(rawstart:end)+Ibias_pos),'k','linewidth',1);
 hold on
 [Vout,Iout,not_reject]=reject_anormally2(V(block_i(inflec_point_pos,V_index_max):block_i(satpoint_pos,V_index_max)), ...
                                         log(I(block_i(inflec_point_pos,V_index_max):block_i(satpoint_pos,V_index_max))+Ibias_pos),true);
 [p1_pos,s1]=polyfit(Vout,Iout,1);
 [mi,ni]=size(s1.R);
 if(mi==ni)
 pls = sqrt(diag(inv(s1.R)*inv(s1.R')).*s1.normr.^2./s1.df);
 T_e=pls(1);
 else
 T_e=0;
 endif
 T=1/p1_pos(1);

 h1=semilogy(V(block_i(inflec_point_pos-150,V_index_max):block_i(satpoint_pos+200,V_index_max)), ...
             block_i2(ee.^polyval(p1_pos,V(block_i(inflec_point_pos-150,V_index_max):block_i(satpoint_pos+200,V_index_max)))),'--b','markersize',13,'linewidth',1.5);
 hold on
 [Vout,Iout,not_reject]=reject_anormally2(V(block_i(kneesat_pos,V_index_max):block_i(headsat_pos,V_index_max)), ...
                                          log(I(block_i(kneesat_pos,V_index_max):block_i(headsat_pos,V_index_max))+Ibias_pos),not_reject);
 [p3_pos,s3]=polyfit(Vout,Iout,1);
 h1=semilogy(V(block_i(inflec_point_pos-150,V_index_max):block_i(headsat_pos+100,V_index_max)), ...
             block_i2(ee.^polyval(p3_pos,V(block_i(inflec_point_pos-150,V_index_max):block_i(headsat_pos+100,V_index_max)))),'--r','markersize',13,'linewidth',1.5);
 hold on
 v1_pos=real( (p1_pos(2)-p3_pos(2))/(p3_pos(1)-p1_pos(1)) );
 [I1_pos,dI1]=polyval(p1_pos,v1_pos,s1);
 [I3_pos,dI3]=polyval(p3_pos,v1_pos,s3);
 [uuu]=findPointA(block_i3(v1_pos,-40,40),V,[0 1],aa);
 h1=semilogy(v1_pos,block_i2(ee^((I1_pos+I3_pos)/2)),'.b','markersize',20);
 hold on
 h1=semilogy(V(inflec_point),block_i2(I(inflec_point)+Ibias_pos),'*k','markersize',astarisk_size);

 talkk=['T = ' num2str(T,'%1.2f') '\pm' num2str(T_e,'%1.3f') ' [eV]'];
 annotation('textbox',[0.5 0.3 0.5 0.5],'string',talkk,'edgecolor',[1 1 1],'fontsize',15);

 xlabel('Probe Voltage [V]','fontsize',20)
 ylabel('Probe Current [mA]','fontsize',20)
 title('Negative Saturation point tracing')
 %ylim([10^-3 1])
 xlim([-5 25])
 xticks([-5 0 5 10 15 20 25])
 grid on
 set(gca,'fontsize',20)
 saveas(gcf,[savedir callname '/' callname 'sat+.png']);
 close

 Ipt=ee^((I1_pos+I3_pos)/2)-Ibias_pos;
 Ipt_e=(dI1+dI3)*0.5*ee.^((I1_pos+I3_pos)*0.5);
 %------------------------------------------------------------------------------
 figure('Position', [10 10 900 600],'visible','off')
 disp('negative')
 [inflec_point_neg]=findPointA(block_i3(V_inflec+delta+left,-40,40),V,[0 1],aa);
 %[inflec_point2]=findPointA(V_inflec+delta*2+left*2,V,[0 1],aa);
 [inflec_point2]=findPointA(block_i3(Vpn_volt,-40,40),V,[0 1],aa);
 [satpoint_neg]=findPointA(block_i3(V_inflec-delta+left,-40,40),V,[0 1],aa);
 [kneesat_neg]=findPointA(block_i3(Vpp_volt-10,-40,40),V,[0 1],aa);
 [headsat_neg]=findPointA(block_i3(Vpp_volt-20,-40,40),V,[0 1],aa);
 Ibias_neg=I(inflec_point2);
 h1=semilogy(Vpn_volt,block_i2(-IVpn+Ibias_neg),'*b','markersize',astarisk_size);
 hold on
 h1=semilogy(Vpp_volt,block_i2(-IVpp+Ibias_neg),'*r','markersize',astarisk_size);
 hold on
 [rawstop]=findPointA(block_i3(Vpn_volt,-40,40),V,[0 1],aa);
 h1=semilogy(V(1:rawstop),block_i2(-I(1:rawstop)+Ibias_neg),'k','linewidth',1);
 hold on
 [Vout,Iout,not_reject]=reject_anormally2(V(block_i(satpoint_neg,V_index_max):block_i(inflec_point_neg,V_index_max)), ...
                                          log(-(I(block_i(satpoint_neg,V_index_max):block_i(inflec_point_neg,V_index_max))-Ibias_neg)) ,not_reject);
 [p1_neg,s1]=polyfit(Vout,Iout,1);
 h1=semilogy(V(block_i(satpoint_neg-200,V_index_max):block_i(inflec_point_neg+150,V_index_max)), ...
             block_i2(ee.^polyval(p1_neg,V(block_i(satpoint_neg-200,V_index_max):block_i(inflec_point_neg+150,V_index_max)))),'..-..b','markersize',0.3,'linewidth',1.5);
 hold on
 [Vout,Iout,not_reject]=reject_anormally2(V(block_i(headsat_neg,V_index_max):block_i(kneesat_neg,V_index_max)), ...
                                          log(-(I(block_i(headsat_neg,V_index_max):block_i(kneesat_neg,V_index_max))-Ibias_neg) ),not_reject);
 [p3_neg,s3]=polyfit(Vout,Iout,1);
 h1=semilogy(V(block_i(headsat_neg-100,V_index_max):block_i(inflec_point_neg+150,V_index_max)), ...
             block_i2(ee.^polyval(p3_neg,V(block_i(headsat_neg-100,V_index_max):block_i(inflec_point_neg+150,V_index_max)))),'--r','markersize',13,'linewidth',1.5);
 hold on
 v1_neg=real( (p1_neg(2)-p3_neg(2))/(p3_neg(1)-p1_neg(1)) );
 [I1_neg,dI1]=polyval(p1_neg,v1_neg,s1);
 [I3_neg,dI3]=polyval(p3_neg,v1_neg,s3);
 [uuu]=findPointA(block_i3(v1_neg,-40,40),V,[0 1],aa);
 h1=semilogy(v1_neg,block_i2(ee^((I1_neg+I3_neg)/2)),'.r','markersize',20);
 hold on
 h1=semilogy(V(inflec_point),block_i2(-I(inflec_point)+Ibias_neg),'*k','markersize',astarisk_size);
 xlabel('Probe Voltage [V]','fontsize',20)
 ylabel('Probe Current [mA]','fontsize',20)
 title('Positive Saturation point tracing')
 %ylim([10^-3 1])
 xlim([-15 10])
 xticks([-15 -10 -5 0 5 10])
 grid on
 set(gca,'fontsize',15)
 saveas(gcf,[savedir callname '/' callname 'sat-.png']);
 close

 Imt=-ee^((I1_neg+I3_neg)/2)+Ibias_neg;
 Imt_e=(dI1+dI3)*0.5*ee.^((I1_neg+I3_neg)*0.5);
%-------------------------------------------------------------------------------
 figure('Position', [10 10 900 600],'visible','off')
 h1=plot(V,I,'k','linewidth',1);
 hold on
 h1=plot(Vpn_volt,IVpn,'*b','markersize',astarisk_size);
 hold on
 h1=plot(Vpp_volt,IVpp,'*r','markersize',astarisk_size);
 hold on
 h1=plot(V(block_i(inflec_point_pos-1500,V_index_max):block_i(satpoint_pos+200,V_index_max)), ...
         (ee.^polyval(p1_pos,V(block_i(inflec_point_pos-1500,V_index_max):block_i(satpoint_pos+200,V_index_max)))-Ibias_pos),'--b','markersize',13,'linewidth',1.5);
 hold on
 h1=plot(V(block_i(inflec_point_pos-100,V_index_max):block_i(headsat_pos+100,V_index_max)), ...
         (ee.^polyval(p3_pos,V(block_i(inflec_point_pos-100,V_index_max):block_i(headsat_pos+100,V_index_max)))-Ibias_pos),'--r','markersize',13,'linewidth',1.5);
 hold on
 h1=plot(v1_pos,(ee^((I1_pos+I3_pos)/2)-Ibias_pos),'.b','markersize',20);
 hold on


 h1=plot(Vpn_volt,IVpn,'*b','markersize',astarisk_size);
 hold on
 h1=plot(Vpp_volt,IVpp,'*r','markersize',astarisk_size);
 hold on
 h1=plot(V(block_i(satpoint_neg-200,V_index_max):20:block_i(inflec_point_neg+1000,V_index_max)), ...
        (-ee.^polyval(p1_neg,V(block_i(satpoint_neg-200,V_index_max):20:block_i(inflec_point_neg+1000,V_index_max)))+Ibias_neg),'.-.b','markersize',3,'linewidth',1.5);
 hold on
 h1=plot(V(block_i(headsat_neg-100,V_index_max):block_i(inflec_point_neg+100,V_index_max)), ...
        (-ee.^polyval(p3_neg,V(block_i(headsat_neg-100,V_index_max):block_i(inflec_point_neg+100,V_index_max)))+Ibias_neg),'--r','markersize',13,'linewidth',1.5);
 hold on
 h1=plot(v1_neg,(-ee^((I1_neg+I3_neg)/2)+Ibias_neg),'.r','markersize',20);

 xlabel('Probe Voltage [V]','fontsize',20)
 ylabel('Probe Current [mA]','fontsize',20)
 title('Linear plot and point tracing')
 %ylim([-0.125 0.125])
 %yticks([-0.1 -0.05 0 0.05 0.1])
 ylim([min(I) max(I)])
 xlim([-25 25])
 xticks([-25 -20 -15 -10 -5 0 5 10 15 20 25])
 grid on
 set(gca,'fontsize',15)
 saveas(gcf,[savedir callname '/' callname 'lin.png']);
 close
 dlmwrite([savedir callname '\' callname 'sat.txt'],[v1_neg v1_pos Imt Ipt T])
