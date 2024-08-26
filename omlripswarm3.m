close all
pkg load optim
pkg load signal
directory='rawdata/';
savedir='pic/';
%mkdir(savedir)

table=dlmread([directory 'HCS30kWZ2' '.txt'],',');
for i=1:10%length(table(:,1))
 callname=table(i,3);
 callname=num2str(callname);
 if(!isfolder([savedir callname]))
 mkdir([savedir callname]);
 end
 disp([callname])
 LP_in=dlmread([directory num2str(callname) '_70.txt'],',');
 x=LP_in(:,2)';
 y=LP_in(:,3)';
  figure('visible','off')
 plot(x,y*1000,'.k')
 grid on
 ylabel('Probe Current [mA]','fontsize',14)
 xlabel('Probe Voltage [V]','fontsize',14)
 xlim([-40 40])
 set(gca,'fontsize',14)
 saveas(gcf,[savedir callname '/' callname 'IV.png']);
 close

if(0)
 b1=[ ...
   2.2518e+00 ...
   2.0638e-01 ...
   9.1855e-01 ...
   2.2547e+17 ...
   3.3361e+17 ...
   4.2218e-3 ...
   1.3048e-03 ...
   0.86 ...
   1 ...
   0.1 ...
   20 ...
   -0.5e-4 ...
   ]';
b2=[ ...
   1.890000000000000e+00 ...
   6.000000000000000e+00 ...
   6.000000000000000e+00 ...
   6.000000000000000e+16 ...
   5.348630336962928e+16 ...
   1.050000000000000e-01 ...
   1.800000000000000e-01 ...
   8.771515335004232e-01 ...
   1.440000000000000e+00 ...
   8.694839555306028e-02 ...
   2.400000000000000e+01 ...
  -1.440000000000000e-04 ...
  ]';
end
  try
   disp('read nl.txt')
   b=dlmread([savedir callname '\' callname 'nl.txt'],',');
  catch
   disp('read se.txt')
   b=dlmread([savedir callname '\' callname 'sw.txt'],',');
  end
if(0)
sw_enable=0;
try
 disp('nlfit1')
 %b=b1;
 b = nlinfit(x, y, @(b,x) omlripplem2(b,x),b);
 dlmwrite([savedir callname '\' callname 'nl.txt'],b)
 catch
  %try
  %   disp('nlfit2')
  %   b=b2;
  %   b = nlinfit(x, y, @(b,x) omlripplem2(b,x),b);
  %   dlmwrite([savedir callname '\' callname 'nl.txt'],b,'-append')
  %catch
     sw_enable=1;
  %end
end
end

if(1)
 disp('swarm')
 %b=b1+b2;
 %b=b/2;
 lb = 0.9*b;
 ub = 1.1*b;
 penalty = 10;
 popsize = 100;
 maxiter = 50;
 b = Swarm(@(b) omlripplem2(b,x),[],[], y, lb, ub, penalty, popsize, maxiter)
 dlmwrite([savedir callname '\' callname 'sw.txt'],b)
end

 xx=-40:0.01:40;
 [f3 f4]=omlripplem3(b,xx);
 yy=omlripplem2(b,xx);
 figure('visible','on')
 plot(x,y*1000,'.k')
 hold on
 plot(xx,f3*1000,'b')
 hold on
 plot(xx,f4*1000,'r')
 hold on
 plot(xx,yy*1000,'.g')
 grid on
 ylabel('Probe Current [mA]','fontsize',14)
 xlabel('Probe Voltage [V]','fontsize',14)
 xlim([-40 40])
 set(gca,'fontsize',14)
 saveas(gcf,[savedir callname '/' callname 'fit.png']);
 %close
if(1)
 %first derivative
 disp('1diff')
 figure('visible','off')
 yy=omlripplem2(b,xx);
 ydif=movmean(diff(yy),200);
 [a1 a2]=max(ydif);
 plot(xx(1:end-1),ydif,'g')
 hold on
 ydif=movmean(diff(y),200);
 [b1 b2]=max(ydif);
 plot(x(1:end-1),ydif,'k')
 d1=1.1*max([a1 b1]);
 d2=-0.1*max([a1 b1]);
 ylim([d2 d1])
 grid on
 ylabel('Derivative of Probe Current [mA/V]','fontsize',14)
 xlabel('Probe Voltage [V]','fontsize',14)
 xlim([-40 40])
 line ([xx(a2) xx(a2)], [d2 d1], "linestyle", "-", "color",'r');
 line ([x(b2) x(b2)], [d2 d1], "linestyle", "-", "color", "k");
 set(gca,'fontsize',14)
 saveas(gcf,[savedir callname '/' callname 'diff1.png']);
 close

 logsattrace

dlmwrite('out.txt',[str2num(callname) b(1) x(b2) xx(a2) v1_pos],'-append')
end
end

