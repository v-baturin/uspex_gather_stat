function Mutation_200(Ind_No)

% USPEX Version 7.4.1
global POP_STRUC
global ORG_STRUC
global OFF_STRUC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% CREATING Mutants by atom positions mutation%%%%%%%%%%%%%%%%%
vacuum      = ORG_STRUC.vacuumSize(1);
minDistMat  = ORG_STRUC.minDistMatrice;
tournament  = ORG_STRUC.tournament;
goodAtomMutant = 0;
count = 1;

while ~goodAtomMutant
    count = count + 1;
    if count > 50
       %disp('failed to do Permutation in 50 attempts, switch to Random');
       USPEXmessage(511,'',0);
       Random_200(Ind_No);
       break;
    end


    toMutate = find(tournament>RandInt(1,1,[0,max(tournament)-1]));
    ind = POP_STRUC.ranking(toMutate(end));
    cell        = POP_STRUC.POPULATION(ind).cell;
    surnumIons  = POP_STRUC.POPULATION(ind).Surface_numIons;
    surlat      = POP_STRUC.POPULATION(ind).Surface_LATTICE;
    surorder    = POP_STRUC.POPULATION(ind).Surface_order;
    surcoor     = POP_STRUC.POPULATION(ind).Surface_COORDINATES;
    bulklat     = POP_STRUC.POPULATION(ind).Bulk_LATTICE;
    bulkcoor    = POP_STRUC.POPULATION(ind).Bulk_COORDINATES;
    ntyp        = POP_STRUC.POPULATION(ind).Bulk_numIons;

    [MUT_COORD]= move_all_atom_Mutation(surcoor,surnumIons,surlat,surorder,0.5);
    N_Moved = sum(surnumIons);
    [lat,candidate,numIons,chanAList] = makeSurface(surlat,...
       MUT_COORD,surnumIons,bulklat,bulkcoor,ntyp,vacuum);
 
    [coor, composition] = getSurface(candidate, numIons, lat);
    goodAtomMutant = distanceCheck(coor,lat,composition,minDistMat);

    if goodAtomMutant == 1
        OFF_STRUC.POPULATION(Ind_No).Bulk_LATTICE        = bulklat;
        OFF_STRUC.POPULATION(Ind_No).Bulk_COORDINATES    = bulkcoor;
        OFF_STRUC.POPULATION(Ind_No).Bulk_numIons        = ntyp;
        OFF_STRUC.POPULATION(Ind_No).numIons             = numIons;
        OFF_STRUC.POPULATION(Ind_No).LATTICE             = lat;
        OFF_STRUC.POPULATION(Ind_No).COORDINATES         = candidate;
        OFF_STRUC.POPULATION(Ind_No).chanAList           = chanAList;
        OFF_STRUC.POPULATION(Ind_No).Surface_COORDINATES = MUT_COORD;
        OFF_STRUC.POPULATION(Ind_No).Surface_LATTICE     = surlat;
        OFF_STRUC.POPULATION(Ind_No).Surface_numIons     = surnumIons;
        OFF_STRUC.POPULATION(Ind_No).cell                = cell;
        info_parents = struct('parent', {},'N_Moved', {}, 'enthalpy', {});
        info_parents(1).parent = num2str(POP_STRUC.POPULATION(ind).Number);
        info_parents.N_Moved = N_Moved;
        info_parents.enthalpy = POP_STRUC.POPULATION(ind).Enthalpies(end)/sum(numIons);
        OFF_STRUC.POPULATION(Ind_No).Parents = info_parents;
        OFF_STRUC.POPULATION(Ind_No).howCome = 'CoorMutate';
        disp(['Structure ' num2str(Ind_No) '  generated by mutation']);
    end
end
%%%%%%%%%%%%%%% END creating mutants%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
