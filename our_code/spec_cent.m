% spectral centroid
function sc = spec_cent(audio, fs, winSize, stepSize)
% normalize the audio
audio = audio/max(abs(audio(:)));
a_len_sam = length(audio);
if (nargin < 4)
    stepSize = 0.03;
end
if(nargin<3)
    stepSize = 0.03;
    winSize = 0.06;
end
if (nargin < 2)
    fs = 44100;
    winSize = 0.18;
    stepSize = 0.09;
end
winSize = winSize * fs;
stepSize = stepSize * fs;
curr = 1;
% same as zcr implementation
numFrames = floor((a_len_sam-winSize)/stepSize) + 1;
sc = zeros(numFrames, 1);
hamm = hamming(winSize);
% let's use a list of center bin frequencies
centers = ((fs/(2*winSize))*(1:winSize))';
for i = 1:numFrames
    % let's window the signal
    curr = cast(curr, 'uint32');
    window = hamm.*(audio(curr:curr+winSize-1));
    % calc a bit extra of the transform??
    transform = abs(fft(window, 2*winSize));
    transform = transform(1:winSize);
    % normalize it
    transform  = transform/max(transform);
    % algorithm follows:
    % sum(FFT * center_bin_freq) / sum(FFT)
    sc(i) = sum(centers.*transform)/sum(transform);
    % let's prune silence with noise from the transform
    if(sum(window.^2) < 0.010)
        sc(i) = 0;
    end
    curr = curr + stepSize;
end
% sc = sc/(fs);




