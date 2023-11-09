CREATE TABLE IF NOT EXISTS onduty (
    id INT AUTO_INCREMENT PRIMARY KEY,
    discord VARCHAR(255) NOT NULL,
    department VARCHAR(255) NOT NULL,
    callsign VARCHAR(255),
    start_time INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dutylogs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    discord VARCHAR(255) NOT NULL,
    department VARCHAR(255) NOT NULL,
    callsign VARCHAR(255),
    time INT NOT NULL
);
