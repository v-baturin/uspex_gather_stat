function Cell_transformation_001(whichInd)

global ORG_STRUC
global POP_STRUC

Step     = POP_STRUC.POPULATION(whichInd).Step;
N_Step   = length([ORG_STRUC.abinitioCode]);

LATTICE     = POP_STRUC.POPULATION(whichInd).LATTICE;
COORDINATES = POP_STRUC.POPULATION(whichInd).COORDINATES;
COORDINATES = moveCluster(LATTICE, COORDINATES);
[LATTICE,COORDINATES] = reduce_Cluster(LATTICE,COORDINATES);
if Step > N_Step 
   POP_STRUC.POPULATION(whichInd).Vol = det(LATTICE);
else
   [LATTICE,COORDINATES] = makeCluster(LATTICE,COORDINATES, ORG_STRUC.vacuumSize(Step));
   POP_STRUC.POPULATION(whichInd).LATTICE     = LATTICE;
   POP_STRUC.POPULATION(whichInd).COORDINATES = COORDINATES;
end      
