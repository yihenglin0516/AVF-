%% this program is about segementing the blood flow sound manually 
% and add marker inside 
clear;
dirName = "C:\Users\david\summer_intern\超音波音檔\音檔3\" ; 
outputdirName="C:\Users\david\summer_intern\超音波音檔\音檔3\" ;
% read the file list 
fileList = dir(strcat(dirName,'*.wav')) ;
% filter setting 
fs = 8000;
Wp = 3/fs ;
Ws = 20/fs;
Rp=3;
Rs=60;
[n,Wp] = cheb1ord(Wp,Ws,Rp,Rs);
[b,a] = cheby1(n,Rp,Wp);
for index = 1:length(fileList)
    file = fileList(index) ; 
    [audio,fs] = audioread(strcat(file.folder,"\",file.name));
    outputFileName =strcat(outputdirName,file.name(1:7)) ; 
    mkdir(outputFileName)
    t = 1/fs : 1/fs : length(audio)/fs ; 
    %homomorphic filtering
    % filter setting 
    Wp = 5/fs ;
    Ws = 20/fs; 
    Rp=3;
    Rs=60;
    [n,Wp] = cheb1ord(Wp,Ws,Rp,Rs);
    [b,a] = cheby1(n,Rp,Wp);
    % high pass filtering 
    audio_high = highpass(audio,40,fs) ; 
    % calculate shannon energy 
    x=-audio_high.^2.*log(audio_high.^2+0.0001);
    z = log(abs(x)+0.00001) ; 
    z1=filtfilt(b,a,z);
    a_n = exp(z1);
    [pks,locs] = findpeaks(-a_n,"MinPeakDistance",0.5*fs);
    % plot to check 
    figure;
    plot(t,x)
    hold on 
    plot(t,a_n,"r","LineWidth",2);
    scatter(locs/fs,a_n(locs),'ko')
    legend("shannon energy","envelope","local minima")
    for i = 2:length(locs)-1
        output = audio(locs(i):locs(i+1)) ;
        audiowrite(strcat(outputFileName,'\',string(i-1),'.wav'),output,fs);
    end 
    disp(file.name)
    
    keyboard
    
    
end 