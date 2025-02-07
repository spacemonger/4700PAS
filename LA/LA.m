set(0, 'DefaultFigureWindowStyle')

nx = 100;
ny = 100;
ni = 5000;
V = zeros(nx, ny);

% Boundary Conditions
% V(:, end) = 1;
% V(:, 1) = 0;


for k = 1:ni
    for m = 1:nx
        for n = 1:ny

            % Boundary Conditions
            V(1, n) = 1;             % Left Side
            V(nx, n) = 1;            % Right Side
            V(m, 1) = 0;    %V(m, 1);       % Bottom Side
            V(m, ny) = 0;   %V(m, ny-1);   % Top side
            % if m > 1 && n > 1 && m < nx && n < ny
            %     V(m,n) = (V(m+1,n) + V(m-1,n) + V(m,n+1) + V(m,n-1))/4;
            % end
        end
    end

    V = imboxfilt(V, 3); % Dont need the iteration method if you have this

    if mod(k, 50) == 0
        %surf(V')
        imagesc(V')  
        pause(0.05)
    end
end

[Ex, Ey] = gradient(V);

figure
quiver(-Ey', -Ex', 10)

