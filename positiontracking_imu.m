% Setup serial connection
serialPort = 'COM3'; % Change this to your Arduino's serial port
baudRate = 9600;
s = serialport(serialPort, baudRate);
fopen(s);

% Setup figure for plotting
figure;
xlim([-10, 10]); ylim([-10, 10]); zlim([-10, 10]); % Adjust these limits as needed
xlabel('X'); ylabel('Y'); zlabel('Z');
hold on;
grid on;

% Initialize position and velocity
position = [0, 0, 0];
velocity = [0, 0, 0];
time_prev = 0;

% Main loop to read data and update position
while true
    data = fscanf(s, '%d,%d,%d,%d,%d,%d');
    dataArray = str2num(char(data));
    if length(dataArray) == 6
        ax = dataArray(1);
        ay = dataArray(2);
        az = dataArray(3);
        % Assuming gx, gy, gz (gyroscope data) are not used for position tracking
        
        % Convert acceleration from ADC units to m/s^2
        % This conversion depends on your specific setup and the sensitivity settings of the MPU6050
        ax = ax * (9.81 / 16384.0);
        ay = ay * (9.81 / 16384.0);
        az = az * (9.81 / 16384.0);
        
        % Get current time in seconds
        time_now = toc;
        if time_prev == 0  % First iteration
            dt = 0;
        else
            dt = time_now - time_prev;
        end
        time_prev = time_now;
        
        % Update velocity and position using simple integration
        velocity = velocity + [ax, ay, az] * dt;
        position = position + velocity * dt;
        
        % Plot the new position
        plot3(position(1), position(2), position(3), 'bo');
        drawnow;
    end
end

% Close the serial port when done
fclose(s);
delete(s);
clear s;
