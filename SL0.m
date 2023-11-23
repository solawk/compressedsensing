function x = SL0(y, A, K, L, mu)
    % Calculating the l2 norm
    % x = At * (A * At)^-1 * x
    At = transpose(A);
    AAt = A * At;
    invAAt = pinv(AAt);
    normLeft = At * invAAt;
    v = normLeft * y; % l2 minimization solution
    n = length(v);

    sigmaInitMult = 2;
    sigmaDecreaseMult = 0.5;
    sigma = max(abs(v) * sigmaInitMult);

    for k=1:K
        sigmaSqrDoubled = 2 * sigma * sigma;
        % Maximizing F
        % Initialization
        s = v;

        for j=1:L
            % Calculating ds
            ds = s;
            for i=1:n
                ds(i) = ds(i) * exp(-ds(i)*ds(i) / sigmaSqrDoubled);
            end

            % Nudging s
            s = s - mu * ds;

            % Projecting s
            s = s - normLeft * (A * s - y);
        end

        % Setting v back
        v = s;

        % Decreasing sigma
        sigma = sigma * sigmaDecreaseMult;
    end

    x = v;
end