function W = sinusoidal_iterator(n, k, M)
    r = iterator_base(1 + (n-1) * k);
    W = zeros(n, 1);
    for i = 1:n
        W(i) = 0.5 - r(1 + (i-1) * k);
    end

    variance = var(W);
    mult = 1 / (sqrt(variance) * sqrt(M));
    W = W * mult;
end

function ws = iterator_base(n)
    w0 = 0.2;
    iterations = n;
    
    ws = zeros(iterations, 1);
    ws(1) = w0;
    for i = 2:iterations
        ws(i) = sin_iter(ws(i-1));
    end
end

function wn = sin_iter(w)
    alpha = 1;
    wn = alpha * sin(pi * w);
end