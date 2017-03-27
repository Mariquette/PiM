clear all; close all; clc;

temp = load('temperatures.txt');

h =num2str(temp(:,1)); m = num2str(temp(:,2));
a = strcat(h,':',m);
time=datenum(a, 'HH:MM');

inttime = linspace(time(1),time(19),120);
inttemp = interp1(time,temp(:,3),inttime,'pchip');
%%
figure(1);
hold on
plot(time,temp(:,3),'x');
plot(inttime,inttemp);
datetick('x','HH:MM')
grid on;
grid minor;
xlabel('Time (HH:MM)');
ylabel('Temperature (°C)');
ylim([17 35])
