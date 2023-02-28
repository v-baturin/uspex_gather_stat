function createORGDefault()

% USPEX Version 9.3.0
% new tags: dimension/varcomp/molecule
% deleted tags: supercomputer name

global ORG_STRUC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Create folders and stuff %%%%%%%%%%%%%%%%

[ORG_STRUC(1).homePath, ORG_STRUC(1).USPEXPath] = workingPath(); 

% defaults
ORG_STRUC.fixRndSeed   = 0;
ORG_STRUC.collectForces= 0;
ORG_STRUC.PhaseDiagram = 0;
ORG_STRUC.checkMolecules = 1;
ORG_STRUC.symmetrize = 0;
%ORG_STRUC.cor_dir = 1;
%ORG_STRUC.correlation_coefficient = 1;
ORG_STRUC.averageFitness = 1000000;
ORG_STRUC.constLattice = 0;
ORG_STRUC.varcomp = 0;
ORG_STRUC.spin    = 0;
ORG_STRUC.ldaU    = 0;
%ORG_STRUC.initialSoftMutFreq = 0;
ORG_STRUC.splitN = 0;
ORG_STRUC.paretoRanking = 0;    % Pareto ranking
ORG_STRUC.vacuumSize = 0;
ORG_STRUC.maxErrors = 2;
ORG_STRUC.sym_coef = 1;
ORG_STRUC.splitInto = 0;
ORG_STRUC.repeatForStatistics = 1;
ORG_STRUC.ordering = 1;
ORG_STRUC.minAngle = 55;   % NOW DEFAULT! (because of optLattice)
ORG_STRUC.minDiagAngle = 30;  % NOW DEFAULT! (because of optLattice)
ORG_STRUC.maxErrors = 2;
ORG_STRUC.bestFrac = 0.7;        % a fraction of a generation shall be included
ORG_STRUC.mutationRate = 0.5; % standard deviation of the epsilons in the lattice strain matrix
ORG_STRUC.numGenerations = 100; %
% how big a fraction of structures generated by heredity shall be shifted in all dimensions
ORG_STRUC.percSliceShift = 1.0; %
% 1 - the value of keepBestHM can vary during calculations with initial keepBestHM as upper bound
% 2 - clusterization algorithm used to keep exactly keepBestHM structures, as diverse as possible
ORG_STRUC.dynamicalBestHM = 2; %
ORG_STRUC.reoptOld = 0;  %reoptimize the old structures
ORG_STRUC.pickUpYN = 0;
ORG_STRUC.pickUpGen = 0;
ORG_STRUC.pickedUP  = 0;
ORG_STRUC.pickUpFolder = 0;
ORG_STRUC.pickUpNCount = 0;
%ORG_STRUC.volTimeConst = 0.25;   % put some default values in case we ever decide to return to them
%ORG_STRUC.volBestHowMany = 4;    % put some default values in case we ever decide to return to them
ORG_STRUC.remote = 0;
ORG_STRUC.numParallelCalcs = 1;


ORG_STRUC.pluginType = 0;         %  flat showing whether run with plugin code       ( COPEX compititable )
ORG_STRUC.startNextGen = 1;       %  flat showing whether start next generation      ( COPEX compititable )
ORG_STRUC.currentGenDone = 0;     %  flag showing whether current generation is done ( COPEX compititable )


ORG_STRUC.log_file = 'OUTPUT.txt';
ORG_STRUC.specificFolder = 'Specific';

% ****************************** %
% ****************************** %
% *        Abinit code         * %
% ****************************** %
% 1:vasp 2:siesta 3:gulp 4:lammps 5:NN 6:dmacrys 7:CP2K, 8:QE 9:FHIaims: 10:ATK  11:CASTEP 
ORG_STRUC.abinitioCode = 1; 

