%3diff-----------------------------------------------------------------------------------

  disp('3diff')

  %LPmodel
  diff3coefficient=[0 0.1 -5 5 0 0 0 0];
  disp('model-1');
  opts=statset('nlinfit');
  opts.RobustWgtFun = 'bisquare';
  m1= @(a,x)(a(1)+exp(a(2)*tanh((x+a(3))/(abs(a(4))))).*(a(5)+(a(6)*(x+a(3))+a(7)*(x+a(3)).^2+a(8)*(x+a(3)).^3)));

  %Normalize I for fitting accrucy
  H=max(I);
  if(H==0)
   H=1;
  endif
  %set minimal error
  deep=0.001;

  %fitting
  I2=I/H;
  I2max=max(I2);
    for repeat_fitting=1:5
      [diff3coefficient_now,rr,J,CovB,MSE]=nlinfit(V,I2,m1,diff3coefficient,opts);
      if ((mean(rr.^2))^.5 <deep*(I2max))
        disp(['Max Iteration:' num2str(repeat_fitting)])
        break
      endif
    endfor
  clear('opts')


  %process get saturation point
  %SD calculation
  clear('Ifitted','Ifitted_fine','Vfitted_fine')
  Ifitted_err=0;
  Ifitted=H*m1(diff3coefficient_now,V);
   for i=1:length(V)
     Ifitted_err=Ifitted_err+(I(i)-Ifitted(i))^2/length(V);
   endfor
  Ifitted_err=Ifitted_err^0.5;


  %fitting reconstruct
  Vfitted_fine=min(V):0.001:max(V);
  Ifitted_fine=H*m1(diff3coefficient_now,Vfitted_fine);

  %declare diff result varible
  IV3diff=zeros(length(Vfitted_fine),1);
  for i=6:length(Vfitted_fine)-5
    IV3diff(i)=(-Ifitted_fine(i-2)+2*Ifitted_fine(i-1)-2*Ifitted_fine(i+1)+Ifitted_fine(i+2))/2;
  endfor

  %smooth line 3diff
  IV3diff=medfilt1(movmean(IV3diff,100),10);

  %declare point varible
  o=zeros(8,1);

  %finding range
  down_lim=floor(length(Vfitted_fine)*0.5/3);
  up_lim=floor(length(Vfitted_fine)*2.5/3);

  IV3diff(down_lim:up_lim)=IV3diff(down_lim:up_lim)./max(IV3diff(down_lim:up_lim));
  %separate I+ and I-
  [o(1) o(2)]=min(IV3diff(down_lim:up_lim));
    o(2)=o(2)+down_lim;
  continue_enable=true;
  if(o(2)>=up_lim)
    o(2)
    up_lim
    %Valid_IVcurve_index=Valid_IVcurve_index-1;
    continue_enable=false;
    disp('Unusual IV curve')
  else
   %find max of each side
   [o(3) o(4)]=max(IV3diff(down_lim:o(2)));
   [o(5) o(6)]=max(IV3diff(o(2):up_lim));

     %corrected position to match data position
     o(4)=o(4)+down_lim;
     o(6)=o(6)+o(2);

   %find cross zeros point
   [o(7) o(8)]=min(abs(Ifitted_fine(down_lim:up_lim)));
     o(8)=o(8)+down_lim;

       %take plasma parameter
       Vpp_volt=Vfitted_fine(o(4)-1); %positive species sheath potential
       IVpp=Ifitted_fine(o(4)-1);

       Vpn_volt=Vfitted_fine(o(6)+1); %negative species sheath potential
       IVpn=Ifitted_fine(o(6)+1);

       %Vf(Valid_IVcurve_index)=V1(o(8));  %floating potential
       V_inflec=Vfitted_fine(o(2));

       IVi=Ifitted_fine(o(2));

       n_retard0_point2=findPointA(block_i3(Vpn_volt-0.3-0.5,-40,40),V',[1/3 2/3],0.01);
       n_retard0_point1=findPointA(block_i3(Vpp_volt+0.3-0.5,-40,40),V',[1/3 2/3],0.01);
       n_call_retard0=n_retard0_point1:n_retard0_point2;
       Iretard_fortemp0=I(n_call_retard0);
       Vretard_fortemp0=V(n_call_retard0);
       Iretard_fortemp0_min=min(Iretard_fortemp0);

       n_retard0_point2=findPointA(block_i3(Vpn_volt+2,-40,40),V',[1/3 2/3],0.01);
       n_retard0_point1=findPointA(block_i3(Vpp_volt-2,-40,40),V',[1/3 2/3],0.01);
       n_call_retard0=n_retard0_point1:n_retard0_point2;
       Iretard_fortemp1=I(n_call_retard0);
       Vretard_fortemp1=V(n_call_retard0);
       Iretard_fortemp1_min=min(Iretard_fortemp1);


     figure('visible','off')
     plot(V,I,'k')
     hold on
     ee=2.718281828459045;
     plot(Vfitted_fine,Ifitted_fine,'r');
     hold on
     plot(Vfitted_fine,IV3diff/max(IV3diff)*max(Ifitted_fine),'m');
     xlabel('Probe Voltage [V]','fontsize',20)
     ylabel('Probe Current [A]','fontsize',20)
     title('3Diff')
     grid on
     saveas(gcf,[savedir callname '/' callname 'diff3.png']);
     close
   %--------------------------------------------------------------------------%

  endif

%-
