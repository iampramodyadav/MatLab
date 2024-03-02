classdef GLOBAL
    properties
        covidData       %to store all data
        Country         %1st column, row start to end
        CountryIndex        
        State           %2nd column, row start to end (if present)
        StateIndex
        Date            %1st row, from 3rd column to end                     
    end 
    
    methods     
        
        function obj=GLOBAL(in)
            load covid_data.mat covid_data  %in mat file 1st column-Country, 2nd column=States
            obj.covidData=covid_data;
            obj.Country= covid_data(:,1);   %all row 1st column (in given mat file)
            obj.Date=covid_data(1,3:end);   %dates in 1st row, start from 3rd column to end
            
            obj.Country{1} = 'Global';
            
            [~,n]= ismember(obj.Country, in);   %we ignor logical values, but take no. of time country repeat
            [~,obj.CountryIndex] = max(n);     %ignor max value of each colum, but index of row where max found
            obj.StateIndex=obj.CountryIndex:(obj.CountryIndex+sum(n)-1); %state index
            obj.State=covid_data(obj.StateIndex,2);
            obj.State{1} = 'All';
        end

        function obj = globalCasesDeaths(obj)
            states=obj.covidData(:, 2);
            All=zeros(1,length(states));
            global_Cases = zeros(length(states), length(obj.Date));
            global_Deaths = zeros(length(states), length(obj.Date));
            for i= 1:length(states)
                if isempty(states{i})
                    All(i) = i;
                end
            end
            for n = 1:length(states)
                if All(n) ==0
                    continue;
                else
                    for m = 3:length(obj.Date)+2
                        global_Cases(n,m-2)= obj.covidData{n,m}(1,1);
                    end
                    for k=3:length(obj.Date)+2
                        global_Deaths(n,k-2)=obj.covidData {n,k}(1,2);
                    end
                end
            end
            obj = [sum(global_Cases);sum(global_Deaths)]; %matrix of cases and deaths
        end
           %vectorization of cases     
        function obj = Cases_Vector(obj,v)      %
            CasesVect=zeros(1,length(obj.Date));
            for m=3:length(obj.Date)+2
                CasesVect(m-2) = obj.covidData{v,m}(1 ,1);
            end
            obj = CasesVect;
        end
        %vectorization of deaths
        function obj = Deaths_Vector(obj,u)
            DeathsVect=zeros(1,length(obj.Date));
            for ii=3: length(obj.Date) +2
                DeathsVect(ii-2)=obj.covidData{u,ii}(1,2);
            end
            obj=DeathsVect;
        end
        
    end
end
