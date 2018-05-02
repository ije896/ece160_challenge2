load('svm.mat')

test = zeros(20, 6);

% speech_test_dirName = '../audio/speech_test/';
% music_test_dirName = '../audio/music_test/';
% sp_test_dir = dir([speech_test_dirName filesep '*.wav']);
% mu_test_dir = dir([music_test_dirName filesep '*.wav']);
% total_sp_test_files = length(sp_test_dir);
% total_mu_test_files = length(mu_test_dir);

speech_train_dirName = '../audio/speech_train/';
music_train_dirName = '../audio/music_train/';
sp_train_dir = dir([speech_train_dirName filesep '*.wav']);
mu_train_dir = dir([music_train_dirName filesep '*.wav']);

for i = 31:40
    mu_file = strcat(music_train_dirName, mu_train_dir(i).name);
    [mu, mu_fs] = audioread(mu_file);
    mz = zcr(mu, mu_fs);
    msc = spec_cent(mu, mu_fs);
    msf = spec_flux(mu, mu_fs);
    test(i-30, 1) = mean(mz);
    test(i-30, 2) = mean(msc);
    test(i-30, 3) = mean(msf);
    test(i-30, 4) = var(mz);
    test(i-30, 5) = var(msc);
    test(i-30, 6) = var(msf);
end

for i = 31:40
    sp_file = strcat(speech_train_dirName, sp_train_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    sz = zcr(sp, sp_fs);
    ssc = spec_cent(sp, sp_fs);
    ssf = spec_flux(sp, sp_fs);
    test(i-20, 1) = mean(sz);
    test(i-20, 2) = mean(ssc);
    test(i-20, 3) = mean(ssf);
    test(i-20, 4) = var(sz);
    test(i-20, 5) = var(ssc);
    test(i-20, 6) = var(ssf);
end

% [label,score] = predict(SVMModel,test);