fileName = '../audio/speech/acomic.wav';
[x, fs] = audioread(fileName);
z = zcr(x, fs);
avg = mean(z);
figure

subplot(2, 1, 1)
plot(x)
subplot(2, 1, 2)
plot(z)
