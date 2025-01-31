% Pupose: Simulates the propagation of electromagnetic waves in a 2D grid.
% 
% PML used to prevent reflections from the edges of the simulation domain.

winstyle = 'docked';
% winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);   % impedance of free space

% Simulation Time, Frequency, and Grid Setup
tSim = 200e-15;                   % total simulation time (in seconds)
f = 230e12;                       % frequency of the wave (in Hz)
lambda = c_c/f;                   % wavelength (in meters)

xMax{1} = 20e-6;                  % maximum grid size in the x-direction
nx{1} = 200;                      % number of grid points in the x-direction
ny{1} = 0.75*nx{1};               % number of grid points in the y-direction


Reg.n = 1;

% Material Properties
mu{1} = ones(nx{1},ny{1})*c_mu_0; % permeability

epi{1} = ones(nx{1},ny{1})*c_eps_0; %permittivity
epi{1}(125:150,55:95)= c_eps_0*11.3; % region with different permittivity a.k.a inclusion
epi{1}(50:75,55:95)= c_eps_0*11.3;
epi{1}(75:125,95:105)= c_eps_0*11.3;
epi{1}(75:125,45:55)= c_eps_0*11.3;


sigma{1} = zeros(nx{1},ny{1}); % conductivity
sigmaH{1} = zeros(nx{1},ny{1}); % magnetic conductivity

dx = xMax{1}/nx{1};             % grid spacing in the x-direction
dt = 0.25*dx/c_c;               % time step
nSteps = round(tSim/dt*2);      % number of time steps
yMax = ny{1}*dx;                % maximum grid size in the y direction
nsteps_lamda = lambda/dx;       % 
    
movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

% Boundary Conditions and Plane Wave Source
bc{1}.NumS = 1;                  % number of sources
bc{1}.s(1).xpos = nx{1}/(4) + 1; % position of the source
bc{1}.s(1).type = 'ss';          % source type
bc{1}.s(1).fct = @PlaneWaveBC;

% Source parameters
% mag = -1/c_eta_0;
mag = 1;             % Magnitude of the source
phi = 0;             % Phase shift
betap = 0;
omega = f * 2 * pi;  % Angular frequency (2 * pi * frequency)
t0 = 30e-15;         % Time offset for the source
st = 15e-15;         % Temporal width of the source
s = 0;               % A parameter related to the source's position or other attributes
y0 = yMax / 2;       % Source’s y-position
sty = 1.5 * lambda;  % Spatial width of the source in the y-direction
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0,sty,'s'}; % Sets up the parameters of the source

Plot.y0 = round(y0/dx);

% Boundary conditions at the edges a for absorbing and e for electric
bc{1}.xm.type = 'a';
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'e';
bc{1}.yp.type = 'e';

% Perfectly Matched Layer for Boundary Absorption
pml.width = 20 * spatialFactor;
pml.m = 3.5;    % PML parameter to control the strength of absorption

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

RunYeeReg






