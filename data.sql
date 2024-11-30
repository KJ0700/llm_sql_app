DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicle') THEN
        CREATE TABLE vehicle (
            vehicle_id SERIAL PRIMARY KEY,
            make VARCHAR(50),
            model VARCHAR(50),
            year INT,
            vin VARCHAR(17) UNIQUE
        );
    END IF;
END $$;

INSERT INTO vehicle (make, model, year, vin) 
SELECT * FROM (VALUES
('Toyota', 'Corolla', 2020, '1NXBR32E28Z174837'),
('Honda', 'Civic', 2018, '2HGFC2F59JH567321'),
('Ford', 'F-150', 2021, '1FTEX1EP7MKD18476'),
('Chevrolet', 'Equinox', 2020, '2GNAXJEV8L6347051'),
('BMW', 'X5', 2022, '5UXCR6C08L9K53956'),
('Audi', 'Q5', 2021, 'WA1C2AFY0J2102399'),
('Nissan', 'Altima', 2020, '1N4BL4CV9LC124836'),
('Hyundai', 'Elantra', 2020, '5NPD84LF5LH211702'),
('Kia', 'Sorento', 2021, '5XYPGDA56MG063648'),
('Mazda', 'CX-5', 2020, 'JM3KFBBM9L0337421')
) AS data(make, model, year, vin)
WHERE NOT EXISTS (SELECT 1 FROM vehicle);


DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer') THEN
        CREATE TABLE customer (
            customer_id SERIAL PRIMARY KEY,
            first_name VARCHAR(50),
            last_name VARCHAR(50),
            email VARCHAR(100),
            phone_number VARCHAR(15),
            street_address VARCHAR(255),
            city VARCHAR(50),
            state VARCHAR(50),
            zip VARCHAR(10)
        );
    END IF;
END $$;

INSERT INTO customer (first_name, last_name, email, phone_number, street_address, city, state, zip) 
SELECT * FROM (VALUES
('John', 'Doe', 'john.doe@gmail.com', '9876543210', '123 MG Road', 'Hyderabad', 'Telangana', '500001'),
('Amit', 'Sharma', 'amit.sharma@outlook.com', '9988776655', '456 Banjara Hills', 'Hyderabad', 'Telangana', '500034'),
('Priya', 'Patel', 'priya.patel@yahoo.com', '9888776655', '789 Jubilee Hills', 'Hyderabad', 'Telangana', '500033'),
('Rahul', 'Reddy', 'rahul.reddy@hotmail.com', '9444332211', '123 MG Road', 'Mumbai', 'Maharashtra', '400086'),
('Ananya', 'Srinivas', 'ananya.srinivas@zoho.com', '9911223344', '234 MG Road', 'Mumbai', 'Maharashtra', '400090'),
('Vikram', 'Jain', 'vikram.jain@gmail.com', '9777889999', '567 Banjara Hills', 'Hyderabad', 'Telangana', '500054'),
('Meera', 'Nair', 'meera.nair@outlook.com', '9888443322', '890 Jubilee Hills', 'Mumbai', 'Maharashtra', '400097'),
('Raj', 'Kumar', 'raj.kumar@tmail.com', '9000112233', '1234 MG Road', 'Hyderabad', 'Telangana', '500060'),
('Sunita', 'Mohan', 'sunita.mohan@rediffmail.com', '9187332244', '5678 Banjara Hills', 'Hyderabad', 'Telangana', '500083'),
('Alok', 'Patel', 'alok.patel@gmail.com', '9022334455', '2345 MG Road', 'Mumbai', 'Maharashtra', '400112')
) AS data(first_name, last_name, email, phone_number, street_address, city, state, zip)
WHERE NOT EXISTS (SELECT 1 FROM customer);

DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'appointment') THEN
        CREATE TABLE appointment (
            appointment_id SERIAL PRIMARY KEY,
            customer_id INT REFERENCES customer(customer_id),
            vehicle_id INT REFERENCES vehicle(vehicle_id),
            appointment_date TIMESTAMP,
            street_address VARCHAR(255),
            city VARCHAR(50),
            state VARCHAR(50),
            zip VARCHAR(10)
        );
    END IF;
END $$;

INSERT INTO appointment (customer_id, vehicle_id, appointment_date, street_address, city, state, zip)
SELECT customer_id, vehicle_id, appointment_date, street_address, city, state, zip
FROM (VALUES
    (1, 1, '2024-12-05 10:00:00'::timestamp, '123 MG Road', 'Hyderabad', 'Telangana', '500001'),
    (2, 2, '2024-12-06 14:30:00'::timestamp, '456 Banjara Hills', 'Hyderabad', 'Telangana', '500034'),
    (3, 3, '2024-12-07 09:00:00'::timestamp, '789 Jubilee Hills', 'Hyderabad', 'Telangana', '500033'),
    (4, 4, '2024-12-08 16:00:00'::timestamp, '123 MG Road', 'Mumbai', 'Maharashtra', '400086'),
    (5, 5, '2024-12-09 12:00:00'::timestamp, '234 MG Road', 'Mumbai', 'Maharashtra', '400090'),
    (6, 6, '2024-12-10 14:00:00'::timestamp, '567 Banjara Hills', 'Hyderabad', 'Telangana', '500054'),
    (7, 7, '2024-12-11 11:30:00'::timestamp, '890 Jubilee Hills', 'Mumbai', 'Maharashtra', '400097'),
    (8, 8, '2024-12-12 13:00:00'::timestamp, '1234 MG Road', 'Hyderabad', 'Telangana', '500060'),
    (9, 9, '2024-12-13 15:00:00'::timestamp, '5678 Banjara Hills', 'Hyderabad', 'Telangana', '500083'),
    (10, 10, '2024-12-14 10:00:00'::timestamp, '2345 MG Road', 'Mumbai', 'Maharashtra', '400112')
) AS data(customer_id, vehicle_id, appointment_date, street_address, city, state, zip)
WHERE NOT EXISTS (
    SELECT 1 
    FROM appointment a
    WHERE a.customer_id = data.customer_id
      AND a.vehicle_id = data.vehicle_id
      AND a.appointment_date = data.appointment_date
);