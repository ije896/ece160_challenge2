% Calculates the discriminating threshold for a given feature and a given
% statistic on the files in the dirs speech_train and _music_train

% this function assumes there are an equal number of music and speech 
% samples in both dirs

% --Inputs--
% feature: one of three ['ZCR', 'SC', 'SF']
% stat: one of two ['AVG', 'VAR'], defaults to 'AVG'

% --Output--
% thresh: dividing 1-D threshold value for a given feature and stat
function thresh = find_feature_thresh(feature, stat)
if nargin<2
    stat = 'AVG';
end

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
% % this was for graphing our results
% 
% h(1) = subplot(2, 1, 1);
% histogram(mu_train_results, 10)
% title('Music SF Variance')
% ylabel('Occurrences')
% xlabel('SF Variance')
% h(2) = subplot(2, 1, 2);
% histogram(sp_train_results, 10)
% title('Speech SF Variance');
% ylabel('Occurrences')
% xlabel('SF Variance')
% linkaxes(h)
% xlim([0 1600]) 

% take avg of whatever stat
mu_train_avg = mean(mu_train_results);
sp_train_avg = mean(sp_train_results);

thresh = (mu_train_avg + sp_train_avg) / 2;
% thresh = thresh-0.0254;
% thresh = thresh-125; % optimal sf_var
