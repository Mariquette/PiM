clear all; close all; clc;

temp = load('temperatures.txt');

%%
figure(1);
grid on;
grid minor;
plot(temp(:,1)+temp(:,2)/60,temp(:,3),'o-');
xlabel('time');
ylabel('temperature (°C)');