set(0, 'DefaultFigureWindowStyle', 'docked')
set(0, 'defaultaxesfontsize', 20)
set(0, 'defaultaxesfontname', 'Times New Roman')
set(0, 'DefaultLineLineWidth', 2)

% Grid size
nx = 51;
ny = 50;

% Electric Field
Emap = zeros(nx, ny);

% Sparse Matrix
G = sparse(nx*ny, nx*ny);

% Loop through the grid
for i = 1:nx
    for j = 1:ny

        % Mapping Equation
        n = j + (i-1)*ny;

        % Boundary Conditions (Dirichlet)
        if i == 1 || i == nx || j == 1 || j == ny
            G(n, :) = 0; 
            G(n, n) = 1;
        else
            % Bulk Nodes (5-point stencil)
            % Neighbors: nxm = left, nxp = right, nym = bottom, nyp = top
            nxm = j + (i-2)*ny;
            nxp = j + (i)*ny;
            nym = j-1 + (i-1)*ny;
            nyp = j+1 + (i-1)*ny;
          
            % Fill the sparse matrix
            if i > 10 && i < 20 && j > 10 && j < 20 % Change of material
                 G(n, n) = -2; 
            else
                 G(n, n) = -4;  
            end

            G(n, nxm) = 1;
            G(n, nxp) = 1; 
            G(n, nym) = 1; 
            G(n, nyp) = 1;
        end
    end
end

% Plot the sparse matrix (structure of the grid)
figure('Name', 'Sparse Matrix')
spy(G)

% Calculate the eigenvalues and eigenvectors
nmodes = 20;
[E, D] = eigs(G, nmodes, 'SM');

% Plot the eigenvalues
figure('Name', 'EigenValues')
plot(diag(D), '*')

% Plot the eigenmodes
np = ceil(sqrt(nmodes));  % Number of subplots
figure('Name', 'Modes')

% Plot all the possible modes
for k = 1:nmodes
    M = E(:,k);
    for i = 1:nx
        for j = 1:ny
            n = i + (j-1)*ny;
            Emap(i, j) = M(n);
        end
    end
    subplot(np, np, k), surf(Emap, 'linestyle', 'none')
    title(['EV = ' num2str(D(k,k))])
end
