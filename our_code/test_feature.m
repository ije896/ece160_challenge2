% function [mu_perc, sp_perc] = test_feature(feature, stat, num_train)
% if nargin<2
%     num_train = 25;
%     stat = 'AVG';
% end
% if nargin<3
% num_train = 25;
% end

% switch on feature 
% switch on stat
num_train = 25;
stat = 'VAR';
feature = 'ZCR';

speech_dirName = '../audio/speech/';
music_dirName = '../audio/music/';
sp_dir = dir([speech_dirName filesep '*.wav']);
mu_dir = dir([music_dirName filesep '*.wav']);
total_files = length(sp_dir);

mu_train_results = zeros(num_train, 1);
sp_train_results = zeros(num_train, 1);


% pseudo-training for model
for i = 1:num_train
    mu_file = strcat(music_dirName, mu_dir(i).name);
    sp_file = strcat(speech_dirName, sp_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    [mu, mu_fs] = audioread(mu_file);
    switch feature
        case 'SC'
            mu_train = spec_cent(mu, mu_fs);
            sp_train = spec_cent(sp, sp_fs);
        case 'ZCR'
            mu_train = zcr(mu, mu_fs);
            sp_train = zcr(sp, sp_fs);
        case 'SF'
            return;
    end
    switch stat
        case 'AVG'
            mu_train_results(i) = mean(mu_train);
            sp_train_results(i) = mean(sp_train);
        case 'VAR'
            mu_train_results(i) = var(mu_train);
            sp_train_results(i) = var(sp_train);
    end
end

% subplot(2, 1, 1)
% plot(mu_zcr)
% subplot(2, 1, 2)
% plot(sp_zcr)

% take avg of whatever stat
mu_train_avg = mean(mu_train_results);
sp_train_avg = mean(sp_train_results);

thresh = (mu_train_avg + sp_train_avg) / 2;
thresh = thresh-0.0254;

mu_good = 0;
mu_bad = 0;
% test music
for i = (num_train+1):total_files
    mu_file = strcat(music_dirName, mu_dir(i).name);
    [mu, mu_fs] = audioread(mu_file);
    switch feature
        case 'SC'
            test = spec_cent(mu, mu_fs);
        case 'ZCR'
            test = zcr(mu, mu_fs);
        case 'SF'
            return;
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

sp_good = 0;
sp_bad = 0;
% test speech
for i = (num_train+1):total_files
    sp_file = strcat(speech_dirName, sp_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    switch feature
        case 'SC'
            test = spec_cent(sp, sp_fs);
        case 'ZCR'
            test = zcr(sp, sp_fs);
        case 'SF'
            return;
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

mu_perc = mu_good / (total_files - num_train) 
sp_perc = sp_good / (total_files - num_train)


% fileName = '../audio/speech/acomic.wav';
% [x, fs] = audioread(fileName);
% z = spec_cent(x, fs);
% avg = mean(z);
% figure
% 
% subplot(2, 1, 1)
% plot(x)
% subplot(2, 1, 2)
% plot(z)
