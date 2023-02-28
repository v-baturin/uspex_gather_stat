function Heredity_201(Ind_No)

% USPEX Version 6.6.1

global POP_STRUC
global ORG_STRUC
global OFF_STRUC

tournament = ORG_STRUC.tournament;
vacuum     = ORG_STRUC.vacuumSize(1);
minD       = ORG_STRUC.minDistMatrice;

CellList = load('Seeds/cell');
ID = ceil(rand()*size(CellList,1));
cell = CellList(ID,:);
OFF_STRUC.POPULATION(Ind_No).cell = CellList(ID,:);
info_parents = struct('parent', {},'fracFrac', {},'dimension', {},'offset', {}, 'enthalpy', {});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% CREATING Offspring with heredity %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

searching = 1;
count = 1;
while searching
    count = count + 1;
    if count > 30
       %disp('failed to do Heredity in 50 attempts, switch to Random');
       USPEXmessage(507,'',0);
       Random_201(Ind_No);
       break;
    end

    %choose one set of parents
    same = 1;
    % make sure you don't choose twice the same structure for this heredity
    while same
        par_one = find (tournament>RandInt(1,1,[0,max(tournament)-1]));
        par_two = find (tournament>RandInt(1,1,[0,max(tournament)-1]));
        ind1 = POP_STRUC.ranking(par_one(end));
        ind2 = POP_STRUC.ranking(par_two(end));
        if (sum(POP_STRUC.POPULATION(ind1).Surface_numIons) > 0) ...
       && ( sum(POP_STRUC.POPULATION(ind2).Surface_numIons) > 0)
            same = 0;
        end
    end

   %wait for suitable offspring (offspring fulfilling hard constraints)
   goodHeritage = 0;
   securityCheck = 0;
   while goodHeritage  ~=1

        securityCheck = securityCheck+1;
        offset=[];
        [surnumIons, Offspring, Lattice,fracFrac,dimension] = ...
                                  heredity_Make_201(ind1,ind2, cell);
        if isempty(Offspring)
           goodHeritage = 0;
        else
           %disp('Heredity_201')
           bulk_lat    =ORG_STRUC.bulk_lat;
           bulk_pos    =ORG_STRUC.bulk_pos;
           bulk_atyp   =ORG_STRUC.bulk_atyp;
           bulk_numIons=ORG_STRUC.bulk_ntyp;

           [bulk_pos, bulk_lat, bulk_numIons, Trans]=...
           Make_MultiCell(bulk_pos, bulk_lat, bulk_numIons, cell);
           [lat,candidate,numIons,chanAList] = makeSurface(Lattice,Offspring,surnumIons,...
                                         bulk_lat,bulk_pos, bulk_numIons, vacuum);
           %disp('surfaceafter GULP')
           %disp('1.0000')
           %disp(num2str(lat))
           %disp('Al O')
           %disp(num2str(numIons))
           %disp('direct')
           %disp(num2str(candidate))

           [coor, composition] = getSurface(candidate, numIons, lat);
           goodHeritage = distanceCheck(coor, lat, composition, minD);
        end

        if goodHeritage == 1
             OFF_STRUC.POPULATION(Ind_No).Bulk_LATTICE       = bulk_lat;
             OFF_STRUC.POPULATION(Ind_No).Bulk_numIons       = bulk_numIons;
             OFF_STRUC.POPULATION(Ind_No).Bulk_COORDINATES   = bulk_pos;
             OFF_STRUC.POPULATION(Ind_No).numIons            = numIons;
             OFF_STRUC.POPULATION(Ind_No).LATTICE            = lat;
             OFF_STRUC.POPULATION(Ind_No).COORDINATES        = candidate;
             OFF_STRUC.POPULATION(Ind_No).chanAList          = chanAList;
             OFF_STRUC.POPULATION(Ind_No).Surface_COORDINATES= Offspring;
             OFF_STRUC.POPULATION(Ind_No).Surface_LATTICE    = Lattice;
             OFF_STRUC.POPULATION(Ind_No).Surface_numIons    = surnumIons;
             fracFrac = [0 fracFrac 1];
             enthalpy = 0;
             parents = [ind1 ind2];
             ID = [];
             for i = 2:length(fracFrac)
                 ID= [ID POP_STRUC.POPULATION(parents(i-1)).Number];
                 E = POP_STRUC.POPULATION(parents(i-1)).Enthalpies(end);
                 ratio=fracFrac(i)-fracFrac(i-1);
                 enthalpy = enthalpy+E*ratio;
             end
             info_parents(1).parent = num2str(ID);
             info_parents.enthalpy  = enthalpy(end);
             info_parents.enthalpy  = info_parents.enthalpy/sum(numIons);
             info_parents.fracFrac  = fracFrac;
             info_parents.dimension = dimension;
             OFF_STRUC.POPULATION(Ind_No).Parents = info_parents;
             OFF_STRUC.POPULATION(Ind_No).howCome = ' Heredity ';

             disp(['Structure ' num2str(Ind_No) '  generated by heredity']);
            searching=0;
        end

        if securityCheck > 5
            %we won't wait for a good offspring forever, will we?
            break
        end
    end
end

