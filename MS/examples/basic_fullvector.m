
% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding

% Horizontal dimensions:
rh = 1.1;           % Ridge height
rw = 1.0;           % Ridge half-width
side = 1.5;         % Space on side

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

%Geometry Changes
rw_start = 1;   % Starting ridge half-width
rw_end = 1.0;       % Ending ridge half-width
rw_steps = 1;      % Number of steps from 0.325 to 1.0

% Material Changes
n2_start = 3.305;
n2_end = 3.44;
n2_steps = 10;

for n2 = linspace(n2_start, n2_end, n2_steps)
    fprintf('Calculating modes for ridge refractive index: %.3f\n', n2);

    % Iterate over the ridge half-width (rw) range
    for rw = linspace(rw_start, rw_end, rw_steps)
        fprintf('  Calculating modes for ridge half-width: %.3f\n', rw);

        % Generate the mesh based on the current n2 and rw
        [x, y, xc, yc, nx, ny, eps, edges] = waveguidemesh([n1, n2, n3], [h1, h2, h3], ...
                                                             rh, rw, side, dx, dy); 
        
        % Ensure proper mesh grid generation
        [X, Y] = meshgrid(y, x);  % Swap the order here: x is 1x305, y is 201x1 to get 201x305 double
        
        % Loop through modes (TE and TM)
        for mode_idx = 1:nmodes
            % Get the TE mode for the current mode index
            [Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx, dy, eps, '000A'); 
            
            % Display neff for the TE mode
            fprintf(1, 'TE mode %d: neff = %.6f\n', mode_idx, neff);
            
            % Create a new figure for TE mode (combined contourmode and surf plots)
            figure('Name', ['TE Mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2)]);  % New figure window
            
            % Plot the contourmode for Hx (TE mode) in the left column
            subplot(2, 2, 1);  % Top-left plot (Hx TE mode)
            contourmode(x, y, Hx(:,:,mode_idx));  % Custom contourmode function for Hx
            title(['Hx (TE mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            for v = edges, line(v{:}); end
            
            % Plot the contourmode for Hy (TE mode) in the right column
            subplot(2, 2, 2);  % Top-right plot (Hy TE mode)
            contourmode(x, y, Hy(:,:,mode_idx));  % Custom contourmode function for Hy
            title(['Hy (TE mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            for v = edges, line(v{:}); end
            
            % Plot the 3D surface plot for Hx (TE mode) in the third column
            subplot(2, 2, 3);  % Bottom-left plot (3D Hx TE mode)
            surf(X, Y, real(Hx(:,:,mode_idx)));  % Plot Hx using surf (3D surface)
            title(['Hx (TE mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            zlabel('Field Magnitude');
            shading interp;  % Smooth color transitions
            colorbar;        % Show color scale
            for v = edges, line(v{:}); end
            hold on;         % Hold the plot to overlay the contour
            contour(X, Y, real(Hx(:,:,mode_idx)), 20, 'LineColor', 'k');  % Contour plot over Hx
            hold off;        % Release the plot hold
            
            % Plot the 3D surface plot for Hy (TE mode) in the fourth column
            subplot(2, 2, 4);  % Bottom-right plot (3D Hy TE mode)
            surf(X, Y, real(Hy(:,:,mode_idx)));  % Plot Hy using surf (3D surface)
            title(['Hy (TE mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            zlabel('Field Magnitude');
            shading interp;  % Smooth color transitions
            colorbar;        % Show color scale
            for v = edges, line(v{:}); end
            hold on;         % Hold the plot to overlay the contour
            contour(X, Y, real(Hy(:,:,mode_idx)), 20, 'LineColor', 'k');  % Contour plot over Hy
            hold off;        % Release the plot hold
            
            % Get the TM mode for the current mode index
            [Hx, Hy, neff] = wgmodes(lambda, n2, nmodes, dx, dy, eps, '000S');
            
            % Display neff for the TM mode
            fprintf(1, 'TM mode %d: neff = %.6f\n', mode_idx, neff);
            
            % Create a new figure for TM mode (combined contourmode and surf plots)
            figure('Name', ['TM Mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2)]);  % New figure window
            
            % Plot the contourmode for Hx (TM mode) in the left column
            subplot(2, 2, 1);  % Top-left plot (Hx TM mode)
            contourmode(x, y, Hx(:,:,mode_idx));  % Custom contourmode function for Hx
            title(['Hx (TM mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            for v = edges, line(v{:}); end
            
            % Plot the contourmode for Hy (TM mode) in the right column
            subplot(2, 2, 2);  % Top-right plot (Hy TM mode)
            contourmode(x, y, Hy(:,:,mode_idx));  % Custom contourmode function for Hy
            title(['Hy (TM mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            for v = edges, line(v{:}); end
            
            % Plot the 3D surface plot for Hx (TM mode) in the third column
            subplot(2, 2, 3);  % Bottom-left plot (3D Hx TM mode)
            surf(X, Y, real(Hx(:,:,mode_idx)));  % Plot Hx using surf (3D surface)
            title(['Hx (TM mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            zlabel('Field Magnitude');
            shading interp;  % Smooth color transitions
            colorbar;        % Show color scale
            for v = edges, line(v{:}); end
            hold on;         % Hold the plot to overlay the contour
            contour(X, Y, real(Hx(:,:,mode_idx)), 20, 'LineColor', 'k');  % Contour plot over Hx
            hold off;        % Release the plot hold
            
            % Plot the 3D surface plot for Hy (TM mode) in the fourth column
            subplot(2, 2, 4);  % Bottom-right plot (3D Hy TM mode)
            surf(X, Y, real(Hy(:,:,mode_idx)));  % Plot Hy using surf (3D surface)
            title(['Hy (TM mode ' num2str(mode_idx) ', rw = ' num2str(rw) ', n2 = ' num2str(n2) ')']);
            xlabel('x');
            ylabel('y');
            zlabel('Field Magnitude');
            shading interp;  % Smooth color transitions
            colorbar;        % Show color scale
            for v = edges, line(v{:}); end
            hold on;         % Hold the plot to overlay the contour
            contour(X, Y, real(Hy(:,:,mode_idx)), 20, 'LineColor', 'k');  % Contour plot over Hy
            hold off;        % Release the plot hold
        end
    end
end