% ****************************** %
% ****************************** %
% *         Platform           * %
% *      0: Nonparallel        * %        
% *      1: local              * %    
% *      2: remote             * %
% *      3: CFN                * %
% *      4: QSH                * %
% *      5: QSH2               * % 
% *      6: xservDE            * %
% *      7: MIPT               * %    
ORG_STRUC.platform = 0;        
% ****************************** %
% ****************************** %
% *        optType             * %
% *      1:'enthalpy'          * %  
% *      2:'volume'            * %
% *      3:'hardness'          * % 
% *      4:'struc_order'       * %
% *      5:'density'           * %
% *      6:'diel_sus'          * %
% *      7:'gap'               * %
% *      8:'diel_gap'          * %
% *      9:'mag_moment'        * %
% *     10:'quasientropy'      * %
% *     11:'birefringence'     * %
% *     14:'power_factor'      * %
% *   1101:'K,  Bulk Modulus'          * %
% *   1102:'G,  Shear Modulus'         * %
% *   1103:'E,  Young`s Modulus'       * %
% *   1104:'v,  Poisson`s ratio'       * %
% *   1105:'G/K,Pugh`s modulus ratio'  * %
% *   1106:'Hv, Vicker hardness'       * %
% *   1107:'Kg, Fracture toughness'    * %
% *   1108:'D,  Debye temperature'     * %
% *   1109:'Vm, Mean sound velocity'   * %
% *   1110:'Vs, Velocity S-wave'       * %
% *   1111:'Vp, Velocity P-wave'       * %
ORG_STRUC.optType = 1;  % default - enthalpy
ORG_STRUC.opt_sign = 1; % maximumize or minimize

% ****************************** %
% ****************************** %
% *      CalcType(3 digits)    * %  
% *      dimension: 0-3        * %
% *      molecule : 0/1        * % 
% *      varcomp  : 0/1        * % 
ORG_STRUC.dimension = 3;
ORG_STRUC.molecule  = 0;
ORG_STRUC.varcomp   = 0;

% ****************************** % 
% ****************************** %
% *      Space Group           * %  
% Output symmetrized cif file
ORG_STRUC.symmetrize = 0;
% Space group determination tolerance
ORG_STRUC.SGtolerance = 0.10;
% coefficient between mindist and symmetrization distance (1 by default, sometimes > 1 needed)
 ORG_STRUC.sym_coef = 1;
% ****************************** %

% ****************************** %
% ****************************** %
% *     fingerprints           * %  
ORG_STRUC.RmaxFing = 10;
ORG_STRUC.deltaFing = 0.08;
ORG_STRUC.sigmaFing = 0.03;
ORG_STRUC.toleranceFing = 0.008;
ORG_STRUC.toleranceBestHM = 0.02;

% ****************************** %

% ****************************** %
% ****************************** %
% *     Antiseeds              * %  
% maximum of gaussian for antiseed correction
ORG_STRUC.antiSeedsMax = 0;
% sigma of gaussian for antiseed correction
ORG_STRUC.antiSeedsSigma = 0.001;
% how many generations wait to add antiseed if the best structure is not changing
ORG_STRUC.antiSeedsActivation = 5000;

% ****************************** %
% ****************************** %
% *     Surface                * %  
 ORG_STRUC.reconstruct = 1;
 ORG_STRUC.thicknessS  = 2.0;
 ORG_STRUC.thicknessB  = 3.0;

% ****************************** %
% ****************************** %
% *  Many Parents              * %  
ORG_STRUC.manyParents = 0;
ORG_STRUC.numParents = 2;
ORG_STRUC.minSlice = 2;
ORG_STRUC.maxSlice = 8;
% ****************************** %
% ****************************** %
% *  Fraction of variation     * %  
ORG_STRUC.AutoFrac = 0;
ORG_STRUC.fracGene = 0.5;
ORG_STRUC.fracG1ene = 0;
ORG_STRUC.fracRand = 0.2;
ORG_STRUC.fracRandTop = 0;
ORG_STRUC.fracAtomsMut = 0.1;
ORG_STRUC.fracLatMut = 0.0;
ORG_STRUC.fracRotMut = 0.1;
ORG_STRUC.fracTrans  = 0;
ORG_STRUC.fracPerm   = 0;
ORG_STRUC.fracAddAtom = 0;
ORG_STRUC.fracRemAtom = 0;
ORG_STRUC.fracSpin   = 0; 
ORG_STRUC.fracSecSwitch = 0;
ORG_STRUC.fracShiftBorder = 0;
% ****************************** %
% ****************************** %
% *  Thermoelectric property   * %
ORG_STRUC.TEparam.goal      = 'ZT';
ORG_STRUC.TEparam.threshold = 0.5;
ORG_STRUC.TEparam.Tmax      = 800.0;
ORG_STRUC.TEparam.Tdelta    = 50.0;
ORG_STRUC.TEparam.Tinterest = 300.0;
ORG_STRUC.TEparam.efcut     = 0.15;
% ************************************** %
% ************************************** %
% * Machine Learing based Prefiltering * %
ORG_STRUC.mlPeerFilter = 0;
ORG_STRUC.mlMinPopulation = 128;
ORG_STRUC.mlFilterRatio = 5;
% ORG_STRUC.mlTrain = 'uspexml train -m krr';
% ORG_STRUC.mlPredict = 'uspexml predict';
%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%
