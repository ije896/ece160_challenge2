% zero-crossing rate (ZCR)
function zcr = zcr(audio, winSize, stepSize)
if (nargin < 3)
    stepSize = 1;
end
if (nargin < 2)
    winSize = 2;
    stepSize = 1;
end

winSize = winSize * 44100;
stepSize = stepSize * 44100;
a_len_sam = length(audio);
audio = audio/max(abs(audio(:)));
curr = 1;
% how many times are we going to calculate the windowed ZCR?
% as many frames as it takes to analyze all of the audio
numFrames = floor((a_len_sam-winSize)/stepSize) + 1;

% remove ",1"
zcr = zeros(numFrames, 1); % create empty array to fill with windowed zcr's
for i = 1:numFrames
    window = audio(curr:curr+winSize-1);
    % let's give ourselves a shifted array
    tmp = zeros(size(window));
    tmp(2:end) = window(1:end-1);
    % zcr = 1/N*(sign(x(i)) - sign(x(i-1)))
    zcr(i) = (1/winSize*2) * sum(abs(sign(window) - sign(tmp))); 
    curr = curr + stepSize;
end