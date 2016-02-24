function [f, success] = srGetFreq( SR_DLL_NAME )
    ptrFreq = double(0);
    [success, f] = calllib(SR_DLL_NAME,'srGetFreq',ptrFreq);
    success = boolean(success);
    
    f = 1e6*f/4; % Scale for Softrock Si570
end

