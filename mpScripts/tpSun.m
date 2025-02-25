% tpSun.m

% Blackbody spectrum of the Sun

% DOING PHYSICS WITH MATLAB: 
%   https://d-arora.github.io/Doing-Physics-With-Matlab/
% Documentation
%   http://www.physics.usyd.edu.au/teach_res/mp/doc/tpBlackbody.htm
% Download Scripts
%   http://www.physics.usyd.edu.au/teach_res/mp/mscripts/

% Ian Cooper
% email: matlabvisualphysics@gmail.com
% 191206

% Calls: simpson1d.m  ColorCode.m


close all
clear
clc


% *******************************************************************
% DEFINE THE KNOW VARIABLES (SI units)
% *******************************************************************

% Inputs 
% Wavelength at peak of Sun's spectral exitance in wavelenght  5.0225e-7 m
  wL_peak = 5.0225e-7;          
% Number of data points for wavelength range
  num = 801;                     

  % Constants
  c = 2.99792458e8;              % speed of light
  h = 6.62608e-34;               % Planck constant
  kB = 1.38066e-23;              % Boltzmann constant
  sigma = 5.6696e-8;             % Stefan constant  
  b_wL = 2.898e-3;               % Wien constant: wavelength
  b_f = 2.82*kB/h;               % Wien constant: frequency
  R_sun = 6.93e8;                % Radius: Sun
  R_SE = 1.496e11;               % Radius: Sun-Earth
  R_E = 6.374e6;                 % Radius: Earth
  I_0 = 1360;                    % Solar constant 
  albedo = 0.3;                  % Albedo: reflectivity of the Earth's surface


% *******************************************************************
% CALCULATE THE UNKNOWN VARIABLES (SI uniuts)
% *******************************************************************

% Sun's surface temperature  [K]
  T = b_wL/wL_peak;              
% Spectral exitance in wavelength  [W.m-2.m-1]
%  R_wL = zeros(num,1);    
% Spectral exitance in frequency  [W.m-2.s-1]  
%  R_f = zeros(num,1);            

% Frequency for peak in spectral exitance {Hz]
  f_peak = b_f * T;    
% Surface area of Sun and Earth [m2]
  A_sun = 4*pi*R_sun^2;          
  A_E = 4*pi*R_E^2;              
% Total power output of Sun
  P_sun = A_sun * sigma * T^4;   
  

% SPECTRAL EXITANCE in wavelength  [W.m-2.m-1] 
  wL1 = wL_peak/10;             % min for wavelength range  lambda1
  wL2 = 10*wL_peak;             % max for wavelength range  lambda2
  wL = linspace(wL1,wL2,num);   % wavelength 
  K1 = (h*c)/(kB*T);            % constants to simply calculation
  K2 = (2*pi*h*c^2);

  R_wL = K2 ./ (wL.^5 .* (exp(K1 ./ wL)-1));  

% SPECTRAL EXITANCE in visiable wavelength range [W.m-2.m-1] 
  wL1_vis = 400e-9;  wL2_vis = 700e-9; num_wL = 527;
  wL_vis = linspace(wL1_vis,wL2_vis,num_wL);    
  R_wL_vis = K2 ./ (wL_vis.^5 .* (exp(K1 ./ wL_vis)-1));
% Wavelength at Peak using logical operations
  wL_peak_graph = wL(R_wL == max(R_wL));       

% SPECTRAL EXITANCE in infrared wavelength range [W.m-2.m-1] 
  wL1_IR = 700e-9;  wL2_IR = wL2;
  wL_IR = linspace(wL1_IR,wL2_IR,num);    
  R_wL_IR = K2 ./ (wL_IR.^5 .* (exp(K1 ./ wL_IR)-1));

% SPECTRAL EXITANCE in ultraviolet wavelength range [W.m-2.m-1] 
  wL1_UV = wL1;  wL2_UV = 400e-9;
  wL_UV = linspace(wL1_UV,wL2_UV,num);    
  R_wL_UV = K2 ./ (wL_UV.^5 .* (exp(K1 ./ wL_UV)-1));

% Area under curves: power output of Sun  [W]
  P_total = A_sun * simpson1d(R_wL,wL1,wL2); 
  P_vis = A_sun * simpson1d(R_wL_vis,wL1_vis,wL2_vis);
  P_IR = A_sun * simpson1d(R_wL_IR,wL1_IR,wL2_IR);
  P_UV = A_sun * simpson1d(R_wL_UV,wL1_UV,wL2_UV);

% Percentage radiation in visible, IR and UV
  E_vis = 100 * P_vis / P_total;
  E_IR  = 100 * P_IR / P_total;
  E_UV = 100 * P_UV / P_total;
  

% SPECTRAL EXITANCE in frequency  [W.m-2.s-1]  
  f1 = f_peak/20;             % min for frequency range
  f2 = 5*f_peak;              % max for frequency range
  f = linspace(f1,f2,num);    % frequency
  K3 = h/(kB*T);              % constants to simply calcuation
  K4 = (2*pi*h/c^2);
  R_f = (K4 .* f.^3) ./ (exp(K3.*f)-1); 
  
