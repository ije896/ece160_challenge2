function [mu_perc, sp_perc] = test_feature(feature, stat)
if nargin<2
    stat = 'AVG';
end
% stat = 'VAR';
% feature = 'SF';

speech_train_dirName = '../audio/speech_train/';
music_train_dirName = '../audio/music_train/';
sp_train_dir = dir([speech_train_dirName filesep '*.wav']);
mu_train_dir = dir([music_train_dirName filesep '*.wav']);
total_train_files = length(sp_train_dir);
% total_train_files = 25;

mu_train_results = zeros(total_train_files, 1);
sp_train_results = zeros(total_train_files, 1);


% pseudo-training for model
for i = 1:total_train_files
    mu_file = strcat(music_train_dirName, mu_train_dir(i).name);
    sp_file = strcat(speech_train_dirName, sp_train_dir(i).name);
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
            mu_train = spec_flux(mu, mu_fs);
            sp_train = spec_flux(sp, sp_fs);
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

% h(1) = subplot(2, 1, 1);
% histogram(mu_train_results, 10)
% title('Music SC Variance')
% ylabel('Occurrences')
% xlabel('SC Variance')
% h(2) = subplot(2, 1, 2);
% histogram(sp_train_results, 10)
% title('Speech SC Variance');
% ylabel('Occurrences')
% xlabel('SC Variance')
% linkaxes(h)
% xlim([0 0.005]) 

% take avg of whatever stat
mu_train_avg = mean(mu_train_results);
sp_train_avg = mean(sp_train_results);


thresh = (mu_train_avg + sp_train_avg) / 2;
% thresh = thresh-0.0254;
% thresh = thresh-125; % optimal sf_var


speech_test_dirName = '../audio/speech_test/';
music_test_dirName = '../audio/music_test/';
sp_test_dir = dir([speech_test_dirName filesep '*.wav']);
mu_test_dir = dir([music_test_dirName filesep '*.wav']);
total_sp_test_files = length(sp_test_dir);
total_mu_test_files = length(mu_test_dir);

mu_good = 0;
mu_bad = 0;
% test music
for i = 1:total_mu_test_files
    mu_file = strcat(music_train_dirName, mu_train_dir(i).name);
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

sp_good = 0;
sp_bad = 0;
% test speech
for i = 1:total_sp_test_files
    sp_file = strcat(speech_train_dirName, sp_train_dir(i).name);
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


mu_perc = mu_good / (total_mu_test_files) 
sp_perc = sp_good / (total_sp_test_files)

