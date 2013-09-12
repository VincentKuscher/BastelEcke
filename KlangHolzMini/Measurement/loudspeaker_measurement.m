clear all; close all; clc

%% ============= audio stuff ==============================================
% sample rate
fs = 44100;
% sweep length in sec
t1 = 25;
% time vector
t = 0:1/fs:t1;
% start frequency of the sweep
f0 = 0;
% end frequency of the sweep
f1 = 20000;
% sweep method
method = 'linear';
% phase shift (otpional)
phi = 0;

% calculate sweep
y = chirp(t,f0,t1,f1,method,phi);

% define audiorecorder/player objects and its properties
nBits =24;
nChannels = 1;
rec_sweep = audiorecorder(fs,nBits,nChannels);
sweep_out = audioplayer(y,fs,nBits);

% do play/record
play(sweep_out);
recordblocking(rec_sweep,25);
signal = getaudiodata(rec_sweep,'double');

% % write to *.wav file
% wavwrite(y,fs,32,'test');

%% ============= FFT ======================================================
% ===== Calcualate spectrum =============================================
% Generate fast fourier transformation (=> complex output)
compspec = fft(signal);

% Length of the signal => number of points of fft
samples = length(signal);

% Get amplitude and phase spectra (and use only the first half of the
%>spectrum (Nyquist))
amplitude = abs(compspec(1:ceil(samples/2)));
phase = angle(compspec(1:ceil(samples/2)));

% Scale the amplitude (factor two, because we have cut off one half and
%>divide by number of samples)
amplitude = 2*amplitude / samples;

% Calculate corresponding frequency axis
f = fs*(0:ceil(samples/2)-1)/samples;
%% ============= Plots ====================================================
figure
subplot(2,1,1)
semilogx(f,db(amplitude),'b')
grid on
ylabel('amplitude / dB')
xlabel('f/Hz')

subplot(2,1,2)
plot(f,phase,'r')
ylabel('phase / rad')
xlabel('f/Hz')