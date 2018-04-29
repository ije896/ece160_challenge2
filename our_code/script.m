fileName = '../audio/speech/acomic.wav';
[x, fs] = audioread(fileName);
z = zcr(x);

figure
plot(x)