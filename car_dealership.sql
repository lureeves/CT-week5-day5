-- DDL

-- Creating salesman table - don't always have a salesman, ie. if someone is just
-- servicing a car
CREATE TABLE IF NOT EXISTS salesman(
	salesman_id SERIAL PRIMARY KEY, 
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL
);


-- Creating customer table
CREATE TABLE IF NOT EXISTS customer(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL,
	address VARCHAR(150) NOT NULL
);


-- Creating car table - always have a car
CREATE TABLE IF NOT EXISTS car(
	car_id SERIAL PRIMARY KEY,
	make VARCHAR(20) NOT NULL,
	model VARCHAR(35) NOT NULL,
	year NUMERIC(34,0) NOT NULL,
	VIN VARCHAR(17) NOT NULL,
	price NUMERIC(6,2) -- IF car IS BEGIN serviced, THEN NO price
);


-- Creating sale invoice table - either have a salesman, mechanic, or both
CREATE TABLE IF NOT EXISTS sale_invoice(
	sale_id SERIAL PRIMARY KEY,
	date_of_sale TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	-- Creating columns in sale invoice table
	car_id INTEGER,
	salesman_id INTEGER,
	customer_id INTEGER,
	-- Making those columns foreign keys
	FOREIGN KEY (car_id) REFERENCES car(car_id),
	FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


-- Creating mechanic table - don't always have a mechanic, ie. if someone is just 
-- buying a car 
CREATE TABLE IF NOT EXISTS mechanic(
	mechanic_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	address VARCHAR(150) NOT NULL
);


-- Creating service invoice table - either have a customer and mechanic, or neither
CREATE TABLE IF NOT EXISTS service_invoice(
	service_id SERIAL PRIMARY KEY,
	date_of_service TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	hours_worked NUMERIC(3,0) NOT NULL,
	parts_used VARCHAR(200) NOT NULL,
	car_comment VARCHAR(500) NOT NULL,
	car_id INTEGER,
	customer_id INTEGER,
	mechanic_id INTEGER,
	FOREIGN KEY (car_id) REFERENCES car(car_id),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id)
);


-- Creating service payment office table - always have car, either have sale,
-- service or both
CREATE TABLE IF NOT EXISTS payment_office(
	payment_id SERIAL PRIMARY KEY,
	payment_amount INTEGER DEFAULT 0,
	sale_id INTEGER,
	car_id INTEGER NOT NULL,
	service_id INTEGER,
	FOREIGN KEY (sale_id) REFERENCES sale_invoice(sale_id),
	FOREIGN KEY (car_id) REFERENCES car(car_id),
	FOREIGN KEY (service_id) REFERENCES service_invoice(service_id)
);




-- DML

-- Adding data to car
	-- First two cars for sale
	-- Since the last two cars don't have prices, they will be in the service department
INSERT INTO car VALUES(1, 'Toyota', 'Prius', 2007, 'JTDKB20U877670009', 7000);

INSERT INTO car VALUES(2, 'Mercedes', 'E-320', 2001, 'JTDKB20U877678923', 4000);

INSERT INTO car VALUES(3, 'Honda', 'Civic', 2004, 'JTDKB20U919824198');

INSERT INTO car VALUES(4, 'Nissan', 'Tian', 2004, 'JTDKB20U991284826');


-- Adding data to mechanic
INSERT INTO mechanic VALUES(1, 'Bill', 'Jenson', '321 Circle Dr., Fake City, Texas, 20931');

INSERT INTO mechanic VALUES(2, 'James', 'Herb', '098 Square Cr., Real City, Washington, 20845');


-- Adding data to salesman
INSERT INTO salesman VALUES(1, 'John', 'Whick');

INSERT INTO salesman VALUES(2, 'Juan', 'Castro');


-- Adding data to customer
INSERT INTO customer VALUES(1, 'Jackie', 'Chan', 'jackie@kungfu.com', '1 Millionaire St., Millionaire City, California, 92681');

INSERT INTO customer VALUES(2, 'Jake', 'StateFarm', 'jake@statefarm.com', '200 Old Cashes Valley, Blue Ridge, Georgia, 30513');

INSERT INTO customer VALUES(3, 'Rick', 'Guy', 'coolcarguy@carguys.com', '123 Car Guy Street, Car Guy City, Texas, 61102');


-- Adding data to sale invoice
	-- IF a customer buys a car 
	-- IF the same customer buys a SECOND car from a different salesman
INSERT INTO sale_invoice(
			sale_id,
			car_id,
			salesman_id,
			customer_id
) VALUES (1, 1, 1, 1),
		 (2, 2, 2, 1);
		

-- Adding data to service invoice
	-- First car (not for sale, id 3) to first mechanic
	-- Second car (not for sale, id 4) to second mechanic
INSERT INTO service_invoice(
			service_id,
			car_id,
			hours_worked,
			parts_used,
			car_comment,
			customer_id,
			mechanic_id
) VALUES (1, 3, 10, 'Retro Encabulator, Radiator', 'This car needs work. Duh', 3, 1),
		 (2, 4, 2, 'Blinker fluid, oil, filter', 'Changed blinker fluid, car could use air replacement in tires.', 3, 2);
		
		
-- Adding data to payment_office
	-- Car sales (no service_id)
INSERT INTO payment_office (
			payment_id,
			payment_amount,
			sale_id,
			car_id
) VALUES (1, 7000, 1, 1),
		 (2, 4000, 2, 2);
		
	-- Car service (no sale_id)
INSERT INTO payment_office (
			payment_id,
			payment_amount,
			car_id,
			service_id
) VALUES (3, 1250, 3, 1),
		 (4, 300, 4, 2);
