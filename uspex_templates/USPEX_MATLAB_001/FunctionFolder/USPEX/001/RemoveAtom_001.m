function RemoveAtom_001(Ind_No)

% USPEX Version 10.1
global POP_STRUC
global ORG_STRUC
global OFF_STRUC
global AR_VARIANTS
global CLUSTERS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% CREATING offspring by removal atom %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

goodMutant = 0;
goodMutLattice = 0;
goodComposition = 0;

count = 0;
while goodComposition + goodMutant + goodMutLattice ~= 3
    [whichStructure, whichAtom] = find_candidate_remove();    
    
    count = count + 1;
    if (count > 1000) || (whichStructure == -1)
        %disp('failed to do removeAtom in 1000 attempts, switch to Random');
        USPEXmessage(508,'',0);
        Random_001(Ind_No);
        break;
    end

    ind = POP_STRUC.ranking(whichStructure);
    [goodComposition, COORD, numIons, LATTICE] = RemAtom(whichStructure, whichAtom);

    if goodComposition == 1
        goodMutant = distanceCheck(COORD,LATTICE,numIons,ORG_STRUC.minDistMatrice);
        if goodMutant == 1
            goodMutant = checkConnectivity(COORD,LATTICE,numIons);
        end

       if goodMutant == 1
          goodMutant = CheckOldOffspring(LATTICE, COORD, numIons, Ind_No, 'RemoveAtom_001');
       end
        
        goodMutLattice = 1; % since removing atom doesn't change it
        
        if goodMutant + goodMutLattice == 2
            OFF_STRUC.POPULATION(Ind_No).COORDINATES =  COORD;
            OFF_STRUC.POPULATION(Ind_No).LATTICE = LATTICE;
            OFF_STRUC.POPULATION(Ind_No).howCome = 'RemoveAtom';
            
            info_parents = struct('parent', {},'enthalpy', {});
            info_parents(1).parent = num2str(POP_STRUC.POPULATION(ind).Number);
            info_parents.enthalpy  = POP_STRUC.POPULATION(ind).Enthalpies(end)/sum(POP_STRUC.POPULATION(ind).numIons);
            OFF_STRUC.POPULATION(Ind_No).Parents = info_parents;
            OFF_STRUC.POPULATION(Ind_No).numIons = numIons;
            disp(['Structure ' num2str(Ind_No) ' generated by removeAtom; count=' num2str(count) ' ind=' num2str(ind) ' atom=' num2str(whichAtom)]);
        end
    end

    % now we write information in AR_VARIANTS and CLUSTERS structures
    %number of current structure in CLUSTERS database:
    i_clusters = AR_VARIANTS.number(whichStructure);
    
    if goodComposition == 0 %in this case probabilities of removing atom for all atoms with the same type = 0
        numIons_AR = AR_VARIANTS.Structure(whichStructure).numIons;
        typeAtom_AR = find_atomType(numIons_AR, whichAtom);
        for j = sum(numIons_AR(1:typeAtom_AR-1))+1 : sum(numIons_AR(1:typeAtom_AR))
            AR_VARIANTS.Structure(whichStructure).Atom(j).remove = 0;
            CLUSTERS.Structure(i_clusters).Atom(j).remove = 0;
        end
    else %probability of deleting current atom and all similar atoms = 0
        sim_atoms = find_similar_atoms(whichStructure, whichAtom);
        for j = 1 : length(sim_atoms)
            AR_VARIANTS.Structure(whichStructure).Atom(sim_atoms(j)).remove = 0;
            CLUSTERS.Structure(i_clusters).Atom(sim_atoms(j)).remove = 0;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% END creating offspring %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
