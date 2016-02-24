function updateIFcallback( source,callbackdata)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

global updateIF;
updateIF = true;

global F_os;
F_os = 1e3*source.Value;

end

