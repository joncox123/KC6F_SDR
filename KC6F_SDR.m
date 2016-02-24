% KC6F SDR for Softrock Ensemble RXTX amateur radio
% Author: Jonathan A. Cox: joncox (at) alum (dot) mit (dot) edu
% Version: 0.1
% Date: 2/23/2016

%% This software is released under the GNU GENERAL PUBLIC LICENSE Version 3
%   Read the license.txt file for a copy of the license.

close all force;

SR_DLL_NAME = 'SRDLL';
SR_DLL_H_PATH = 'SRDLL.h';
addpath('PE0FKO_SR_DLL');

% Parameters
params.Fs_radio = 192000;
params.Fs_audio = 48000;
params.RBW = 100;
params.F_IF_LowFreqCutOff = 300; % Lower cutoff of IF bandpass filter
params.F_IF_HighFreqCutOff = 2.4e3; % Lower cutoff of IF bandpass filter
params.SAMPLE_TIME = 0.05;
params.SAMPLES_PER_FRAME_RADIO = params.SAMPLE_TIME*params.Fs_radio;
params.SAMPLES_PER_FRAME_AUDIO = params.SAMPLE_TIME*params.Fs_audio;
params.QueueDuration = 0.2;
params.SpecAverages = round(1*params.Fs_radio/params.SAMPLES_PER_FRAME_RADIO);
params.WaterfallRate = 0.1;
params.RX_I_CHAN = 1;
params.RX_Q_CHAN = 2;
params.SR_DLL_NAME = SR_DLL_NAME;
params.F_radio_initial = 7.2e6;

% Pick the audio devices
audioDevFileName = 'audio_device_choice3.mat';
[IQ_RX_Dev, IQ_TX_Dev, Audio_Input_Dev, Audio_Output_Dev] = selectAudioDevices(audioDevFileName);

[dspIQ_RX, dspAudioIn, dspIQ_TX, dspAudioOut] = openADC_DAC_Interfaces(IQ_RX_Dev, IQ_TX_Dev, Audio_Input_Dev, Audio_Output_Dev, params);

[isSrOpen, warnings] = openSoftrock(SR_DLL_NAME, SR_DLL_H_PATH);
if isSrOpen
    Main_Event_Loop(dspIQ_RX, dspAudioIn, dspIQ_TX, dspAudioOut, params); 
end

close all force;
closeADC_DAC_Interfaces(dspIQ_RX, dspAudioIn, dspIQ_TX, dspAudioOut);
closeSoftrock(SR_DLL_NAME);

