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
            if strcmp(PreprocessingSteps(PPSteps),"Low-Pass")
                ftype = 'low';
                % Common parameters
                nyquist = Data.Info.NativeSamplingRate/2;
            else
                ftype = 'high';
                nyquist = Data.Info.NativeSamplingRate/2;
            end
            
            Wn = Cutoff / nyquist;  % Normalized cutoff
            
            if strcmp(PreProInfo.FilterType, "FIR-1")
                % FIR filter design

                filtkern = fir1(filterorder, Wn, ftype);
               
                % Compute power spectrum
                filtpow = abs(fft(filtkern)).^2;
                hz = linspace(0, (nyquist*2) / 2, floor(length(filtkern)/2)+1);
                filtpow = filtpow(1:length(hz));
                
                % Visualize
                figure()
                subplot(121)
                plot(filtkern, 'linew', 2)
                xlabel('Samples')

                title(['Filter kernel (fir1 - ' PreProInfo.FilterType ')'])
             
                axis square
                
                subplot(122), hold on
                plot(hz, filtpow, 'bs-', 'linew', 2, 'markerfacecolor', 'w')
                
                % Idealized shape
                if strcmp(ftype, "low")
                    idealX = [0, Cutoff, Cutoff, nyquist];
                    idealY = [1, 1, 0, 0];
                else  % highpass
                    idealX = [0 Cutoff Cutoff nyquist];
                    idealY = [0 0 1 1];
                end
                
                plot(idealX, idealY, 'ro-', 'linew', 2, 'markerfacecolor', 'w')
                
                plot([1 1]*Cutoff, get(gca, 'ylim'), 'r:')
                set(gca, 'xlim', [0 Cutoff*4])
                xlabel('Frequency (Hz)'), ylabel('Filter gain')
                legend({'Actual';'Ideal'})

                title('Frequency response')
             
            end
        
            if strcmp(PreProInfo.FilterType, "Butterworth IR")
                % Butterworth filter design
                % FIR filter design
                
                [b, a] = butter(filterorder, Wn, ftype);
                
                impulse_response = impz(b, a);
                
                
                nyquist = Data.Info.NativeSamplingRate/2;
                
                % Frequency response
                [filtresp, freq] = freqz(b, a, 1024, nyquist*2);
                filtpow = abs(filtresp).^2;
                hz = freq;
                
                % Visualize
                figure()
                subplot(121)
                stem(impulse_response, 'filled')
                xlabel('Samples')
                
                title(['Impulse response (butter - ' PreProInfo.FilterType ')'])
                
                axis square
                
                subplot(122), hold on
                plot(hz, filtpow, 'bs-', 'linew', 2, 'markerfacecolor', 'w')
                
                % Idealized shape
                if strcmp(ftype, "low")
                    idealX = [0, Cutoff, Cutoff, nyquist];
                    idealY = [1, 1, 0, 0];
                else  % highpass
                    idealX = [0 Cutoff Cutoff nyquist];
                    idealY = [0 0 1 1];
                end
                plot(idealX, idealY, 'ro-', 'linew', 2, 'markerfacecolor', 'w')
                
                plot([1 1]*Cutoff, get(gca, 'ylim'), 'r:')
                set(gca, 'xlim', [0 Cutoff*4])
                xlabel('Frequency (Hz)'), ylabel('Filter gain')
                legend({'Actual';'Ideal'})
                title('Frequency response')
                
            end
        else
            if strcmp(PreprocessingSteps(PPSteps),"Narrowband")
                
                if strcmp(PreProInfo.NarrowbandFilterType,"FIR-1")
                    if Data.Info.NativeSamplingRate <= 1000
                        nyquist = Data.Info.NativeSamplingRate/2;
                    else
                        % filter parameters
                        nyquist = 1000/2;
                    end
                    
                    % filter kernel
                    filtkern = fir1(filterorder,Cutoff/nyquist, 'bandpass');
                    
                    % compute the power spectrum of the filter kernel
                    filtpow = abs(fft(filtkern)).^2;
                    % compute the frequencies vector and remove negative frequencies
                    hz      = linspace(0,(nyquist*2)/2,floor(length(filtkern)/2)+1);
                    filtpow = filtpow(1:length(hz));
                    
                    %%% visualize the filter kernel
                    figure()
                    subplot(121)
                    plot(filtkern,'linew',2)
                    xlabel('Samples')
                    title(['Filter kernel (fir1) with ' num2str(nyquist*2) 'Hz samplerate'])
                    axis square
                    
                    % plot amplitude spectrum of the filter kernel
                    subplot(122), hold on
                    plot(hz,filtpow,'bs-','linew',2,'markerfacecolor','w')
                    plot([0 Cutoff(1) Cutoff Cutoff(2) nyquist],[0 0 1 1 0 0],'ro-','linew',2,'markerfacecolor','w')
                    
                    % dotted line corresponding to the lower edge of the filter cut-off
                    plot([1 1]*Cutoff(1),get(gca,'ylim'),'r:')
                    
                    % make the plot look nicer
                    set(gca,'xlim',[0 Cutoff(1)*4])%,'ylim',[-.05 1.05])
                    xlabel('Frequency (Hz)'), ylabel('Filter gain')
                    legend({'Actual';'Ideal'})
                    title(['Frequency response with ' num2str(nyquist*2) 'Hz samplerate']);
                end
                %% ----------------------------------- Butter
                if strcmp(PreProInfo.NarrowbandFilterType,"Butterworth IR")
                    
                    if Data.Info.NativeSamplingRate <= 1000
                        nyquist = Data.Info.NativeSamplingRate/2;
                    else
                        % filter parameters
                        nyquist = 1000/2;
                    end
                    
                    % Create bandpass Butterworth filter (narrowband)
                    [b, a] = butter(filterorder, Cutoff / nyquist, 'bandpass');  % Cutoff = [low high] in Hz
                    impulse_response = impz(b, a);
                    
                    % Frequency response of the filter
                    [filtresp, freq] = freqz(b, a, 1024, nyquist*2);
                    
                    % Power spectrum (squared magnitude of frequency response)
                    filtpow = abs(filtresp).^2;
                    
                    % Frequencies in Hz
                    hz = freq;
                    
                    %%% Visualize the filter coefficients
                    figure()
                    
                    subplot(121)
                    stem(impulse_response, 'filled')  % b = numerator (impulse response for FIR, coefficients for IIR)
                    xlabel('Samples')
                    xlabel('Amplitude')
                    title(['Filter impulse_response (butter) with ' num2str(nyquist*2) 'Hz samplerate'])
                    axis square
                    
                    % Plot amplitude spectrum of the filter
                    subplot(122), hold on
                    plot(hz, filtpow, 'bs-', 'linew', 2, 'markerfacecolor', 'w')
                    plot([0 Cutoff(1) Cutoff Cutoff(2) nyquist], [0 0 1 1 0 0], 'ro-', 'linew', 2, 'markerfacecolor', 'w')
                    
                    % Dotted line corresponding to the lower edge of the filter cut-off
                    plot([1 1]*Cutoff(1), get(gca, 'ylim'), 'r:')
                    
                    % Make the plot look nicer
                    set(gca, 'xlim', [0 Cutoff(1)*4])
                    xlabel('Frequency (Hz)'), ylabel('Filter gain')
                    legend({'Actual';'Ideal'})
                    title(['Frequency response with ' num2str(nyquist*2) 'Hz samplerate'])
                end
            end

            if strcmp(PreprocessingSteps(PPSteps), "Band-Stop")

                if Data.Info.NativeSamplingRate <= 1000
                    nyquist = Data.Info.NativeSamplingRate/2;
                else
                    % filter parameters
                    nyquist = 1000/2;
                end

                Wn = Cutoff / nyquist;  % Cutoff = [low, high] in Hz, normalized
            
                if strcmp(PreProInfo.BandStopFilterType, "FIR-1")
                    % FIR bandstop filter kernel
                    filtkern = fir1(filterorder, Wn, 'stop');
                    
                    % Power spectrum
                    filtpow = abs(fft(filtkern)).^2;
                    hz = linspace(0, (nyquist*2) / 2, floor(length(filtkern)/2)+1);
                    filtpow = filtpow(1:length(hz));
                    
                    % Visualize
                    figure()
                    subplot(121)
                    plot(filtkern, 'linew', 2)
                    xlabel('Samples')
                    title(['Filter kernel (fir1 - bandstop) with ',num2str(nyquist*2),'Hz samplerate'])
                    axis square
                    
                    subplot(122), hold on
                    plot(hz, filtpow, 'bs-', 'linew', 2, 'markerfacecolor', 'w')
                    
                    % Ideal band-stop filter shape (smooth transition for realism)
                    tw = diff(Cutoff) * 0.3;  % 30% transition width
                    idealX = [0, Cutoff(1)-tw, Cutoff(1), Cutoff(2), Cutoff(2)+tw, nyquist];
                    idealY = [1, 1, 0, 0, 1, 1];
                    plot(idealX, idealY, 'ro-', 'linew', 2, 'markerfacecolor', 'w')
                    
                    % Dotted lines at cutoff frequencies
                    plot([1 1]*Cutoff(1), get(gca, 'ylim'), 'r:')
                    plot([1 1]*Cutoff(2), get(gca, 'ylim'), 'r:')
                    
                    set(gca, 'xlim', [0, Cutoff(2)*4])
                    xlabel('Frequency (Hz)'), ylabel('Filter gain')
                    legend({'Actual','Ideal'})
                    title(['Frequency response with ',num2str(nyquist*2),'Hz samplerate'])
                end
            
                if strcmp(PreProInfo.BandStopFilterType, "Butterworth IR")
                    % Butterworth bandstop filter design
                    [b, a] = butter(filterorder, Wn, 'stop');
                    impulse_response = impz(b, a);
                    
                    % Frequency response
                    [filtresp, freq] = freqz(b, a, 1024, nyquist*2);
                    filtpow = abs(filtresp).^2;
                    hz = freq;
                    
                    % Visualize
                    figure()
                    subplot(121)
                    stem(impulse_response, 'filled')
                    xlabel('Samples')
                    title(['Impulse response (butter - bandstop) with ',num2str(nyquist*2),'Hz samplerate'])
                    axis square
                    
                    subplot(122), hold on
                    plot(hz, filtpow, 'bs-', 'linew', 2, 'markerfacecolor', 'w')
                    
                    % Ideal shape
                    tw = diff(Cutoff) * 0.3;
                    idealX = [0, Cutoff(1)-tw, Cutoff(1), Cutoff(2), Cutoff(2)+tw, nyquist];
                    idealY = [1, 1, 0, 0, 1, 1];
                    plot(idealX, idealY, 'ro-', 'linew', 2, 'markerfacecolor', 'w')
                    
                    plot([1 1]*Cutoff(1), get(gca, 'ylim'), 'r:')
                    plot([1 1]*Cutoff(2), get(gca, 'ylim'), 'r:')
                    
                    set(gca, 'xlim', [0, Cutoff(2)*4])
                    xlabel('Frequency (Hz)'), ylabel('Filter gain')
                    legend({'Actual','Ideal'})
                    title(['Frequency response with ',num2str(nyquist*2),'Hz samplerate'])
                end
            end



        end

    end
end