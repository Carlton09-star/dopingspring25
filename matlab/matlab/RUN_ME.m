%--------------------------------------------------------------------------
%   Doped wafer data input function
%
%   Written By: TJ Joyce
%   Assisted By: Inniyew Tesfaw
%   Tested By:  Ethan Walls, Peter Fields
%--------------------------------------------------------------------------

clc
clear variables

%
% Login
%

user=input('What is your Rose-Hulman username?\n','s');
path="D:\dopingspring25\data\doping_data.xlsx";


%
%   Checks for valid path
%

try
    readmatrix(path,'Range','A1:A1');
catch
    clc
    warning('Irregular Path to excel sheet. Please input path.Please ensure excel file is closed ensure there are no quotes around the path')
    path=input('\nPlease input path\n','s');
end



s=31;
%size of one data entry for phosphorus 
%I later realized this needs to be changed in the boron information so I
%redefined it in the relevant sections


%
%   Standard currents
%

[stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored();
clc 
 


%Which function to run
initial=input('Select one by typing the number next to the option\n1. Enter Data\n2. Edit Standard Voltage Reading\n3. Add new Paramter group\n4. Display graph\n5. Data analysis\n');
clc


                         option 1 input data

%Choose how many wafers to enter and input backround profiling if it's all
%the same
if initial==1
    wafn=input('How many Wafers do you wish to enter?\n');
    loopcondense=input('Do they all have the same backround profile?\n1. Yes        2. No\n');
if loopcondense==1
     [backsheet,subst,bdt]=backroundprofile();
end


    for i=1:wafn   %repeats so you can repeatedly put in data

    if wafn^2<0
        error(':/ That is an imaginary number my friend')
    end
%User data storage for the user log
t=datestr(datetime('now'));

file=fopen('user_log.txt','a');
fprintf(file,'%s        %s      \n',user,t);

        
       %what type of source did you use put above stuff under this
    sourcet=input('What type of source did you use?\n1. GS-245\n2. GS-139\n3. TP-250\n4. TP-470\n');   

    if sourcet==1

    source=input('Which source did you use?\n1. GS245-1     2. G245-2\n');
    type="boron";
   s=32;
    sheet='GS-245';
    clc

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

    temp=input('What temperture did you run pre-dep at in Celsius? (Zone 3)\n');                           %
    truetemp=input('What temperatures did the furnace stabilize to? [zone1,zone2,zone3]\n');    %   Paramters of pre dep fuck I need to make another if statement for pre dep vs drive in lowkey probably make this all a function and use it like that later problem
    time=input('How long where the wafers in the furnace? (minutes)\n');
    anneal=input('How long was your anneal after pre dep?(minutes)\n');
    diffusionl=diffusionlength(temp);
    clc 
   

    %Determines the size of a for loop later
    loc=input('How many locations did you take? Use the same input currents at all locations.\n');
    clc
    
    %
    %   Input and output currents 
    %

    stand=input('did you use a standard input current? \nDo not use if for one of your input currents you did not get a return voltage\n1. yes\n2. no\n'); 
    clc
    if stand==1
        fprintf('It is assumed you used both the positive and negative currents listed in the options.\n (You should have twice as many outputs as there are listed currents)\n')
        fprintf('Which option in Micro amps?\n')
        standprinter()
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
        in=input('What were your input currents in microamps? [current 1,current 2,...,current n]\nNote If there is no associated output value do not include it\n');
    end
    clc
for l=1:loc
    fprintf('for location %f',l);
    out=input('What was your output voltages in mV? [voltage1, voltage2,...,voltagen]\nEnter these in the same order as your input currents (There should be twice as many)\nNote:If using standard input record all positive current then all negative current voltages\n');
    clc
  totalstore(temp,time,source,sourcet,wafern,out)
  sheetresistance1(l)=slopes(in,out);
  sheetresistance=mean(sheetresistance1);

end
  in=setsize(in);
  out=setsize(out);
 
  clc
  fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  fprintf('Next using PV Lighthouse find your peak concentration and junction depth')
  pause(5)
  pvlighthouse()
  clc
  fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  peakconc=input('Please use PV lighthouse and input your N__peak in atoms/cm^3\n');
  junctiond=input('please input your junction depth in microns\n');
  
  

  %%
    %Giant data table of where collums start in excel
    collums=collumfinderb(sourcet,source,temp,time,s);

    if collums==-1
        collums=extractor(temp,time,source,sourcet);
        
    end
    %If it is still = to -1
    if collums==-1
    error(('invalid paramters for source double check entered parameters match what is allowed with source and set as an option in this program.'))
    end
   %%
   
        coll=numtol(collums);
        coole=numtol(collums+s-1);
        colr=sprintf('%s:%s',coll,coole);
       
       colr3=numtol(collums+s-3);
    

        filen=readmatrix(path,'sheet',sheet,'range',colr);
       


        filen=compactor(filen,collums);
        [row,collum]=size(filen);  

        [idx,~]=max(row);
        wafernumber=idx+1; 
   
       
       idx2=idx+4;
      %% 
        tot=[wafernumber,truetemp,in,out,sheetresistance,diffusionl,junctiond,peakconc,anneal];
        tot=zer(tot);
        range=sprintf('%s%d:%s%d',coll,idx2,coole,idx2);
      
        range3=sprintf('%s%d:%s%d',colr3,idx2,coole,idx2);
        
  
      %% 
       writematrix(tot,path,'Sheet',sheet,'FileType','spreadsheet','Range',range)
       writecell({backsheet,subst,bdt},path,'Sheet',sheet,'FileType','spreadsheet','Range',range3)
       datastorer(temp,time,sourcet,source,wafernumber,peakconc)
%%
       fprintf(file,'success Wafer number %3f\n, wafer type %3f-%3f for %3f at %3f\n',wafernumber,sourcet,source,time,temp);
       fclose(file);
       %%
       %this is where the next type of source code will go. Likely compress
       %sections of the above code into functions so that it can be
       %compressed into not this mess.
    elseif sourcet==2 
        source=1;
        s=32;
        clc
    type='boron';
    sheet='GS-139';
        if loopcondense==2
    [backsheet,subst,bdt]=backroundprofile();
    else 
        end

    temp=input('What temperture did you run pre-dep at in Celsius? (Zone 3)\n');                           %
    truetemp=input('What temperatures did the furnace stabilize to? [zone1,zone2,zone3]\n');    %   Paramters of pre dep fuck I need to make another if statement for pre dep vs drive in lowkey probably make this all a function and use it like that later problem
    time=input('How long where the wafers in the furnace? (minutes)\n');  
    anneal=input('How long was your anneal after pre dep? (minutes)\n');
    diffusionl=diffusionlength(temp);
    clc 


     stand=input('Did you use a standard input current? \nDo not use if one of your input currents did not return a voltage\n1. yes\n2. no\n'); 
     clc


     loc=input('How many locations did you take? Use the same input currents at all locations.\n');
    clc


    if stand==1
        fprintf('It is assumed you used both the positive and negative currents listed in the options.(You should have twice as many outputs as there are listed currents)\n')
        fprintf('Which option in Micro amps?\n')
        standprinter()
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
        in=input('What were your input currents in microamps? [current 1,current 2,...,current n]\nIf there is no associated output value do not include it');
    end
    clc
for l=1:loc
    fprintf('for location %f',l);
    out=input('What was your output voltages in mV? [voltage1, voltage2,...,voltagen]\nEnter these in the same order as your input currents (There should be twice as many)\nNote:If using standard input record all positive current then all negative current voltages\n');
    clc

    totalstore(temp,time,source,sourcet,wafern,out)
   sheetresistance1(l)=slopes(in,out);
  sheetresistance=mean(sheetresistance1);

end
    
  in=setsize(in);
  out=setsize(out);
 
  clc
fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  fprintf('Next using PV Lighthouse find your peak concentration and junction depth')
  pause(5)
  pvlighthouse()
  clc
  fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  peakconc=input('Please use PV lighthouse and input your N__peak in atoms/cm^3\n');
  junctiond=input('please input your junction depth in microns\n');
  
  
  

  
    %Edit this so that it works for gs-245
    collums=collumfinderb(sourcet,source,temp,time,s);
    if collums==-1
        collums=extractor(temp,time,source,sourcet);
    end

if collums==-1
    error(('invalid paramters for source double check entered parameters match what is allowed with source and set as an option in this program.'))
end
 
   
        coll=numtol(collums);
        coole=numtol(collums+s-1);
        colr=sprintf('%s:%s',coll,coole);
       
       colr3=numtol(collums+s-3);
       
        
        filen=readmatrix(path,'sheet',sheet,'range',colr);
       


        filen=compactor(filen,collums);
        [row,collum]=size(filen);  

        [idx,~]=max(row);
        wafernumber=idx+1; 
   
       
       idx2=idx+4;
     
        tot=[wafernumber,truetemp,in,out,sheetresistance,diffusionl,junctiond,peakconc,anneal];
        tot=zer(tot);
        range=sprintf('%s%d:%s%d',coll,idx2,coole,idx2);
      
        range3=sprintf('%s%d:%s%d',colr3,idx2,coole,idx2);
        
  
    
       writematrix(tot,path,'Sheet',sheet,'FileType','spreadsheet','Range',range)
       writecell({backsheet,subst,bdt},path,'Sheet',sheet,'FileType','spreadsheet','Range',range3)
       datastorer(temp,time,sourcet,source,wafernumber,peakconc)

       fprintf(file,'success Wafer number %3f\n, wafer type %3f-%3f for %3f at %3f\n',wafernumber,sourcet,source,time,temp);
       fclose(file);
 
%%   TP-250
    elseif sourcet==3
            
    source=1;
    type='Phos';
   
    sheet='TP-250';
    clc
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

    temp=input('What temperture did you run pre-dep at in Celsius? (Zone 3)\n');                           %
    truetemp=input('What temperatures did the furnace stabilize to? [zone1,zone2,zone3]\n');    %   Paramters of pre dep fuck I need to make another if statement for pre dep vs drive in lowkey probably make this all a function and use it like that later problem
    time=input('How long where the wafers in the furnace? (minutes)\n');  
    diffusionl=diffusionlength(temp);
    clc 
    



    stand=input('Did you use a standard input current?\n Do not use if for one of your input currents you did not get a return voltage\n1. yes\n2. no\n'); 
    clc

    loc=input('How many locations did you take? Use the same input currents at all locations.\n');
    clc


    if stand==1
        fprintf('It is assumed you used both the positive and negative currents listed in the options\n(You should have twice as many outputs as there are listed currents)\n')
        fprintf('Which option in Micro amps?\n')
        standprinter()
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
        in=input('What were your input currents in microamps? [current 1,current 2,...,current n]\nNote If there is no associated output value do not include it\n');
    end
    clc

    for l=1:loc
        fprintf('for location %f',l);
    out=input('What was your output voltages in mV? [voltage1, voltage2,...,voltagen]\nEnter these in the same order as your input currents (There should be twice as many)\nNote:If using standard input record all positive current then all negative current voltages\n');
    clc
    
    totalstore(temp,time,source,sourcet,wafern,out)
  sheetresistance1(l)=slopes(in,out);
  sheetresistance=mean(sheetresistance1);

end
    
  in=setsize(in);
  out=setsize(out);
 
  clc
fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  fprintf('Next using PV Lighthouse find your peak concentration and junction depth')
  pause(5)
  pvlighthouse()
  clc
  fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  peakconc=input('Please use PV lighthouse and input your N__peak in atoms/cm^3\n');
  junctiond=input('please input your junction depth in microns\n');
  
  
  

  
    %Giant data table of where collums start in excel
    collums=collumfinderb(sourcet,source,temp,time,s);

    if collums==-1
        collums=extractor(temp,time,source,sourcet);
        
    end
    %If it is still = to -1
    if collums==-1
    error(('invalid paramters for source double check entered parameters match what is allowed with source and set as an option in this program.'))
    end

   %%
   
        coll=numtol(collums);
        coole=numtol(collums+s-1);
        colr=sprintf('%s:%s',coll,coole);
       
       colr3=numtol(collums+s-3);
    

        filen=readmatrix(path,'sheet',sheet,'range',colr);
       


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
       writematrix(tot,path,'Sheet',sheet,'FileType','spreadsheet','Range',range)
       writecell({backsheet,subst,bdt},path,'Sheet',sheet,'FileType','spreadsheet','Range',range3)
       datastorer(temp,time,sourcet,source,wafernumber,peakconc)
%%
       fprintf(file,'success Wafer number %3f\n, wafer type %3f-%3f for %3f at %3f\n',wafernumber,sourcet,source,time,temp);
       fclose(file);

    elseif sourcet==4
        %%   TP-470
    
            
    source=1;
    type="Phos";
   
    sheet='TP-470';
    clc
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

    temp=input('What temperture did you run pre-dep at in Celsius? (Zone 3)\n');                           %
    truetemp=input('What temperatures did the furnace stabilize to? [zone1,zone2,zone3]\n');    %   Paramters of pre dep fuck I need to make another if statement for pre dep vs drive in lowkey probably make this all a function and use it like that later problem
    time=input('How long where the wafers in the furnace? (minutes)\n');  
    diffusionl=diffusionlength(temp);
    clc 
    



    stand=input('Did you use a standard input current? \nDo not use if for one of your input currents you did not get a return voltage\n1. yes\n2. no\n'); 
    clc

    loc=input('How many locations did you take? Use the same input currents at all locations.\n');
    clc


    if stand==1
        fprintf('It is assumed you used both the positive and negative currents listed in the options\n(You should have twice as many outputs as there are listed currents)\n')
        fprintf('Which option in Micro amps?\n')
        standprinter()
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
        in=input('What were your input currents in microamps? [current 1,current 2,...,current n]\nNote If there is no associated output value do not include it\n');
    end
    clc
for l=1:loc
    fprintf('for location %f',l);
    out=input('What was your output voltages in mV? [voltage1, voltage2,...,voltagen]\nEnter these in the same order as your input currents (There should be twice as many)\nNote:If using standard input record all positive current then all negative current voltages\n');
    clc
    
    totalstore(temp,time,source,sourcet,wafern,out)
  sheetresistance1(l)=slopes(in,out);
  sheetresistance=mean(sheetresistance1);

end
    
  in=setsize(in);
  out=setsize(out);
 
  clc
fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  fprintf('Next using PV Lighthouse find your peak concentration and junction depth')
  pause(5)
  pvlighthouse()
  clc
  fprintf('Your Sheet Resistance (Ohms/Square) is %f.\nYour diffusion length is %f\n',sheetresistance,diffusionl)
  peakconc=input('Please use PV lighthouse and input your N__peak in atoms/cm^3\n');
  junctiond=input('please input your junction depth in microns\n');
  
  
  

  %%
    %Giant data table of where collums start in excel
    collums=collumfinderb(sourcet,source,temp,time,s);

    if collums==-1
        collums=extractor(temp,time,source,sourcet);
        
    end
    %If it is still = to -1
    if collums==-1
    error(('invalid paramters for source double check entered parameters match what is allowed with source and set as an option in this program.'))
    end
   %%
   
        coll=numtol(collums);
        coole=numtol(collums+s-1);
        colr=sprintf('%s:%s',coll,coole);
       
       colr3=numtol(collums+s-3);
    

        filen=readmatrix(path,'sheet',sheet,'range',colr);
       


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
       writematrix(tot,path,'Sheet',sheet,'FileType','spreadsheet','Range',range)
       writecell({backsheet,subst,bdt},path,'Sheet',sheet,'FileType','spreadsheet','Range',range3)
       datastorer(temp,time,sourcet,source,wafernumber,peakconc)
%%
       fprintf(file,'success Wafer number %3f\n, wafer type %3f-%3f for %3f at %3f\n',wafernumber,sourcet,source,time,temp);
       fclose(file);


    end


    end
    %%                                  Option 2
elseif initial==2

      fprintf('Which standard input do you wish to change?\n1. %1d,%1d,%1d       2. %1d,%1d,%1d       3. %1d,%1d,%1d\n4. %1d,%1d,%1d       5.%1d,%1d,%1d       6. %1d,%1d,%1d\n7. %1d,%1d,%1d       8. %1d,%1d,%1d      9. %1d,%1d,%1d\nAll in microamps\n',stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9);
         stande=input('');
         clc
         v=input('What values do you wish to change it to?\n Note: Please only enter positive values as it is assumed you are using both the forward and reverse\nOnly enter up to 5 voltages to fit format of excel\nUse format [current1,current2,current3...current5]\n');
         standeditor(stande,v);
         clc
         [stand1,stand2,stand3,stand4,stand5,stand6,stand7,stand8,stand9]=stored();
         fprintf('Stand %d has been changed\n',stande)
           fprintf('New Standard Inputs\n')
           standprinter()
%%                                         Option 3
elseif initial==3
    temp=input('what new input temperture do you want to add (Celcius)?\n');
    time=input('what time do you wish to add (minutes)?\n');
    sourcet=input('What type of source did you use?\n1. GS-245\n2. GS-139\n\3. TP-250\n4. TP-470');
    source=input('Which source are you using? (Use 1 if there is only one of that source).\n');
  
    clc
   
    updater(temp,time,source,sourcet,path)
   
    fprintf('New Paramter Added\n')

%%                                        Option 4

elseif initial==4
    temp=input('What temperture did you run pre-dep at in Celsius? (Zone 3)\n');  
    time=input('How long where the wafers in the furnace? (minutes)\n'); 
    sourcet=input('What type of source did you use?\n1. GS-245\n2. GS-139\n');
    if sourcet==1
        source=input('Which source did you use?\n1. GS-245-1     2. GS-245-2\n3. TP-250         4. TP-470');
    else
        source=1;
    end
    graphplotter(temp,time,sourcet,source)

    %%                                      Option 5
elseif initial==5
    temp=input('What was the temperture of the relevant data in Celcius? (Zone 3)\n');
    time=input('How long were they in the furnace for (minutes)?\n');
    sourcet=input('Which source was used?\n 1. GS-245        2. GS-139\n');
    if sourcet==1
        sheet='GS-245';
    elseif sourcet==2
        sheet='GS-139';
    end
    if sourcet==1
        source=input('Which source did you use?\n1. G245-1     2. G245-2\n3. TP-250     4. TP-470\n');
    elseif (sourcet==2) || (sourcet==3) || (sourcet==4)
        source=1;

    %Grabs the correct section of data 
    end
    collums=collumfinderb(sourcet,source,temp,time,s);
    if collums==-1
        collums=extractor(temp,time,source,sourcet);
    end

    if collums==-1
    error(('invalid paramters for source double check entered parameters match what is allowed with source and set as an option in this program.'))
    end
    
    coll=numtol(collums);
    coole=numtol(collums+s-1);
    colr=sprintf('%s:%s',coll,coole);
    try
        readmatrix(path,'sheet',sheet,'range',colr);
    catch
        warning('No such data exists or invalid path');
        path=input('please input a valid path\n');
    end
    
    try 
        readmatrix(path,'sheet',sheet,'range',colr);
    catch
        error('No such data exists')
    end
    
    filen=readmatrix(path,'sheet',sheet,'range',colr);
    tables(temp,time,source,sourcet,filen)
    wafn=max(filen(:,1));    

    %Grabs just the data relevent to the peak concentration and sheet
    %resistance and junction depth
    peakconcr=filen(4:end,28);
    sheetres=filen(4:end,25);
    junct=filen(4:end,27);
    %Records the average standard deviation and standard error from the

    [avgpeak,stdpeak,stepeak]=stat(peakconcr,wafn);
    [avgsheet,stdsheet,stesheet]=stat(sheetres,wafn);  
    [agjunc,stdjunc,stejunc]=stat(junct,wafn);
    %records time for file name
    t=datetime('now','InputFormat','yyyy-MM-dd');
    dat=string(t,"yyyy-MM-dd");

    %Creates a good file name
    name=sprintf('%d_%d_%d_%d.xlsx',temp,time,sourcet,source);
    part1="D:\dopingspring25\data\Stats\";
    file=part1+dat+"-"+name;


    %Prints data and titles to file
    writecell({"Junction depth"},file,'Sheet','Sheet1','Range','B1');
    writecell({"Peak concentration"},file,'Range','C1');
    writecell({"Sheet Resistance"},file,'Range','D1');
    writecell({"Average"},file,'Range','A2');
    writecell({"Standard Deviation"},file,'Range','A3');
    writecell({"Standard error"},file,'Range','A4');
    A=[agjunc;stdjunc;stejunc];
    B=[avgpeak;stdpeak;stepeak];
    C=[avgsheet;stdsheet;stesheet];
    D=[A,B,C];
    writematrix(D,file,'Range','B2:D4')
%%   
    fprintf('                           MEAN               Standard deviation      Standard error\njunction depth              %d            %d                           %d\nPeak concentration          %d            %d                            %d\nSheet Resistance            %d            %d                          %d\n',agjunc,stdjunc,stejunc,avgpeak,stdpeak,stepeak,avgsheet,stdsheet,stesheet);
end
%%
   restart=input('Do you wish to run again?\n1. Yes         2. No\n');
   clc
   if restart==1
     RUN_ME
   end

