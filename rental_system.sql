USE rental_db;

/* Q1. Customer 'Angel' rents 'SBA1111A' from today for 10 days. */
INSERT INTO rental_records (veh_reg_no, customer_id, start_date, end_date)
VALUES ('SBA1111A', (SELECT customer_id FROM customers WHERE name = 'Angel'), curdate(), date_add(curdate(), INTERVAL 10 DAY));

/* Q2. Customer 'Kumar' rents 'GA5555E' from tomorrow for 3 months. */
INSERT INTO rental_records (veh_reg_no, customer_id, start_date, end_date)
VALUES ('GA5555E', (SELECT customer_id FROM customers WHERE name = 'Kumar'), date_add(curdate(), INTERVAL 1 DAY), date_add(date_add(curdate(), INTERVAL 1 DAY), INTERVAL 3 MONTH));

/* Q3. List all rental records (start date, end date) with vehicle's registration number, brand, and customer name, sorted by vehicle's categories followed by start date. */
SELECT start_date, end_date, rental_records.veh_reg_no, brand, name FROM rental_records
INNER JOIN customers USING (customer_id)
INNER JOIN vehicles USING (veh_reg_no)
ORDER BY category, start_date;

/* Q4. List all the expired rental records */
SELECT * FROM rental_records
WHERE end_date < curdate();

/* Q5. List the vehicles rented out on '2012-01-10' (not available for rental), in columns of vehicle registration no, customer name, start date and end date. */
SELECT veh_reg_no, name, start_date, end_date FROM rental_records
INNER JOIN customers USING (customer_id)
WHERE start_date < '2012-01-10' AND end_date > '2012-01-10';

/* Q6. List all vehicles rented out today, in columns registration number, customer name, start date, end date. */
SELECT DISTINCT veh_reg_no, name, start_date, end_date FROM rental_records
INNER JOIN customers USING (customer_id)
WHERE start_date <= curdate();

/* Q7. Similarly, list the vehicles rented out (not available for rental) for the period from '2012-01-03' to '2012-01-18' */
SELECT veh_reg_no, name, start_date, end_date FROM rental_records
INNER JOIN customers USING (customer_id)
WHERE (start_date > '2012-01-03' AND start_date < '2012-01-18') or
(end_date < '2012-01-03' AND end_date < '2012-01-18') or 
(start_date < '2012-01-03' AND end_date > '2012-01-18');

/* Q8. List the vehicles (registration number, brand and description) available for rental (not rented out) on '2012-01-10' */
SELECT veh_reg_no, brand, vehicles.desc FROM vehicles
LEFT JOIN rental_records USING (veh_reg_no)
WHERE veh_reg_no NOT IN (
	SELECT veh_reg_no FROM rental_records
	WHERE start_date < '2012-01-10' AND end_date > '2012-01-10'
);

/*Q9. Similarly, list the vehicles available for rental for the period from '2012-01-03' to '2012-01-18' */
SELECT veh_reg_no, brand, vehicles.desc FROM vehicles
LEFT JOIN rental_records USING (veh_reg_no)
WHERE veh_reg_no NOT IN (
	SELECT veh_reg_no FROM rental_records
    WHERE (start_date > '2012-01-03' AND start_date < '2012-01-18') or
	(end_date < '2012-01-03' AND end_date < '2012-01-18') or 
	(start_date < '2012-01-03' AND end_date > '2012-01-18')
);

/* Q10. Similarly, list the vehicles available for rental from today for 10 days. */
SELECT veh_reg_no, brand, vehicles.desc FROM vehicles
LEFT JOIN rental_records USING (veh_reg_no)
WHERE veh_reg_no NOT IN (
	SELECT veh_reg_no FROM rental_records WHERE
	(start_date > curdate() AND start_date < date_add(curdate(), interval 10 DAY)) or
	(end_date < curdate() AND end_date < date_add(curdate(), interval 10 DAY)) or 
	(start_date < curdate() AND end_date > date_add(curdate(), interval 10 DAY))
);
