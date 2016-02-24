function closeADC_DAC_Interfaces(dspIQ_RX, dspAudioIn, dspIQ_TX, dspAudioOut)
    release(dspIQ_RX);
    release(dspAudioIn);
    release(dspIQ_TX);
    release(dspAudioOut);
end

