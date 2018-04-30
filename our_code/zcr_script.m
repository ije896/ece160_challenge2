speech_dirName = '../audio/speech/';
music_dirName = '../audio/music/';
sp_dir = dir([speech_dirName filesep '*.wav']);
mu_dir = dir([music_dirName filesep '*.wav']);
total = length(sp_dir);
num_train = 25;
num_test  = 15;
mu_zcr = zeros(num_train, 1);
sp_zcr = zeros(num_train, 1);


% pseudo-training for model
for i = 1:num_train
    mu_file = strcat(music_dirName, mu_dir(i).name);
    sp_file = strcat(speech_dirName, sp_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    [mu, mu_fs] = audioread(mu_file);
    mu_z = zcr(mu, mu_fs);
    sp_z = zcr(sp, sp_fs);
    mu_zcr(i) = mean(mu_z);
    sp_zcr(i) = mean(sp_z);
end

% subplot(2, 1, 1)
% plot(mu_zcr)
% subplot(2, 1, 2)
% plot(sp_zcr)


mu_z_avg = mean(mu_zcr);
sp_z_avg = mean(sp_zcr);

mu_z_med = median(mu_zcr);
sp_z_med = median(sp_zcr);

thresh = (mu_z_avg + sp_z_avg) / 2;
thresh_med = (mu_z_med + sp_z_med) / 2;

mu_good = 0;
mu_bad = 0;
% test music
for i = 1:num_test
    mu_file = strcat(music_dirName, mu_dir(i).name);
    [mu, mu_fs] = audioread(mu_file);
    mu_z = zcr(mu, mu_fs);
    if mean(mu_z)<thresh
        mu_good = mu_good + 1;
    else
        mu_bad = mu_bad + 1;
    end
end

sp_good = 0;
sp_bad = 0;
% test speech
for i = (total-num_test+1):total
    sp_file = strcat(speech_dirName, sp_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    sp_z = zcr(sp, sp_fs);
    if mean(sp_z)>thresh
        sp_good = sp_good + 1;
    else
        sp_bad = sp_bad + 1;
    end
end

mu_perc = mu_good / num_test
sp_perc = sp_good / num_test


% fileName = '../audio/speech/acomic.wav';
% [x, fs] = audioread(fileName);
% z = zcr(x, fs);
% avg = mean(z);
% figure
% 
% subplot(2, 1, 1)
% plot(x)
% subplot(2, 1, 2)
% plot(z)
