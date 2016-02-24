function pttButtonCallback( hObject, eventdata, SR_DLL_NAME )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global PTT;

if PTT
    srSetPTTGetCWInp(false, SR_DLL_NAME);
    hObject.BackgroundColor = [.94 .94 .94];
    PTT = false;
else
    srSetPTTGetCWInp(true, SR_DLL_NAME);
    hObject.BackgroundColor = 'red';
    PTT = true;
end

