serialPort = 'COM3'; 
baudRate = 9600;
s = serialport(serialPort, baudRate);
fopen(s);

figure;
xlim([-10, 10]); ylim([-10, 10]); zlim([-10, 10]); 
xlabel('X'); ylabel('Y'); zlabel('Z');
hold on;
grid on;

position = [0, 0, 0];
velocity = [0, 0, 0];
time_prev = 0;

while true
    data = fscanf(s, '%d,%d,%d,%d,%d,%d');
    dataArray = str2num(char(data));
    if length(dataArray) == 6
        ax = dataArray(1);
        ay = dataArray(2);
        az = dataArray(3);
        
        ax = ax * (9.81 / 16384.0);
        ay = ay * (9.81 / 16384.0);
        az = az * (9.81 / 16384.0);

        time_now = toc;
        if time_prev == 0  
            dt = 0;
        else
            dt = time_now - time_prev;
        end
        time_prev = time_now;
        
        velocity = velocity + [ax, ay, az] * dt;
        position = position + velocity * dt;

        plot3(position(1), position(2), position(3), 'bo');
        drawnow;
    end
end

% Close the serial port when done
fclose(s);
delete(s);
clear s;
