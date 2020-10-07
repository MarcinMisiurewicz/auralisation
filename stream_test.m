micReader=audioDeviceReader;
speakerWriter=audioDeviceWriter;
spectAnalyzer=dspSpectrumAnalyzer;

tic;
while (toc<30)
    audio=micReader();
    spectAnalyzer(audio);
    speakerWriter(audio)
end