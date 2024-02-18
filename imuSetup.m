arduinoPort = 'COM3';
baudRate = 9600;

% Create a serial port object
s = serialport(arduinoPort, baudRate);

% Reading data from Arduino
try
    while true
        data = readline(s);
        disp(data);
    end
catch
    disp('Error reading from Arduino. Make sure the connection is stable.');
end

% Close and clear the serial port
delete(s);
clear s;