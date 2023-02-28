function SoftModeMutation_201(Ind_No)

% USPEX Version 8.1.4
% this is a mutation along the soft mode

global POP_STRUC
global ORG_STRUC
global OFF_STRUC

atomType   = ORG_STRUC.atomType;
dimension  = ORG_STRUC.dimension;
vacuum     = ORG_STRUC.vacuumSize(1);
minDist    = ORG_STRUC.minDistMatrice;
tournament = ORG_STRUC.tournament;
weight     = ORG_STRUC.weight;
N_val      = ORG_STRUC.NvalElectrons;
val        = ORG_STRUC.valences;
goodBond   = ORG_STRUC.goodBonds;
tolerance  = ORG_STRUC.toleranceFing;


goodAtomMutant = 0;
goodParent=0;
while ~goodParent
  goodParent=1;
  toMutate = find(ORG_STRUC.tournament>RandInt(1,1,[0,max(ORG_STRUC.tournament)-1]));
  ind = POP_STRUC.ranking(toMutate(end));
  if(sum(POP_STRUC.POPULATION(ind).Surface_numIons) == 0)
      goodParent = 0;
  end
end


cell        = POP_STRUC.POPULATION(ind).cell;
surnumIons  = POP_STRUC.POPULATION(ind).Surface_numIons;
surlat      = POP_STRUC.POPULATION(ind).Surface_LATTICE;
surcoor     = POP_STRUC.POPULATION(ind).Surface_COORDINATES;
bulklat     = POP_STRUC.POPULATION(ind).Bulk_LATTICE;
bulkcoor    = POP_STRUC.POPULATION(ind).Bulk_COORDINATES;
ntyp        = POP_STRUC.POPULATION(ind).Bulk_numIons;
FINGERPRINT = POP_STRUC.POPULATION(ind).FINGERPRINT;
N = sum(surnumIons);
flag=0;

for j = 1 : length(POP_STRUC.SOFTMODEParents)
    if (sum(abs((surnumIons)-(POP_STRUC.SOFTMODEParents(j).numIons)))>0) || (sum(abs(cell-(POP_STRUC.SOFTMODEParents(j).cell)))>0)
        dist_ij = 1;
    else
        dist_ij = cosineDistance(FINGERPRINT, POP_STRUC.SOFTMODEParents(j).fingerprint, weight);
    end
    if dist_ij < ORG_STRUC.toleranceFing
       flag=1;
       ID=j;
       break;
    end
end

[freq, eigvector] = calcSoftModes(surlat, surcoor, surnumIons, atomType, goodBond, N_val, val, dimension);
non_zero=0;

if flag == 1
   M2 = sum(eigvector(:,POP_STRUC.SOFTMODEParents(j).Softmode_num).^2);
   M4 = sum(eigvector(:,POP_STRUC.SOFTMODEParents(j).Softmode_num).^4);
   participation_ratio = M2/M4; % for more details see, f.e., S.Elliott book
   last_good = POP_STRUC.SOFTMODEParents(j).Softmode_Fre;

   for i = 1:length(freq)
       M2 = sum(eigvector(:,i).^2);
       M4 = sum(eigvector(:,i).^4);
       pr1 = M2/M4;
       if (freq(i) > (1.05)*last_good) || ((freq(i) >= last_good) && (abs(1-participation_ratio/pr1) > 0.05))
          non_zero = i;
          break
       end
   end
else          
   for i = 1:length(freq)        % first non zero element, should usually be 4       
       if freq(i) > 0.0000001
          non_zero = i;
          break;
       end
    end
end

if non_zero>0  %(the structure can not produce softmutation any more)
   loop = 0;
   current_freq = non_zero;
   good_freq = non_zero;
   for f = good_freq : non_zero + round((3*N-non_zero)/2)  % about middle of the freq spectra if we ignore the degeneracy
        if loop==1
           break
        else
            for i = 0 : 20
               if rand > 0.5
                  [MUT_LAT, MUT_COORD, deviation] = move_along_SoftMode_Mutation(surcoor, surnumIons, surlat,    eigvector(:,f), 1-i/21);
               else
                  [MUT_LAT, MUT_COORD, deviation] = move_along_SoftMode_Mutation(surcoor, surnumIons, surlat, -1*eigvector(:,f), 1-i/21);
               end
               [lat,candidate,numIons,chanAList] = makeSurface(MUT_LAT,MUT_COORD,surnumIons,bulklat,bulkcoor,ntyp,ORG_STRUC.vacuumSize(1));
               [coor, composition] = getSurface(candidate, numIons, lat);
               goodAtomMutant = distanceCheck(coor, lat, composition, minDist);
               if goodAtomMutant == 1
                  break;
               elseif (i == 21) && (f == non_zero + round((3*N-non_zero)/2))
                 break;         
               end
            end
         end
         good_freq=good_freq+1;
   end          % Loop: comparison with parent database
   if goodAtomMutant == 1
       OFF_STRUC.POPULATION(Ind_No).Bulk_LATTICE=bulklat;
       OFF_STRUC.POPULATION(Ind_No).Bulk_COORDINATES=bulkcoor;
       OFF_STRUC.POPULATION(Ind_No).Bulk_numIons=ntyp;
       OFF_STRUC.POPULATION(Ind_No).Surface_COORDINATES = MUT_COORD; 
       OFF_STRUC.POPULATION(Ind_No).Surface_LATTICE = MUT_LAT; 
       OFF_STRUC.POPULATION(Ind_No).Surface_numIons = surnumIons;
       OFF_STRUC.POPULATION(Ind_No).LATTICE = lat;
       OFF_STRUC.POPULATION(Ind_No).COORDINATES = candidate; 
       OFF_STRUC.POPULATION(Ind_No).numIons = numIons; 
       OFF_STRUC.POPULATION(Ind_No).chanAList = chanAList; 
       info_parents = struct('parent', {},'mut_degree', {},'mut_mode',{},'mut_fre',{}, 'enthalpy', {});
       info_parents(1).parent = num2str(POP_STRUC.POPULATION(ind).Number);
       info_parents.mut_degree = deviation;
       info_parents.mut_mode=f;
       info_parents.mut_fre=freq(f);
       info_parents.enthalpy = POP_STRUC.POPULATION(ind).Enthalpies(end)/sum(numIons);                 
       OFF_STRUC.POPULATION(Ind_No).Parents = info_parents;
       OFF_STRUC.POPULATION(Ind_No).cell = cell;             
       OFF_STRUC.POPULATION(Ind_No).howCome = 'softmutate';
       disp(['Structure ' num2str(Ind_No) '  generated by softmutation']);
       if flag == 1
           POP_STRUC.SOFTMODEParents(ID).Softmode_num=f;
           POP_STRUC.SOFTMODEParents(ID).Softmode_Fre=freq(f);
       else
           POP_STRUC.SOFTMODEParents(end+1).lattice=MUT_LAT;
           POP_STRUC.SOFTMODEParents(end).coordinates=surcoor;
           POP_STRUC.SOFTMODEParents(end).fingerprint=FINGERPRINT;
           POP_STRUC.SOFTMODEParents(end).Softmode_Fre=freq(f);
           POP_STRUC.SOFTMODEParents(end).Softmode_num=f;
           POP_STRUC.SOFTMODEParents(end).cell=cell;
           POP_STRUC.SOFTMODEParents(end).numIons=surnumIons;
       end
   else
       Mutation_201(Ind_No);
   end    
else
   Mutation_201(Ind_No);
end
