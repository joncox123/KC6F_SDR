function closeSoftrock(SR_DLL_NAME)
    calllib(SR_DLL_NAME,'srClose');
    unloadlibrary(SR_DLL_NAME);
end

