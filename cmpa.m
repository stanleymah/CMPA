%ELEC 4700 PA 10
close all
clear all

%initial conditions
Is=0.01e-12; %A
Ib=0.1e-12; %A
Vb=1.3; %V
Gp=0.1; %1/ohm

%V vector from -1.95 to 0.7 in 200 steps
V=linspace(-1.95,0.7,200);

%I vector in relation to V
I = @(V) Is.*(exp(1.2/0.025.*V)-1)+ Gp.*V-Ib.*(exp(-1.2/0.025.*(V+Vb)-1));

%I vector
I1=I(V);
IR=I1+I1.*(0.2*rand(1,length(I1))); %20 percent rand

figure(1)
plot(V,IR)
title('I vector plot using Plot')

figure(2)
semilogy(V,IR)
title('I vector plot using semilogy')

% 2
P4=polyfit(V,IR,4);
P8=polyfit(V,IR,8);

%Plot graphs
figure(3)
plot(V,polyval(P4,V));
title('4th order plot of I vector')

figure(4)
semilogy(V,polyval(abs(P8),V));
title('8th order plot of I vector')

% 3
x=V;
% A=0.01e-12;
% B=0.1;
% C=0.1e-12;
% D=1.3;

%a
fo_a=fittype('A.*(exp(1.2/0.025.*x)-1)+0.1.*x-C.*(exp(-1.2/0.025.*(x+1.3)-1))');
ff_a = fit(V',IR',fo_a);
If_a = ff_a(x);

%b
fo_b=fittype('A.*(exp(1.2/0.025.*x)-1)+B.*x-C.*(exp(-1.2/0.025.*(x+D)-1))');
ff_b = fit(V',IR',fo_b);
If_b = ff_b(x);

%c
fo_c=fittype('A.*(exp(1.2/0.025.*x)-1)+B.*x-C.*(exp(-1.2/0.025.*(x+D)-1))');
ff_c = fit(V',IR',fo_c);
If_c = ff_c(x);

figure(5)
plot(x,If_c);
title('Fitting all four parameters')

% 4
inputs = V;
targets = I1;
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net)
Inn = outputs;

figure(6);
plot(inputs, Inn,'LineWidth',3);