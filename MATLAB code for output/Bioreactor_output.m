%% Data import


clear all;
file = uigetfile('*.*');
data = lvm_import(file);
time = data.Segment1.data(:,1);
loadcell = data.Segment1.data(:,2);
lvdt1 =  data.Segment1.data(:,3);
lvdt2 =  data.Segment1.data(:,4);
lvdt3 =  data.Segment1.data(:,5);
lvdt4 =  data.Segment1.data(:,6);
motor = data.Segment1.data(:,7);

prompt = {'Length of tendon in LVDT 1','Length of tendon in LVDT 2','Length of tendon in LVDT 3','Length of tendon in LVDT 4',};
definput = {'5','5','5','5'}; dims = [1 35];
dlgtitle = 'Enter the lengths of the tendon';
lengths = inputdlg(prompt,dlgtitle,dims,definput);

prompt = {'Stress in tissue 1','Stress in tissue 2','Stress in tissue 3','Stress in tissue 4'};
definput = {'2','2','2','2'}; dims = [1 35];
dlgtitle = 'Stress applied to tendons';
stress = inputdlg(prompt,dlgtitle,dims,definput);

%% Finding the peaks

[topi,tiidx] = findpeaks(motor); %tidx and bidx find at what index value was the peak maximum or minimum
[boti,biidx] = findpeaks(-motor);%topi and boti are the actual peak values

j=1; 
i=1;
q = size(biidx)+size(tiidx);
w = q(1,1);

if tiidx(1)>biidx(1)
    while i<w
        iidx(i)=biidx(j);
        iidx(i+1)=tiidx(j);
        i=i+2;
        j=j+1;
    end
end

if  biidx(1)>tiidx(1)
    while i<w
        iidx(i)=tiidx(j);
        iidx(i+1)=biidx(j);
        i=i+2;
        j=j+1;
    end
end

%% Find the displacement of the tissue with respect to initial position

ipos1 = mean(lvdt1(1:5));
ipos2 = mean(lvdt2(1:5));
ipos3 = mean(lvdt3(1:5));
ipos4 = mean(lvdt4(1:5));

z11 = size(time);
s2 = z11(1,1);
for m = 1: s2;
    dis1(m) = lvdt1(m)-ipos1;
    dis2(m) = lvdt2(m)-ipos2;
    dis3(m) = lvdt3(m)-ipos3;
    dis4(m) = lvdt4(m)-ipos4;
end

%% Find the displacement values for each cycle

s=size(iidx);
z = s(1,2);

n=1; 

for k= 2:2:z
    disp1(n) = lvdt1(iidx(k))-lvdt1(iidx(k-1));
    disp2(n) = lvdt2(iidx(k))-lvdt2(iidx(k-1));
    disp3(n) = lvdt3(iidx(k))-lvdt3(iidx(k-1));
    disp4(n) = lvdt4(iidx(k))-lvdt4(iidx(k-1));
    n=n+1;
end


%% Calcuate strain and  live secant modulus
s1 = size(disp1);
z1 = s1(1,2);

for k=1:z1
    timep(k)= time(tiidx(k));
end

for p = 1:z1
    stress1(p) = str2num(stress{1,1});
    stress2(p) = str2num(stress{2,1});
    stress3(p) = str2num(stress{3,1});
    stress4(p) = str2num(stress{4,1});
end

strain1 = disp1/str2num(lengths{1,1});
strain2 = disp2/str2num(lengths{2,1});
strain3 = disp3/str2num(lengths{3,1});
strain4 = disp4/str2num(lengths{4,1});

Mod1 = stress1./strain1;
Mod2 = stress2./strain2;
Mod3 = stress3./strain3;
Mod4 = stress4./strain4;

%% Calculate peak strains ((peak position for each cycle - initial zero load value)/initial length)

z2=size(biidx)-1;
z22= z2(1,1);
for p = 1:z22
    peakstrain1(p) = -1*(dis1(biidx(p)))/str2num(lengths{1,1});
    peakstrain2(p) = -1*(dis2(biidx(p)))/str2num(lengths{2,1});
    peakstrain3(p) = -1*(dis3(biidx(p)))/str2num(lengths{3,1});
    peakstrain4(p) = -1*(dis4(biidx(p)))/str2num(lengths{4,1});
   
end

%% Plottting Graphs : Copy things to script

%  plot(time,lvdt1,time,lvdt2,time,lvdt3,time,lvdt4)
%  plot(time,dis1,time,dis2,time,dis3,time,dis4)
%  plot(timep,disp1,timep,disp2,timep,disp3,timep,disp4)
%  plot(timep,Mod1,timep,Mod2,timep,Mod3,timep,Mod4)
%  plot(timep(1:p),peakstrain1,timep(1:p),peakstrain2,timep(1:p),peakstrain3,timep(1:p),peakstrain4)
