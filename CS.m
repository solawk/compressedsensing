clear all, close all, clc

%% Image

side = 128;
n = side * side; % signal length
sr = 0.3; % sampling rate
p = floor(n * sr); % sampled length
%A = randn(p, n); % sensing matrix
A = sinusoidal_iterator(p * n, 5, p);
A = reshape(A, [p, n]);

xName = "D:\Downloads\Lenna_(test_image)_128.png";
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

n = 128 * 128;
sparsity = 0.04;
signal = full(sprand(n, 1, sparsity));

sr = 0.2;
p = floor(n * sr);
A = sinusoidal_iterator(p * n, 5, p);
A = reshape(A, [p, n]);
y = A * signal;

%% Optimization

%{
cvx_begin;
    variable s_L1(n);
    minimize(norm(s_L1, 1));
    subject to 
        A * s_L1 == y;
cvx_end;
%}
s_L1 = SL0(y, A, 10, 8, 2.5);

%% Image inverse

xRestored = idct(s_L1);
xRestored = reshape(xRestored, [side, side]);

%% Signal plotting

hold on
plot(signal);
plot(s_L1, 'o');
hold off

%% Plotting

subplot(1, 3, 1); imshow(reshape(x, [side, side]));
subplot(1, 3, 2); imshow(reshape(idct(xDCT), [side, side]));
subplot(1, 3, 3); imshow(xRestored);