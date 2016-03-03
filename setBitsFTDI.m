function success = setBitsFTDI(hFTDI, nibble)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    success = false;

    bits = uint8(bi2de([0 0 0 0 nibble], 'left-msb'));
    r = hFTDI.Write(bits, 1, 0);

    if strcmp(r.char, 'FT_OK')
        success = true;
    end

end

