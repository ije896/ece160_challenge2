speech_dirName = '../audio/speech/';
music_dirName = '../audio/music/';
sp_dir = dir([speech_dirName filesep '*.wav']);
mu_dir = dir([music_dirName filesep '*.wav']);
total = length(sp_dir);
num_train = 40;
mu_sc = zeros(num_train, 1);
sp_sc = zeros(num_train, 1);


% pseudo-training for model
for i = 1:num_train
    mu_file = strcat(music_dirName, mu_dir(i).name);
    sp_file = strcat(speech_dirName, sp_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    [mu, mu_fs] = audioread(mu_file);
    mu_sc(i) = mean(spec_cent(mu, mu_fs));
    sp_sc(i) = mean(spec_cent(sp, sp_fs));
end

% subplot(2, 1, 1)
% plot(mu_zcr)
% subplot(2, 1, 2)
% plot(sp_zcr)


mu_sc_avg = mean(mu_sc);
sp_sc_avg = mean(sp_sc);

mu_sc_med = median(mu_sc);
sp_sc_med = median(sp_sc);

thresh = (mu_sc_avg + sp_sc_avg) / 2;
thresh_med = (mu_sc_med + sp_sc_med) / 2;

mu_good = 0;
mu_bad = 0;
% test music
for i = 1:total
    mu_file = strcat(music_dirName, mu_dir(i).name);
    [mu, mu_fs] = audioread(mu_file);
    mu_spec_cen = mean(spec_cent(mu, mu_fs));
    if mu_spec_cen<thresh
        mu_good = mu_good + 1;
    else
        mu_bad = mu_bad + 1;
    end
end

sp_good = 0;
sp_bad = 0;
% test speech
for i = 1:total
    sp_file = strcat(speech_dirName, sp_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    sp_spec_cen = mean(spec_cent(sp, sp_fs));
    if sp_spec_cen>thresh
        sp_good = sp_good + 1;
    else
        sp_bad = sp_bad + 1;
    end
end

mu_perc = mu_good / total 
sp_perc = sp_good / total


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
