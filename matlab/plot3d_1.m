clear all
clc

coeff = ones(1, 10)/10;

serialPort = serialport('COM3',9600);
fopen(serialPort);

% Create animated lines for real-time plotting
ax_line = animatedline('Color', 'r');
ay_line = animatedline('Color', 'g');
az_line = animatedline('Color', 'b');
gx_line = animatedline('Color', 'r', 'LineStyle', '--');
gy_line = animatedline('Color', 'g', 'LineStyle', '--');
gz_line = animatedline('Color', 'b', 'LineStyle', '--');

title('Real-time Sensor Data');
legend('Acc X', 'Acc Y', 'Acc Z', 'Gyro X', 'Gyro Y', 'Gyro Z');
grid on;

t = 0;  % Initialize time counter

while ishandle(ax_line)  % Continue updating as long as the figure is open
    raw_data = fscanf(serialPort, '%s');  % Read the entire line as a string
    data = sscanf(raw_data, '%f,%f,%f,%f,%f,%f\n');

    % Check if data array is not empty
    if ~isempty(data) && length(data) == 6
        ax = data(1) / 16384;
        ay = data(2) / 16384;
        az = data(3) / 16384;
        gx = data(4) / 256;
        gy = data(5) / 256;
        gz = data(6) / 256;

        % Append new data to animated lines
        addpoints(ax_line, t, ax);
        addpoints(ay_line, t, ay);
        addpoints(az_line, t, az);
        addpoints(gx_line, t, gx);
        addpoints(gy_line, t, gy);
        addpoints(gz_line, t, gz);

        % Update axis limits for better visualization
        axis([t-50, t, -2, 2]);

        drawnow;

        t = t + 1;  % Increment time counter
    end
end

fclose(serialPort);
delete(serialPort);
