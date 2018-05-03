% Tests the relative accuracy of a single feature and a single
% statistic on the provided speech_test and music_test files

% --Inputs--
% thresh: threshold that separates speech from music in 1-D classification
% feature: one of three ['ZCR', 'SC', 'SF']
% stat: one of two ['AVG', 'VAR'], defaults to 'AVG'

% --Outputs--
% mu_perc: percentage of music files accurately classified
% sp_perc: percentage of speech files accurately classified
function [mu_perc, sp_perc] = test_feature_thresh(thresh, feature, stat)
if nargin < 3
    stat = 'AVG';
end
% setup our directories
speech_test_dirName = '../audio/speech_test/';
music_test_dirName = '../audio/music_test/';
sp_test_dir = dir([speech_test_dirName filesep '*.wav']);
mu_test_dir = dir([music_test_dirName filesep '*.wav']);
total_sp_test_files = length(sp_test_dir);
total_mu_test_files = length(mu_test_dir);

% test music
mu_good = 0;
mu_bad = 0;
for i = 1:total_mu_test_files
    mu_file = strcat(music_test_dirName, mu_test_dir(i).name);
    [mu, mu_fs] = audioread(mu_file);
    switch feature
        case 'SC'
            test = spec_cent(mu, mu_fs);
        case 'ZCR'
            test = zcr(mu, mu_fs);
        case 'SF'
            test = spec_flux(mu, mu_fs);
    end
    switch stat
        case 'AVG'
            mu_test = mean(test);
        case 'VAR'
            mu_test = var(test);
    end
    if mu_test<thresh
        mu_good = mu_good + 1;
    else
        mu_bad = mu_bad + 1;
    end
end

% test speech
sp_good = 0;
sp_bad = 0;
for i = 1:total_sp_test_files
    sp_file = strcat(speech_test_dirName, sp_test_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    switch feature
        case 'SC'
            test = spec_cent(sp, sp_fs);
        case 'ZCR'
            test = zcr(sp, sp_fs);
        case 'SF'
            test = spec_flux(sp, sp_fs);
    end
    switch stat
        case 'AVG'
            sp_test = mean(test);
        case 'VAR'
            sp_test = var(test);
    end
    if sp_test>thresh
        sp_good = sp_good + 1;
    else
        sp_bad = sp_bad + 1;
    end
end
% return raw accuracy of classification
mu_perc = mu_good / (total_mu_test_files); 
sp_perc = sp_good / (total_sp_test_files);

end