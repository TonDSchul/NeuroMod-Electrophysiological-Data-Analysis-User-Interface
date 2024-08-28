% Detects and removes artifacts from continuous neurophys data. Detection
% is based upon threshold crossing and zero crossings. Accepts multichannel
% data, assumes time to be first dim, channel dim 2.
%
% Parameters set in script!
%
% [arti]=epArtifact(wave,fs,outp,audit)
%
% arti   - output (bolean vector with true for artifacts,wave without 
%          artifacts or both in cell) artifact: 0 signal: 1
% wave   - csc data
% fs     - sampling rate
% outp   - 'wave','bool','both' Type of output. bool is default
% audit  - visual inspection: 1/0 / 0 default
%
% Example: [arti]=epArtifact(randn(10e3,5),1e3,'both',1);
%
% MTL 05.11.2013 - first version, audit unsupported


function [arti]=epArtifact(wave,fs,outp,RejectionInfo,Figure)

if size(wave,1)<5000
    msgbox('Data is short and can cause problems');
end

if fs<50
    msgbox('Fs too low, now LF rejection');
    lfr=0;
else
    lfr=1;
end

hlim=RejectionInfo.HFDetectionLimit; % HF detection limit 3 std
llim=RejectionInfo.ZeroCrossingLimit; %0.02 zero crossing limit 3 std [lower upper]

tl=abs(RejectionInfo.TimeBefore); %seconds to discard around LF artifact
th=abs(RejectionInfo.TimeAfter); %seconds to discard around HF artifact

%% metrics calculation
%s=std(wave,[],1); % std

%% Zero Crossing Deviance Detection
if lfr==1
    zc=zeros(ceil(size(wave,1)/fs),size(wave,2)); %second long snips for zero xings
    wl=floor(size(wave,1)/fs)*fs; %length of integer seconds
    
    if size(zc,1)==wl/fs %check if extra samples
        lflag=false;
    else
        lflag=true;
    end
 
    for kr=1:size(wave,2) %for all rows/channels
        t=reshape(wave(1:wl,kr),fs,wl/fs); %second snips
        t=mean(abs(diff(sign(t))),1); % DETECT ZERO XINGS
        zc(1:wl/fs,kr)=reshape(t,wl/fs,1);
  %      zc(1:wl/fs,kr)=zc(1:wl/fs,kr)-mean(zc(1:wl/fs,kr)); %remove mean
        if lflag
            zc(end,kr)=zc(end-1,kr); %copy artifact status for last sample
        end
            
    end
    
%     stdx=std(zc,[],1); %std 0xings
    
%     zc=bsxfun(@gt,zc,llim(2)*stdx)|bsxfun(@lt,zc,-llim(1)*stdx); %compare all the snips to threshold
      zc=bsxfun(@lt,zc,llim); %compare all the snips to threshold
    
end


%% STD Crossing Detection

tlim=hlim*median(abs(wave))/.6745; %calculate spike threshold similar to waveclus


tc=bsxfun(@gt,wave,tlim)|bsxfun(@lt,wave,-tlim); %get samples that exceed threshold SLOW

tc=filtfilt(ones(1,round(fs*th)+1),1,double(tc))>=1; %expand on both sides

if lfr==1
    zc=filtfilt(ones(1,round(1*tl)+1),1,double(zc))>=1; %expand on both sides

    tzc=resample(double([zeros(1,size(zc,2));zc]),fs,1,0)>.5; %nearest neighbor resampling
    tzc=tzc(round(fs)/2+1:end-round(fs)/2,:); %shift back
    arti=tc|tzc(1:size(tc,1),:); %unify 0xing and HF
else
    arti=tc;
end

arti=~arti; %ones where the signal should be kept

if ~isempty(strmatch(outp,{'wave','both'})) %#ok<*MATCH2>
    
    if ~isempty(strmatch(outp,{'both'}))
        arti={wave.*arti,arti}; % if both, put in both
    else
        arti=wave.*arti; %or only CSC
    end
end

%% Detect sequenences of zeros indicating events and set upo for plotting

[nrows, ncols] = size(arti{2});
zero_sequences = cell(1, ncols); % Initialize cell array to store indices

for ch = 1:ncols
    % Find indices of zeros in the current channel
    zeros_idx = find(arti{2}(:, ch) == 0);
    
    % Find sequences of consecutive zeros
    if ~isempty(zeros_idx)
        diffs = diff(zeros_idx);
        seq_start = [1; find(diffs > 1) + 1];
        seq_end = [find(diffs > 1); length(zeros_idx)];
        
        % Store indices of each sequence separately
        for k = 1:length(seq_start)
            zero_sequences{ch}{k} = zeros_idx(seq_start(k):seq_end(k));
        end
    end
end

% Initialize cell array to store waveform data for each sequence of zeros
wave_sequences = cell(1, ncols);

for ch = 1:ncols
    if ~isempty(zero_sequences{ch})
        for k = 1:length(zero_sequences{ch})
            % Extract waveform data according to zero indices
            wave_sequences{ch}{k} = wave(zero_sequences{ch}{k}, ch);
        end
    end
end

% Plotting the wave sequences for each channel and sequence
figure;
hold on;
for ch = 1:1
    if ~isempty(wave_sequences{ch})
        for k = 1:length(wave_sequences{ch})
            plot(wave_sequences{ch}{k});
            title(sprintf('Channel %d, Seq %d', ch, k));
        end
    end
end












ArtiIndex = arti{2};
DataToPlot = {};
for nchannel=1:size(wave,2)
    for nSequence = 1:length(zero_sequences{nchannel})
        DataToPlot{nchannel}{nSequence} = wave(zero_sequences{ch}{nSequence});
    end
end



























