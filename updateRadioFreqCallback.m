function updateRadioFreqCallback( source,callbackdata)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

global updateRadioFreq;
updateRadioFreq = true;

global F_radio;
F_radio = 1e6*source.Value;

end

