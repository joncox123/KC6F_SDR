function [rx_demod, IQ_rx_bb] = demodSSB(IQ_rx_IF, hDelay, hHilbert, hSRC, F_IF, F_IF_BW, F_IF_LowFreqCutOff, Tt, SSB_Sign)
%demodSSB Demodulate SSB using hilbert transform method
%   SSB_Sign = +1 for LSB and -1 for USB

    SSB_Sign = sign(SSB_Sign);

    % Shift to baseband
    % LSB: +, USB: -
    IQ_rx_bb = exp(-1i*2*pi*(F_IF + SSB_Sign*(F_IF_BW/2+F_IF_LowFreqCutOff))*Tt).*IQ_rx_IF;
    % Resample to F_audio
    IQ_rx_bb = step(hSRC, IQ_rx_bb);

    % Demodulate SSB using Hilbert transform
    rx_demod = step(hDelay, real(IQ_rx_bb)) + SSB_Sign*filter(hHilbert, imag(IQ_rx_bb));
        
end

