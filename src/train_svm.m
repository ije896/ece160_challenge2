% trains an SVM using all three features (Zero-crossing rate, Spectral
% Centroid, and Spectral Flux). Saves SVM and training results to 'svm.mat'

% --Inputs--
% speech_dir: directory containing speech training files
% music_dir: directory containing music training files
% (they both default to the provided training dirs)
function train_svm(speech_dir, music_dir)
if nargin<2
speech_dir = '../audio/speech_train/';
music_dir = '../audio/music_train/';
end
speech_train_dirName = speech_dir;
music_train_dirName = music_dir;
sp_train_dir = dir([speech_train_dirName filesep '*.wav']);
mu_train_dir = dir([music_train_dirName filesep '*.wav']);
num_sp = length(sp_train_dir);
num_mu = length(mu_train_dir);
total_train_files = num_sp+num_mu;

% build label file
classes = cell(total_train_files,1);
for i = 1:total_train_files
    if(i<num_mu+1)
        classes(i) = {'music'};
    else
        classes(i) = {'speech'};
    end
end

% gather music and speech training data
train_data = zeros(total_train_files, 6);
for i = 1:num_mu
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
for i = 1:num_sp
    sp_file = strcat(speech_train_dirName, sp_train_dir(i).name);
    [sp, sp_fs] = audioread(sp_file);
    sz = zcr(sp, sp_fs);
    ssc = spec_cent(sp, sp_fs);
    ssf = spec_flux(sp, sp_fs);
    train_data(i+num_mu, 1) = mean(sz);
    train_data(i+num_mu, 2) = mean(ssc);
    train_data(i+num_mu, 3) = mean(ssf);
    train_data(i+num_mu, 4) = var(sz);
    train_data(i+num_mu, 5) = var(ssc);
    train_data(i+num_mu, 6) = var(ssf);
end
% fit SVM
SVMModel = fitcsvm(train_data, classes);
filename = 'svm.mat';
save(filename, 'classes', 'train_data', 'SVMModel')










