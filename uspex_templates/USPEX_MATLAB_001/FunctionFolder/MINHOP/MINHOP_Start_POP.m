function MINHOP_Start_POP()

global ORG_STRUC
global POP_STRUC

N_Step = length([ORG_STRUC.abinitioCode]);
POP_STRUC.DoneOrder = zeros(1, length(POP_STRUC.POPULATION));
POP_STRUC.finalOptimization = 0; % when = 1, we do 'final' optimization steps not preserving volume
for i = 1:length(POP_STRUC.POPULATION)
    POP_STRUC.POPULATION(i).Error = 0;
    POP_STRUC.POPULATION(i).Number = 0;
    POP_STRUC.POPULATION(i).Folder = 0;
    POP_STRUC.POPULATION(i).ToDo = 1;
    POP_STRUC.POPULATION(i).Done = 0;
    POP_STRUC.POPULATION(i).Softmode_num = 0;
    cell = POP_STRUC.POPULATION(i).superCell;
    POP_STRUC.POPULATION(i).LATTICE = POP_STRUC.lat;
    POP_STRUC.POPULATION(i).LATTICE(1,:) = POP_STRUC.lat(1,:)*cell(1);
    POP_STRUC.POPULATION(i).LATTICE(2,:) = POP_STRUC.lat(2,:)*cell(2);
    POP_STRUC.POPULATION(i).LATTICE(3,:) = POP_STRUC.lat(3,:)*cell(3);
    if isempty(POP_STRUC.POPULATION(i).Step)
       POP_STRUC.POPULATION(i).Step = 1;
       POP_STRUC.POPULATION(i).Enthalpies = 100000*ones(1, N_Step);
       POP_STRUC.POPULATION(i).K_POINTS = ones(N_Step, 3);
    end
end

