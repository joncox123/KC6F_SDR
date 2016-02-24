function [success, ptrCWkey] = srSetPTTGetCWInp(enable, SR_DLL_NAME )
    ptt = int32(enable);
    ptrCWkey = int32(-1);
    
    [success, ptrCWkey] = calllib(SR_DLL_NAME,'srSetPTTGetCWInp',ptt, ptrCWkey);

    success = boolean(success);
end

