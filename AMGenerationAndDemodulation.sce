BasebandFrequency = 10e3;
CarrierFrequency = 375e3;
SamplingFrequency = 1.5e6;
BufferLength = 200;
n = 0:(BufferLength - 1);
BasebandSignal = sin(2*%pi*n / (SamplingFrequency/BasebandFrequency));
CarrierSignal = sin(2*%pi*n / (SamplingFrequency/CarrierFrequency));
ModulatedSignal_AM = CarrierSignal .* (1+BasebandSignal);
figure(1)
plot(n, BasebandSignal,"b")
plot(n, CarrierSignal,"r")
figure(2)
plot(n, ModulatedSignal_AM, "b")

HilbAmSignal = hilbert(ModulatedSignal_AM);
Envelop = abs(HilbAmSignal)-1;
figure(3)
plot(n, BasebandSignal,"b")
plot(n, Envelop, "r")

