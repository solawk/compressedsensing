%% Image

side = 64; % image side in pixels
n = side * side; % signal length
sr = 0.5; % sampling rate
p = floor(n * sr); % sampled length
%A = randn(p, n); % sensing matrix
A = sinusoidal_iterator(p * n, 5, p);
A = reshape(A, [p, n]);

xName = ".\Lenna_(test_image)_64.png";
x = imread(xName);
x = im2double(x);
x = x(:, :, 1);
x = reshape(x, [n, 1]);
xDCT = dct(x);

for i=1:n
    if abs(xDCT(i)) < 0.03
        xDCT(i) = 0; % Force pre-compression
    end
end
y = A * xDCT;

%% Generic signal
%{
n = 128 * 128;
sparsity = 0.04;
signal = full(sprand(n, 1, sparsity));

sr = 0.2;
p = floor(n * sr);
A = sinusoidal_iterator(p * n, 5, p);
A = reshape(A, [p, n]);
y = A * signal;
%}
%% Optimization

%{
cvx_begin;
    variable rx(n);
    minimize(norm(rx, 1));
    subject to 
        A * rx == y;
cvx_end;
%}
rx = SL0(y, A, 10, 8, 2.5);

%% Image inverse

xRestored = idct(rx);
xRestored = reshape(xRestored, [side, side]);

%% Signal plotting
%{
hold on
plot(signal);
plot(rx, 'o');
hold off
%}
%% Plotting

subplot(1, 3, 1); imshow(reshape(x, [side, side])); title("Original");
subplot(1, 3, 2); imshow(reshape(idct(xDCT), [side, side])); title("Pre-compressed");
subplot(1, 3, 3); imshow(xRestored); title("Restored");