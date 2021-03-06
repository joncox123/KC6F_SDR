function [dspIQ_RX, dspAudioIn, dspIQ_TX, dspAudioOut] = openADC_DAC_Interfaces(IQ_RX_Dev, IQ_TX_Dev, Audio_Input_Dev, Audio_Output_Dev, params)
    % Open the RX IQ
    dspIQ_RX = dsp.AudioRecorder('SamplesPerFrame', params.SAMPLES_PER_FRAME_RADIO,...
                            'SampleRate', params.Fs_radio,...
                            'NumChannels', 2,...
                            'OutputDataType', 'double',...
                            'DeviceName', IQ_RX_Dev);                   
    % Open the Audio input (voice)
    dspAudioIn = dsp.AudioRecorder('SamplesPerFrame', params.SAMPLES_PER_FRAME_AUDIO,...
                                'SampleRate', params.Fs_audio,...
                                'NumChannels', 1,...
                                'OutputDataType', 'double',...
                                'DeviceName', Audio_Input_Dev);
    % Open the TX IQ
    dspIQ_TX = dsp.AudioPlayer('SampleRate', params.Fs_radio,...
                                'OutputNumUnderrunSamples',true,...
                                'QueueDuration',params.QueueDuration, ...
                                'DeviceName', IQ_TX_Dev);

    % Open the Audio output (demodulated)
    dspAudioOut = dsp.AudioPlayer('SampleRate', params.Fs_audio,...
                                'OutputNumUnderrunSamples',true,...
                                'QueueDuration', params.QueueDuration, ...
                                'DeviceName', Audio_Output_Dev);
end

