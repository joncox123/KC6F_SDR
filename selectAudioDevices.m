function [IQ_RX, IQ_TX, Audio_Input, Audio_Output] = selectAudioDevices(fname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    % See if user already selected devices
    if exist(fname, 'file') == 2
        load(fname);
    else
        % Get list of audio devices on computer
        audioDevices = audiodevinfo;
        inputDevList = {audioDevices.input.Name};
        outputDevList = {audioDevices.output.Name};

        % Remove the trailing part of the device names
        inputDevList = strrep(inputDevList, ' (Windows DirectSound)', '');
        outputDevList = strrep(outputDevList, ' (Windows DirectSound)', '');
        
        % Prompt user to pick an input device for radio
        s = [];
        while isempty(s)
            [s,v] = listdlg('PromptString','Select device to use to get IQ from radio (RX):',...
                            'SelectionMode','single',...
                            'ListString',inputDevList,...
                            'ListSize', [400 200]);
        end
        IQ_RX = inputDevList{s};
        inputDevList(s) = []; % Remote radio choices from device lists
        disp(['Using ' IQ_RX ' for IQ from radio.']);

        % Prompt user to pick an output device for radio
        s = [];
        while isempty(s)
            [s,v] = listdlg('PromptString','Select device to use to send IQ to radio (TX):',...
                            'SelectionMode','single',...
                            'ListString',outputDevList,...
                            'ListSize', [400 200]);   
        end
        IQ_TX = outputDevList{s};
        outputDevList(s) = []; % Remote radio choices from device lists
     
        % Prompt user to pick an input device audio TX
        s = [];
        while isempty(s)
            [s,v] = listdlg('PromptString','Select device to use for microphone (voice):',...
                            'SelectionMode','single',...
                            'ListString',inputDevList,...
                            'ListSize', [400 200]);
        end
        Audio_Input = inputDevList{s};

        % Prompt user to pick an output device for audio RX
        s = [];
        while isempty(s)
            [s,v] = listdlg('PromptString','Select device to to play demodulated audio:',...
                            'SelectionMode','single',...
                            'ListString',outputDevList,...
                            'ListSize', [400 200]);  
        end
        Audio_Output = outputDevList{s};

        save(fname, 'IQ_RX', 'IQ_TX', 'Audio_Input', 'Audio_Output');
    end

    disp(['Using ' IQ_RX ' for IQ from radio.']);
    disp(['Using ' IQ_TX ' for IQ to radio.']);
    disp(['Using ' Audio_Input ' for voice audio input.']);
    disp(['Using ' Audio_Output ' for demodulated output.']);
end

