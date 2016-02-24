function [ptrT, success] = srGetTemp( SR_DLL_NAME )
    ptrT = double(0);
    [success, ptrT] = calllib(SR_DLL_NAME,'srGetCpuTemp',ptrT);
    success = boolean(success);
    
    % Convert to Imperial units
    ptrT = 1.8*ptrT + 32;
end