% Frequency at Peak using logical operations
  f_peak_graph = f(R_f == max(R_f));    
% Spectral exitance in visible frequency range [W.m-2.s-1] 
  f1_vis = c/700e-9; f2_vis = c/400e-9; num_f = 111;
  f_vis = linspace(f1_vis,f2_vis,num_f);    
  R_f_vis = (K4 .* f_vis.^3) ./ (exp(K3.*f_vis)-1); 

% Area under curve   [W]
  P_f = A_sun * simpson1d(R_f,f1,f2); 
  

% SUN-EARTH --------------------------------------------------------
% Solar constant: Intensity of radiation at top of Earth's atmosphere
  I_E = P_total/(4*pi*R_SE^2);  % [W.m-2]   
% Power absorbed by Earth from Sun  [W]
  P_E = (1-albedo) * I_E * pi* R_E^2;   
% Temperature of the Earth  [K]
T_E = ((1-albedo)*I_E/(4*sigma))^0.25;  


% *******************************************************************
% GRAPHICS
% *******************************************************************

% Spectral Intensity - wL
figure(1)
 set(gcf,'units','normalized');
 set(gcf,'position',[0.02 0.05 0.3 0.3]);
 set(gcf,'color','w');
 
 h_area1 = area(wL,R_wL);
 set(h_area1,'FaceColor',[0 0 0]);
 set(h_area1,'EdgeColor','none');
 hold on

thisColorMap = hsv(128);
for cn = 1 : num_wL-1
  thisColor = ColorCode(wL_vis(cn));
  h_area = area(wL_vis(cn:cn+1),R_wL_vis(cn:cn+1));
  set(h_area,'FaceColor',thisColor);
  set(h_area,'EdgeColor',thisColor);
end
  xlabel('wavelength   \lambda   [ m ]');
  ylabel('R_{\lambda}   [ W.m ^{-2}.m^{-1}]');
  xlim([0 2.5e-6])
  set(gca,'fontsize',12)

% Spectral Intensity - f
figure(2)
  set(gcf,'units','normalized');
  set(gcf,'position',[0.02 0.45 0.3 0.3]);
  set(gcf,'color','w');
  h_area1 = area(f,R_f);
  set(h_area1,'FaceColor',[0 0 0]);
  set(h_area1,'EdgeColor','none');
  xlabel('frequency  f  [ Hz ]');
  ylabel('R_f   [ W.m ^{-2}.s ^{ -1} ]');
 hold on

thisColorMap = hsv(128);
for cn = 1 : num_f-1
  thisColor = thisColorMap(cn,:);
  h_area = area(f_vis(cn:cn+1),R_f_vis(cn:cn+1));
  set(h_area,'FaceColor',thisColor);
  set(h_area,'EdgeColor',thisColor);
end
 set(gca,'fontsize',12)
 
 
% *******************************************************************
% SCREEN OUPUT OF RESULTS
% *******************************************************************

clc
disp('    ');
disp('    ');
fprintf('Sun: temperature of photosphere, T_S = %0.0f  K \n',T); 
disp('    ');
disp('Peak in Solar Spectrum');
fprintf('   Theory: Wavelength at peak in spectral exitance, wL = %0.2e  m  \n',wL_peak); 
fprintf('   Graph:  Wavelength at peak in spectral exitance, wL = %0.2e  m  \n',wL_peak_graph); 
fprintf('   Corresponding frequency, f = %0.2e  Hz  \n',c/wL_peak_graph); 
disp('    ');
fprintf('   Theory: Frequency at peak in spectral exitance, f = %0.2e  Hz  \n',f_peak);
fprintf('   Graph:  Frequency at peak in spectral exitance, f = %0.2e  Hz  \n',f_peak_graph);
fprintf('   Corresponding wavelength, wL = %0.2e  m  \n',c/f_peak_graph); 
disp('    ');
disp('Total Solar Power Output')
fprintf('   P_Stefan_Boltzmann = %0.2e  W \n',P_sun);
fprintf('   P(wL)_total        = %0.2e  W \n',P_total);
fprintf('   P(f)_total         = %0.2e  W \n',P_f);
disp('   ');
disp('IR visible UV');
fprintf('   P_IR      = %0.2e  W  \n',P_IR); 
fprintf('   Percentage IR radiation      = %0.1f    \n',E_IR);
disp('    ');
fprintf('   P_visible = %0.2e  W \n',P_vis); 
fprintf('   Percentage visible radiation = %0.1f  \n',E_vis); 
disp('    ');
fprintf('   P_UV      = %0.2e  W  \n',P_UV); 
fprintf('   Percentage UV radiation      = %0.1f  \n',E_UV); 
disp('    ');
disp('Sun - Earth    ');
fprintf('   Theory: Solar constant I_O   = %0.3e  W/m^2  \n',I_0); 
fprintf('   Computed: Solar constant I_E = %0.3e  W/m^2  \n',I_E); 
disp(' ');
fprintf('   Surface temperature of the Earth, T_E  = %0.0f  K  \n',T_E); 
fprintf('   Surface temperature of the Earth, T_E  = %0.0f  deg C \n',T_E-273); 



