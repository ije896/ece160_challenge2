% spectral centroid (SC)

% --Inputs--
% audio: matrix containing audio (extracted from audioread(file)
% fs(hz) : sampling frequency of audio matrix
% winSize(s): window size for calculating the spectral centroid
% stepSize(s): step size for iterative windowing

% --Output--
% sc: matrix of temporal spectral centroid values for the given audio matrix
function sc = spec_cent(audio, fs, winSize, stepSize)
% normalize the audio
audio = audio/max(abs(audio(:)));
a_len_sam = length(audio);
if (nargin < 4)
    stepSize = 0.1;
end
if(nargin<3)
    stepSize = 0.1;
    winSize = 0.2;
end
if (nargin < 2)
    fs = 44100;
    winSize = 0.2;
    stepSize = 0.1;
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
    % let's prune noise from the transform
    if(sum(window.^2) < 0.010)
        sc(i) = 0;
    end
    % advance the window
    curr = curr + stepSize;
end
sc = sc/(fs);
end



