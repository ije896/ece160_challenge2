% features = ["ZCR" "SC" "SF"];
% stats = ["AVG" "VAR"];
% f_len= length(features);
% s_len = length(stats);
% % thresholds = zeros(f_len, s_len);
% % for feat = 1:f_len
% %     for stat = 1:s_len
% %         thresholds(feat, stat) = train_feature(features(feat), stats(stat));
% %     end
% % end

classes = cell(60,1);
for i = 1:60
    if(i<31)
        classes(i) = {'music'};
    else
        classes(i) = {'speech'};
    end
end

speech_train_dirName = '../audio/speech_train/';
music_train_dirName = '../audio/music_train/';
sp_train_dir = dir([speech_train_dirName filesep '*.wav']);
mu_train_dir = dir([music_train_dirName filesep '*.wav']);
total_train_files = 30;

train_data = zeros(60, 6);

for i = 1:total_train_files
    mu_file = strcat(music_train_dirName, mu_train_dir(i).name);
    [mu, mu_fs] = audioread(mu_file);
    mz = zcr(mu, mu_fs);
    msc = spec_cent(mu, mu_fs);
    msf = spec_flux(mu, mu_fs);
    train_data(i, 1) = mean(mz);
    train_data(i, 2) = mean(msc);
    train_data(i, 3) = mean(msf);
    train_data(i, 4) = var(mz);
    train_data(i, 5) = var(msc);
    train_data(i, 6) = var(msf);
end

for i = 1:total_train_files
    sp_file = strcat(speech_train_dirName, sp_train_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    sz = zcr(sp, sp_fs);
    ssc = spec_cent(sp, sp_fs);
    ssf = spec_flux(sp, sp_fs);
    train_data(i+total_train_files, 1) = mean(sz);
    train_data(i+total_train_files, 2) = mean(ssc);
    train_data(i+total_train_files, 3) = mean(ssf);
    train_data(i+total_train_files, 4) = var(sz);
    train_data(i+total_train_files, 5) = var(ssc);
    train_data(i+total_train_files, 6) = var(ssf);
end

filename = 'svm.mat';
SVMModel = fitcsvm(train_data, classes);
save(filename, 'classes', 'train_data', 'SVMModel')










