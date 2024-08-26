close all
figure
P=dlmread('outoff.txt',',');
h=plot(P(:,1),P(:,3));
set(h,'marker','sq')
set(h,'color','b')
set(h,'MarkerFaceColor','b')
hold on
h=plot(P(:,1),P(:,4));
set(h,'marker','o')
set(h,'color','r')
set(h,'MarkerFaceColor','r')
hold on
h=plot(P(:,1),P(:,6));
set(h,'marker','^')
set(h,'color','g')
set(h,'MarkerFaceColor','g')
grid on
ylim([0 40])
xlim([-8 5])
xlabel('Z-axis [mm]','fontsize',15)
ylabel('Inflection Voltage [V]','fontsize',15)
annotation("textbox", [0.15 0.85 0.2 0.2], 'string', ['30kW VEXT = 2'  '\pm 0.35 [V]' ], 'edgecolor', 'none', "fontsize", 20)
legend('OML Fitting','First Derivative','Saturation Tracing','Envelope')
set(gca,'fontsize',15)
figure
P=dlmread('outon.txt',',');
h=plot(P(:,1),P(:,3));
set(h,'marker','sq')
set(h,'color','b')
set(h,'MarkerFaceColor','b')
hold on
h=plot(P(:,1),P(:,4));
set(h,'marker','o')
set(h,'color','r')
set(h,'MarkerFaceColor','r')
hold on
h=plot(P(:,1),P(:,6));
set(h,'marker','^')
set(h,'color','g')
set(h,'MarkerFaceColor','g')

%=============================================================================
h=plot([-6 -7 -8],[7.0611 22.691 32.916]);
set(h,'linestyle','none')
set(h,'markersize',5)
set(h,'linewidth',1)
set(h,'marker','o')
set(h,'color','r')
set(h,'MarkerFaceColor','w')
%==============================================================================
grid on
ylim([0 40])
xlim([-8 5])
xlabel('Z-axis [mm]','fontsize',15)
ylabel('Inflection Voltage [V]','fontsize',15)
annotation("textbox", [0.15 0.85 0.2 0.2], 'string', ['30kW VEXT = 470'  '\pm 1.3 [V]' ], 'edgecolor', 'none', "fontsize", 20)
legend('OML Fitting','First Derivative','Saturation Tracing','Envelope')
set(gca,'fontsize',15)


