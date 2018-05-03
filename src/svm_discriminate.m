% discriminates between speech and music for all files in a given directory
% Using all three features, ['ZCR', 'SC', and 'SF'], and SVM in the file 
% 'svm.mat' to label the new files
function label = svm_discriminate(audio_folder)
load('svm.mat', 'SVMModel')
audio_dir = dir([audio_folder filesep '*.wav']);
num_files = length(audio_dir);

test = zeros(num_files, 6);
for i = 1:num_files
    file_name = strcat(audio_folder, audio_dir(i).name);
    [au, fs] = audioread(file_name);
    mz = zcr(au, fs);
    msc = spec_cent(au, fs);
    msf = spec_flux(au, fs);
    test(i, 1) = mean(mz);
    test(i, 2) = mean(msc);
    test(i, 3) = mean(msf);
    test(i, 4) = var(mz);
    test(i, 5) = var(msc);
    test(i, 6) = var(msf);
end

label = predict(SVMModel,test);
end
