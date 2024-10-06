function Preprocess_Module_Inspect_Filter(Data,PreProInfo,PreprocessingSteps,PPSteps,SampleRate,A,B,Cutoff,filterorder,NonNan)

%________________________________________________________________________________________

%% Function to inspect filter kernel properties in the preprocessing window
% This function is called in the preprocessing window when the user presses
% the Inspect Filter button. It gets called in the
% Preprocess_Module_Apply_Pipeline.m function

% Input:
% 1. Data: data structure from main window dataset
% 2. PreProInfo: structure holding parameter for preprocessing steps
% applied to pipeline, comes from Preprocess_Module_Construct_Pipeline.m
% 3. PreprocessingSteps: string array holding steps added to the pipeline,
% comes from Preprocess_Module_Inspect_Filter
% 4. PPSteps: Current preprocessing step executed (comes from Preprocess_Module_Apply_Pipeline)
% 5. SampleRate: double in Hz
% 6. A: First coefficient from selected filter, double, comes from the fieldtrip
% filtering functions
% 7. B: Second coefficient from selected filter, double, comes from the fieldtrip
% filtering funcitons
% 8. Cutoff: double, cutoff frequency for filter in Hz
% 9. filterorder: double, selected filter order for filter
% 10. NonNan: Indicies where data is not nan (neurlynx can have nan in dataset)

% Author: Tony de Schultz
% Department systemsphysiology of learning, LIN Magdeburg.

%________________________________________________________________________________________

if isfield(PreProInfo,'FilterKernel')
    if PreProInfo.FilterKernel==1
        if strcmp(PreprocessingSteps(PPSteps),"Low-Pass") || strcmp(PreprocessingSteps(PPSteps),"High-Pass")
            %Plot fft
            figure(1);
            subplot(1,3,1)
            semilogy(abs(fft(double(Data.Preprocessed(1,NonNan)), [], 2).^2)'); grid on; xlabel('Frequency (Hz)'); ylabel("Power");
            title("FFT Filtered Signal")
            if ~ strcmp(PreprocessingSteps(PPSteps),"Narrowband") && ~strcmp(PreprocessingSteps(PPSteps),"Band-Stop")
                set(gca, 'xlim', [0 SampleRate/2])
            else
                set(gca, 'xlim', [Cutoff(1)-(Cutoff(1)/2) Cutoff(2)+(Cutoff(1)/2)])
            end
            set(gca,"FontSize",7)

            % Plot kernel over time
            subplot(1,3,2)
            % Estimate n_samples based on Cutoff and filterorder
            n_samples = round(max([SampleRate / Cutoff * 5, 6 * filterorder * SampleRate / Cutoff]));

            impulse = [zeros(1, n_samples), 1, zeros(1, n_samples)];
            Filterresult = filtfilt(B, A, impulse);
            
            %time vector negative and positive
            time = linspace(-n_samples, n_samples, length(impulse));
            time = time/SampleRate;
            % Plot the filter kernel (impulse response)
            plot(time, Filterresult, 'LineWidth', 1); xlabel('Time [s]'); ylabel('Amplitude'); title('Filter Kernel in Time Domain'); grid on;
            set(gca,"FontSize",7)

            % Plot kernel over frequence
            subplot(1,3,3)
            % Frequency response using freqz
            [H, Freq] = freqz(B, A, 1024, 'whole');  % 1024 points in the frequency response
            
            % Convert frequency to Hz
            Freq = Freq * SampleRate;  % Frequency vector in Hz
            
            % Compute gain (linear scale)
            gain = abs(H);  % Gain in linear scale

            plot(Freq, gain, 'LineWidth', 1);
            xlabel('Frequency (Hz)');
            ylabel('Gain');
            title('Filter Kernel in Frequency Domain');
            grid on;
            set(gca,"FontSize",7)

            xlim([0,SampleRate/2]);

        else
            %Plot fft
            figure(1);
            semilogy(abs(fft(double(Data.Preprocessed(1,NonNan)), [], 2).^2)'); grid on; xlabel('Frequency (Hz)'); ylabel("Power");
            title("FFT Filtered Signal")

            set(gca, 'xlim', [0 SampleRate/2])
            set(gca,"FontSize",7)
        end

        figure(2)

        if strcmp(PreprocessingSteps(PPSteps),"Low-Pass")
            d = designfilt("lowpassfir",'FilterOrder',filterorder, ...
            'CutoffFrequency',Cutoff,'SampleRate',SampleRate);
        elseif strcmp(PreprocessingSteps(PPSteps),"High-Pass")
            d = designfilt("highpassfir",'FilterOrder',filterorder, ...
            'CutoffFrequency',Cutoff,'SampleRate',SampleRate);
        elseif strcmp(PreprocessingSteps(PPSteps),"Narrowband")
            d = designfilt("bandpassiir",'FilterOrder',filterorder, ...
            'HalfPowerFrequency1',Cutoff(1),'HalfPowerFrequency2',Cutoff(2),'SampleRate',SampleRate);
        elseif strcmp(PreprocessingSteps(PPSteps),"Band-Stop")
            d = designfilt('bandstopiir', ...
            'FilterOrder', filterorder, ...              % Filter order
            'HalfPowerFrequency1', Cutoff(1), ... % Lower half-power frequency
            'HalfPowerFrequency2', Cutoff(2), ... % Upper half-power frequency
            'SampleRate', SampleRate);                 % Sampling frequency
        end

        freqz(d);

    end
end