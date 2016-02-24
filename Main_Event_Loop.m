function Main_Event_Loop(dspIQ_RX, dspAudioIn, dspIQ_TX, dspAudioOut, params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    global F_radio;
    global F_os;
    global Ftune;
    global updateIF;
    global updateRadioFreq;
    global quit;
    global PTT;
    global mode;
    global newMode;
    global noiseFilter;

    noiseFilter = 'None';
    mode = 'USB';
    newMode = false;
    PTT = false;
    quit = false;
    updateIF = false;
    updateRadioFreq = false;
    
    srSetFreq(params.F_radio_initial, params.SR_DLL_NAME);
    F_radio = srGetFreq(params.SR_DLL_NAME);
    F_os = 20e3;
    F_IF_BW = params.F_IF_HighFreqCutOff - params.F_IF_LowFreqCutOff;
    Ftune = F_radio + F_os;
    F_IF = Ftune-F_radio;
    
   [gui_text_freq] = CreateGUI(params);
    
    %% Setup filers
    hBaseBandSpectrum = dsp.SpectrumAnalyzer('FrequencyOffset', 0,...
                                         'PlotAsTwoSidedSpectrum', true,...
                                          'SampleRate', params.Fs_audio,...
                                          'SpectralAverages', params.SpecAverages,...
                                          'FrequencyResolutionMethod', 'RBW',...
                                          'RBWSource', 'Property',...
                                          'RBW', params.RBW,...
                                          'Title', 'Base Band Power Spectrum',...
                                          'YLimits', [-80 0]);    
    
    hWaterfall = dsp.SpectrumAnalyzer('FrequencyOffset', F_radio,...
                                         'PlotAsTwoSidedSpectrum', true,...
                                          'SampleRate', params.Fs_radio,...
                                          'SpectralAverages', params.SpecAverages,...
                                          'FrequencyResolutionMethod', 'RBW',...
                                          'RBWSource', 'Property',...
                                          'RBW', params.RBW,...
                                          'SpectrumType', 'Spectrogram',....
                                          'Title', 'Radio Power Spectrum',...
                                          'TimeResolutionSource', 'Property',...
                                          'TimeResolution', params.WaterfallRate);
                                      
    hSpectrum = dsp.SpectrumAnalyzer('FrequencyOffset', F_radio,...
                                         'PlotAsTwoSidedSpectrum', true,...
                                          'SampleRate', params.Fs_radio,...
                                          'SpectralAverages', params.SpecAverages,...
                                          'FrequencyResolutionMethod', 'RBW',...
                                          'RBWSource', 'Property',...
                                          'RBW', params.RBW,...
                                          'Title', 'Radio Power Spectrum',...
                                          'YLimits', [-80 0]);                               
    
    hSRC = dsp.SampleRateConverter('Bandwidth', params.Fs_audio/2,...
                                  'InputSampleRate', params.Fs_radio,...
                                  'OutputSampleRate', params.Fs_audio);                                  
                                      
    % Design IF filter
    % This is a complex filter that is not symmetric about DC
    % Start with a low pass filter, then complex frequency shift to desired
    % center frequency.
    Fp = 0.1; % Doesn't seem to do anything
    Fc = F_IF/(params.Fs_radio/2); % Frequency shift of low pass
    [b,a] = ellip(7,0.2,80,F_IF_BW/params.Fs_radio);
    [Num,Den,~,~] = iirlp2bpc(b, a, Fp, [Fc-Fp, Fc+Fp]); % Shift filter response
    dspIFfilt = dsp.IIRFilter; % Create DSP object
    dspIFfilt.Numerator = Num; % Load in new parameters
    dspIFfilt.Denominator = Den;
    
    % Hilbert transform filter (90 deg phase shift)
    N_hilbert_order = 100;
    hHilbert = design(fdesign.hilbert('N,TW',N_hilbert_order,0.025), 'equiripple');
    %fvtool(hHilbert,'magnitudedisplay','zero-phase','frequencyrange','[-pi, pi)')
    
    % Delay to counteract the Hilbert filter
    hDelay = dsp.Delay(N_hilbert_order/2);
    
    %% Main signal processing loop
    tvec = linspace(0, (params.SAMPLES_PER_FRAME_RADIO-1)/params.Fs_radio, params.SAMPLES_PER_FRAME_RADIO).';
    % Keep track of frame number for time domain processing
    t=0;
    while quit == false
        % Compute time vector for time-domain operations
        Tt = t*params.SAMPLE_TIME+tvec;
        
        if updateIF || updateRadioFreq
            updateIF = false;
            updateRadioFreq = false;
            
            % Set radio frequency
            srSetFreq(F_radio, params.SR_DLL_NAME);
            % Get actual set frequency incase there is a discrepency
            F_radio = srGetFreq(params.SR_DLL_NAME);
            
            % Updating local frequencies
            F_IF_BW = params.F_IF_HighFreqCutOff - params.F_IF_LowFreqCutOff;
            Ftune = F_radio + F_os;
            F_IF = Ftune-F_radio;
            
            % Update spectrum analyzer
            hSpectrum.set('FrequencyOffset', F_radio);
            
            release(dspIFfilt);
            
            % Regenerate IF filter
            Fp = 0.1; % Doesn't seem to do anything
            Fc = F_IF/(params.Fs_radio/2); % Frequency shift of low pass
            [b,a] = ellip(7,0.2,80,F_IF_BW/params.Fs_radio);
            [Num,Den,~,~] = iirlp2bpc(b, a, Fp, [Fc-Fp, Fc+Fp]); % Shift filter response
            dspIFfilt = dsp.IIRFilter; % Create DSP object
            dspIFfilt.Numerator = Num; % Load in new parameters
            dspIFfilt.Denominator = Den;    
            
            % Update frequency readout
            gui_text_freq.String = [num2str(1e-6*Ftune, '%#2.6g') ' MHz'];
        end
        
        % Grab new frame from radio IQ RX
        sigIQ_RX = step(dspIQ_RX);
        I_rx =      sigIQ_RX(:,params.RX_I_CHAN);
        Q_rx =      sigIQ_RX(:,params.RX_Q_CHAN);
        IQ_rx = I_rx - 1j*Q_rx;
        
        % Apply IF bandpass filter
        IQ_rx_IF = step(dspIFfilt, IQ_rx);
        
        switch mode
            case 'USB'
                [rx_demod, IQ_rx_bb] = demodSSB(IQ_rx_IF, hDelay, hHilbert, hSRC, F_IF, F_IF_BW, params.F_IF_LowFreqCutOff, Tt, -1);
            case 'LSB'
                [rx_demod, IQ_rx_bb] = demodSSB(IQ_rx_IF, hDelay, hHilbert, hSRC, F_IF, F_IF_BW, params.F_IF_LowFreqCutOff, Tt, +1);
            otherwise
                error('Invalid mode!');
        end
        
        % Need to add Automatic Gain Control (AGC)
        rx_demod = 5*rx_demod;
        
        switch noiseFilter
            case 'None'
            case 'Wavelet'
                rx_demod = wden(rx_demod,'sqtwolog','s','mln',4,'sym8');
            case 'Savitzky-Golay'
                rx_demod = sgolayfilt(rx_demod,7,81);
            otherwise
                error('Invalid noise reduction filter!');
        end
        
        % Output audio to headphones
        Nur = step(dspAudioOut, repmat(rx_demod,1,2));
        if (Nur > 100)
            disp(['Lagging by ' num2str(Nur) ' samples.']);
        end
        
        % Visualize the signal
        step(hWaterfall, IQ_rx);
        step(hSpectrum, IQ_rx);
        step(hBaseBandSpectrum, IQ_rx_bb);
        
        % Increment frame number counter (time)
        t=t+1;
    end

    %% Shut down gracefully
    release(hWaterfall);
    release(hSpectrum);
end

