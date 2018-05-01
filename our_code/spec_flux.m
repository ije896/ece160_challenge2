% spectral flux
function sf = spec_flux(audio, fs, winSize, stepSize)
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
hamm = hamming(winSize);
sf = zeros(numFrames, 1);
sf(1) = 0;
prev_spectra = 0;
for i = 2:numFrames
    curr = cast(curr, 'uint32');
    window = hamm.*(audio(curr:curr+winSize-1));
    % calc a bit extra of the transform??
    transform = abs(fft(window, 2*winSize));
    transform = transform(1:winSize);
    % normalize it
    transform  = transform/max(transform);
    % a measure of how quickly power spectrum changes
    % (euclidean distance between two normalized spectra)
    sf(i) = sum((transform-prev_spectra).^2);
    prev_spectra = transform;
    curr = curr + stepSize;
end
end