%--------------------------------------------------------------------------
%   Doped wafer data input function
%
%   Written By: TJ Joyce
%   Assisted By: Inniyew Tesfaw
%   Tested By:  Ethan Walls
%--------------------------------------------------------------------------




clc
clear variables

%
% Login
%

user=input('What is your Rose-Hulman username?\n','s');
path="D:\Data\doping_data.xlsx";
s=31;%size of one data entry


%
%   Standard currents
%

[stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored();
clc


%
%Checks for valid path
try
    readmatrix(path);
catch
    clc
    warning('Irregular Path to excel sheet. Please input path.Please ensure excel file is closed')
    path=input('\nPlease input path\n','s');
   
 
end

%Which function to run
initial=input('Select one by typing the number next to the option\n1. Enter Data\n2. Add new Parameter setting\n3. Edit Standard voltage reading\n');
clc
%%
%
%                            option 1 input data
%
if initial==1
    wafn=input('How many Wafers do you wish to enter?\n');
    loopcondense=input('Do they all have the same backround profile?\n1. Yes        2. No\n');
if loopcondense==1
     [backsheet,subst,bdt]=backroundprofile();
else
end
    for i=1:wafn   %repeats so you can repeatedly put in data
t = datetime('now');
t=datestr(t);
file=fopen('user_log.txt','a');
fprintf(file,'%s        %s      ',user,t);
        
        %fill in with other types later and expand if statement
    sourcet=input('What type of source did you use?\n1. G245\n');   %what type of source did you use put above stuff under this
    if sourcet==1
    source=input('Which source did you use?\n1. G245-1     2. G245-2\n');
    type="boron";
    sheet=1;
    
    %
    %   Backround profiling
    %
    if loopcondense==2
    [backsheet,subst,bdt]=backroundprofile();
    else 
    end


    %
    %   Pre-dep Profiling
    %   

    temp=input('what temperture did you run pre-dep at in Celsius? (Zone 3)\n');                           %
    truetemp=input('What temperatures did the furnace stabilize to? [zone1,zone2,zone3]\n');    %   Paramters of pre dep fuck I need to make another if statement for pre dep vs drive in lowkey probably make this all a function and use it like that later problem
    time=input('How long where the wafers in the furnace? (minutes)\n');  
    diffusionl=diffusionlength(temp);
    clc 
    



    stand=input('did you use a standard input current?\n1. yes\n2. no\n'); 
    if stand==1
        fprintf('It is assumed you used both the positive and negative currents listed in the options\n')
        fprintf('Which option in Micro amps?\n1. %1d,%1d,%1d       2. %1d,%1d,%1d       3. %1d,%1d,%1d\n4. %1d,%1d,%1d       5.%1d,%1d,%1d       6. %1d,%1d,%1d\n7. %1d,%1d,%1d       8. %1d,%1d,%1d      9. %1d,%1d,%1d\nAll in microamps\n',stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9);
        choice=input('');
        if choice==1
           in=[stand1*10^(-3),-stand1*10^(-3)];           
    elseif choice==2
        in=[stand2*10^(-3),-stand2*10^(-3)];
    elseif choice==3
        in=[stand3*10^(-3),-stand3*10^(-3)];
            elseif choice==4
        in=[stand4*10^(-3),-stand4*10^(-3)];
            elseif choice==5
        in=[stand5*10^(-3),-stand5*10^(-3)];
            elseif choice==6
        in=[stand6*10^(-3),-stand6*10^(-3)];
            elseif choice==7
        in=[stand7*10^(-3),-stand7*10^(-3)];
            elseif choice==8
        in=[stand8*10^(-3),-stand8*10^(-3)];
            elseif choice==9
        in=[stand9*10^(-3),-stand9*10^(-3)];

        end
        %Not a custom input
        
    elseif stand==2
        in=input('what were your input currents in microamps? [current 1,current 2,...,current n]\n');
    end
    clc

    out=input('What was your output voltages in mV? [voltage1, voltage2,...,voltagen]\nEnter these in the same order as your input currents\nNote:If using standard input record all positive current then all negative current voltages\nuse ~ if there is no input\n');
  sheetresistance=slopes(in,out);
  in=setsize(in);
  out=setsize(out);
 
  clc
  fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  peakconc=input('Please us PV lighthouse and input your N__peak in atoms/cm^3\n');
  junctiond=input('please input your junction depth in microns\n');
  
  

  
    %Giant data table of where collums start in excel
    collums=collumfinderb(sourcet,source,temp,time,s);
if collums==-1
    error(('invalid paramters for source double check entered parameters match what is allowed with source and set as an option in this program.'))
end
     %%
        coll=numtol(collums);
        coole=numtol(collums+s-1);
        colr=sprintf('%s:%s',coll,coole);
       
       colr3=numtol(collums+s-3);
       
        
        filen=readmatrix(path,'sheet',type,'range',colr);
       


        filen=compactor(filen,collums);
        [row,collum]=size(filen);  

        [idx,~]=max(row);
        wafernumber=idx+1; 
   
       
       idx2=idx+4;
      %% 
        tot=[wafernumber,truetemp,in,out,sheetresistance,diffusionl,junctiond,peakconc];
        tot=zer(tot);
        range=sprintf('%s%d:%s%d',coll,idx2,coole,idx2);
      
        range3=sprintf('%s%d:%s%d',colr3,idx2,coole,idx2);
        
  
      %% 
       writematrix(tot,path,'Sheet',type,'FileType','spreadsheet','Range',range)
       writecell({backsheet,subst,bdt},path,'Sheet',type,'FileType','spreadsheet','Range',range3)
%%
       fprintf(file,'success Wafer number %3f\n, wafer type %3f-%3f for %3f at %3f\n',wafernumber,sourcet,source,time,temp);
       fclose(file);
       %%
       %this is where the next type of source code will go. Likely compress
       %sections of the above code into functions so that it can be
       %compressed into not this mess.
    elseif sourcet==2
    end


    end
elseif initial==2

      fprintf('Which standard input do you wish to change?\n1. %1d,%1d,%1d       2. %1d,%1d,%1d       3. %1d,%1d,%1d\n4. %1d,%1d,%1d       5.%1d,%1d,%1d       6. %1d,%1d,%1d\n7. %1d,%1d,%1d       8. %1d,%1d,%1d      9. %1d,%1d,%1d\nAll in microamps\n',stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9);
         stande=input('');
         clc
         v=input('What values do you wish to change it to?\n Note: Please only enter positive values as it is assumed you are using both the forward and reverse\nOnly enter up to 5 voltages to fit format of excel\nUse format [current1,current2,current3...current5]\n');
         standeditor(stande,v);
         [stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored();
         fprintf('stand %d has been changed\n',stande)
elseif initial==3
elseif initial==4
    temp=input('what temperture did you run pre-dep at in Celsius? (Zone 3)\n');  
    time=input('How long where the wafers in the furnace? (minutes)\n'); 
    sourcet=input('What type of source did you use?\n1. G245\n');
    if sourcet==1
        source=input('Which source did you use?\n1. G245-1     2. G245-2\n');
    else
        source=1;
    graphplotter(temp,time,sourcet,source)
    
end





