function AddDel_200(Ind_No)

global POP_STRUC
global ORG_STRUC
global OFF_STRUC

vacuum      = ORG_STRUC.vacuumSize(1);
minDistMat  = ORG_STRUC.minDistMatrice;
tournament  = ORG_STRUC.tournament;
atomType    = ORG_STRUC.atomType;

goodMutant = 0;
count = 1;
while goodMutant ~= 1

   count = count + 1;
   if count > 50
      disp('failed to do Heredity in 50 attempts, switch to Random');
      Random_200(Ind_No);
      break;
   end

   toPerMutate = find(tournament>RandInt(1,1,[0,max(tournament)-1]));
   ind = POP_STRUC.ranking(toPerMutate(end));
   cell         = POP_STRUC.POPULATION(ind).cell;
   numIons      = POP_STRUC.POPULATION(ind).Surface_numIons;
   lattice      = POP_STRUC.POPULATION(ind).Surface_LATTICE;
   coor         = POP_STRUC.POPULATION(ind).Surface_COORDINATES;
   bulk_lattice = POP_STRUC.POPULATION(ind).Bulk_LATTICE;
   bulk_pos     = POP_STRUC.POPULATION(ind).Bulk_COORDINATES;
   bulk_numIons = POP_STRUC.POPULATION(ind).Bulk_numIons;
  
   NDelete      = zeros(1,length(atomType));
   for i = 1: length(atomType)
       if ORG_STRUC.numIons(i) > 0
          if numIons(i) > 2
             NDelete(i) = min(3, floor(numIons(i)/2));
          else
             NDelete(i) = 1;
          end
       end
   end
   NAdd = NDelete;
   type = [];
   for i = 1:length(numIons)
       type = [type; atomType(i)*ones(numIons(i),1)];
   end

   [coor, type] = Delete_Atom(coor, type, NDelete, atomType);
   newCoords   = Add_Atom(lattice, coor, type, NAdd, atomType);
   surnumIons = ORG_STRUC.numIons*det(reshape(cell,[2,2]));

   [lat,candidate,numIons,chanAList] = makeSurface...
   (lattice, newCoords, surnumIons,bulk_lattice,bulk_pos,bulk_numIons, vacuum);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   goodMutant = distanceCheck (candidate,lat,numIons, minDistMat);

    if goodMutant == 1
        OFF_STRUC.POPULATION(Ind_No).cell= cell;
        OFF_STRUC.POPULATION(Ind_No).Bulk_LATTICE        = bulk_lattice;
        OFF_STRUC.POPULATION(Ind_No).Bulk_COORDINATES    = bulk_pos;
        OFF_STRUC.POPULATION(Ind_No).Bulk_numIons        = bulk_numIons;
        OFF_STRUC.POPULATION(Ind_No).Surface_COORDINATES = newCoords;
        OFF_STRUC.POPULATION(Ind_No).Surface_LATTICE     = lattice;
        OFF_STRUC.POPULATION(Ind_No).Surface_numIons     = surnumIons;
        OFF_STRUC.POPULATION(Ind_No).COORDINATES         = candidate;
        OFF_STRUC.POPULATION(Ind_No).numIons             = numIons;
        OFF_STRUC.POPULATION(Ind_No).LATTICE             = lat;
        OFF_STRUC.POPULATION(Ind_No).chanAList           = chanAList;
        OFF_STRUC.POPULATION(Ind_No).howCome             = 'Transmutate';
        info_parents = struct('parent', {},'N_Del', {},'N_Add',{}, 'enthalpy', {});
        info_parents(1).parent = num2str(POP_STRUC.POPULATION(ind).Number);
        info_parents.N_Del = NDelete;
        info_parents.N_Add = NAdd;
        info_parents.enthalpy = POP_STRUC.POPULATION(ind).Enthalpies(end)/sum(numIons);
        OFF_STRUC.POPULATION(Ind_No).Parents = info_parents;
        disp(['Structure ' num2str(Ind_No) '  generated by shuffling']);
    end
end

