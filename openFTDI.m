function [hFTDI, isOpen] = openFTDI(FTDIDevFileName, FTDI_DLL_PATH)
%openFTDI Summary of this function goes here
%   Detailed explanation goes here

    isOpen = false;

    FTDI_NET = NET.addAssembly(FTDI_DLL_PATH);
    %methodsview('FTD2XX_NET.FTDI');

    % Get handle to FTDI object
    hFTDI = FTD2XX_NET.FTDI;

    % Get a list of devices
    N = 5;
    list = NET.createArray('FTD2XX_NET.FT_DEVICE_INFO_NODE', N);
    r = hFTDI.GetDeviceList(list);

    % Populate a list of devices
    devList = {};
    devListStr = {};
    for k=1:N
       if ~isempty(list(k))
            tmp = list(k);
            devList{end+1} = tmp;
            devListStr{end+1} = [tmp.Description.char ', S/N: ' tmp.SerialNumber.char];
       end
    end

    % See if user already selected devices
    s = [];
    if exist(FTDIDevFileName, 'file') == 2
        load(FTDIDevFileName);
        
        % Attempt to open selected device
        disp('Opening FTDI device...');
        r = hFTDI.OpenByLocation(idx);
        if strcmp(r.char, 'FT_OK')
            isOpen = true;
        end
    elseif ~isempty(devList)
        [s,v] = listdlg('PromptString','Select FTDI device for bandpass filter control:',...
                            'SelectionMode','single',...
                            'ListString',devListStr,...
                            'ListSize', [400 200]);            
        % Attempt to open selected device
        if ~isempty(s)
            disp('Opening FTDI device...');
            idx = uint32(devList{s}.LocId);
            r = hFTDI.OpenByLocation(idx);
            if strcmp(r.char, 'FT_OK')
                isOpen = true;
            end
        end

    if ~isOpen
        disp('Failed to open FTDI device!'); 
    else
        save(FTDIDevFileName, 'idx');
    end
    
    % Put device into async bit bang mode
    pinOutputMask = uint8(bi2de([0 0 0 0 1 1 1 1], 'left-msb')); % Only output the lower 4 bits (nibble)
    mode = uint8(1); % 1 indicates async bit bang
    hFTDI.SetBitMode(pinOutputMask, mode);
    
    % Set all bits low
    if(~setBitsFTDI(hFTDI, [0 0 0 0]))
        disp('Error setting FTDI bits!');
    end
end

