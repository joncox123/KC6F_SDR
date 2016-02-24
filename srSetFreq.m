function success = srSetFreq(f, SR_DLL_NAME )
    ptrI2C = int32(0); % I2C address for Si570 device on Softrock
    % Get the I2C address
    [success, i2cAddr] = calllib(SR_DLL_NAME,'srGetI2CAddr',ptrI2C);
    
    if success
        [success] = calllib(SR_DLL_NAME,'srSetFreq',1e-6*4*f, i2cAddr);
    end
    success = boolean(success);
end

