function [isOpen, warnings] = openSoftrock(SR_DLL_NAME, SR_DLL_H_PATH)
    % Load the PE0FKL SoftRock Si570 control library
    if (libisloaded(SR_DLL_NAME))
        unloadlibrary(SR_DLL_NAME);
    end
    disp('Loading PE0FKL Softrock Si570 control DLL...');
    [notfound,warnings] = loadlibrary(SR_DLL_NAME, SR_DLL_H_PATH,'alias',SR_DLL_NAME);
    if (~isempty(warnings))
        disp(['Warnings while loading library. Please check warnings string for more info.']);
    end
    % libfunctionsview(SR_DLL_NAME) % View list of functions with data types

    % Open the Softrock USB interface
    vid     = int32(hex2dec('16C0')); % Softrock USB VID
    pid     = int32(hex2dec('05DC')); % Softrock USB PID
    iDevNum = int32(1); % Softrock device number
    ptrArray = int8(zeros(128,1)); % fill with ASCII spaces
    calllib(SR_DLL_NAME,'srOpen',vid, pid, ptrArray, ptrArray, ptrArray, iDevNum);

    % Check if device opened
    isOpen = calllib(SR_DLL_NAME,'srIsOpen');
    if (isOpen)
        % Get Softrock device info
        srUsbInfo = calllib(SR_DLL_NAME,'srGetUsbInfo');
        srManufacture = strrep(char(srUsbInfo.Value.Manufacturer), char(0), '');
        srSerialNumber = strrep(char(srUsbInfo.Value.SerialNumber), char(0), '');
        srProduct = strrep(char(srUsbInfo.Value.Product), char(0), '');
        
        % Get version
        ptrMajor = int32(0);
        ptrMinor = int32(0);
        [success, ptrMajor, ptrMinor] = calllib(SR_DLL_NAME,'srGetVersion', ptrMajor, ptrMinor);
        
        disp(['Found Softrock interface ' srSerialNumber ', version ' num2str(ptrMajor) '.' num2str(ptrMinor)]);
    end
end

