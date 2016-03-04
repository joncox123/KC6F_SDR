function success = setBandPassFilter(hFTDI, freq)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    freq = 1e-6*freq; % Convert from Hz to MHz

    % Pick band for TS-850 based on the frequency of operation
    if      (1.6 <= freq) && (freq < 2.0)
            success = setBitsFTDI(hFTDI, de2bi(0,4,'left-msb')); %
    elseif  (2.0 <= freq) && (freq < 4.0)
            success = setBitsFTDI(hFTDI, de2bi(1,4,'left-msb')); %      
    elseif  (4.0 <= freq) && (freq < 7.5)
            success = setBitsFTDI(hFTDI, de2bi(2,4,'left-msb')); %
    elseif  (7.5 <= freq) && (freq < 10.5)
            success = setBitsFTDI(hFTDI, de2bi(3,4,'left-msb'));    
    elseif  (10.5 <= freq) && (freq < 14.5)
            success = setBitsFTDI(hFTDI, de2bi(5,4,'left-msb')); %
    elseif  (14.5 <= freq) && (freq < 21.5)
            success = setBitsFTDI(hFTDI, de2bi(6,4,'left-msb')); % 
    elseif  (21.5 <= freq) && (freq <= 30.0)    
            success = setBitsFTDI(hFTDI, de2bi(8,4,'left-msb'));    
    else
            success = false;
            disp('setBandPassFilter: Invalid frequency choice for TS-850 BPF!');
    end
end

