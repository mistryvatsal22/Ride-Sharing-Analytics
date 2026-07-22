USE ride_analytics;

-- 1. Total Trips
SELECT COUNT(*) AS total_trips
FROM rides;



-- 2. Total Revenue
SELECT
SUM(final_fare) AS total_revenue
FROM rides;



-- 3.Average Fare
SELECT
ROUND(AVG(final_fare),2) AS average_fare
FROM rides;


-- 4.Average Trip Distance
SELECT
ROUND(AVG(trip_distance),2) AS average_distance
FROM rides;

-- 5.Average Ride Duration
SELECT
ROUND(AVG(ride_duration),2) AS average_duration
FROM rides;

-- 6.Trips by Pickup City
SELECT
pickup_city,
COUNT(*) AS total_trips
FROM rides
GROUP BY pickup_city
ORDER BY total_trips DESC;


-- 7.Trips by Drop City
SELECT
drop_city,
COUNT(*) AS total_trips
FROM rides
GROUP BY drop_city
ORDER BY total_trips DESC;


-- 8.Revenue by Pickup City
SELECT
pickup_city,
SUM(final_fare) AS revenue
FROM rides
GROUP BY pickup_city
ORDER BY revenue DESC;


-- 9.Peak Booking Hours
SELECT
hour,
COUNT(*) AS total_rides
FROM rides
GROUP BY hour
ORDER BY total_rides DESC;


-- 10.Trips by Day of Week
SELECT
day_of_week,
COUNT(*) AS total_rides
FROM rides
GROUP BY day_of_week
ORDER BY total_rides DESC;


-- 11.Monthly Revenue
SELECT
year,
month,
SUM(final_fare) AS revenue
FROM rides
GROUP BY year,month
ORDER BY year,month;


-- 12.Payment Methods
SELECT
payment_type,
COUNT(*) AS total
FROM rides
GROUP BY payment_type
ORDER BY total DESC;

-- 13.Ride Category
SELECT
ride_category,
COUNT(*) AS total
FROM rides
GROUP BY ride_category
ORDER BY total DESC;



-- 14.Trip Status
SELECT
trip_status,
COUNT(*) AS total
FROM rides
GROUP BY trip_status;

-- 15.Driver Performance
SELECT
driver_name,
ROUND(AVG(driver_rating),2) AS avg_rating,
COUNT(*) AS total_trips
FROM rides
GROUP BY driver_name
ORDER BY avg_rating DESC
LIMIT 10;


-- 16.Customer Rating Analysis
SELECT
ROUND(AVG(customer_rating),2) AS avg_customer_rating
FROM rides;


-- 17.Traffic Condition Analysis
SELECT
traffic_condition,
COUNT(*) AS total
FROM rides
GROUP BY traffic_condition
ORDER BY total DESC;


-- 18.Weather Analysis
SELECT
weather,
COUNT(*) AS total
FROM rides
GROUP BY weather
ORDER BY total DESC;


-- 19.Surge Pricing

SELECT
ROUND(AVG(surge_multiplier),2) AS average_surge
FROM rides;


-- 20.Highest Revenue Drivers
SELECT
driver_name,
SUM(final_fare) AS revenue
FROM rides
GROUP BY driver_name
ORDER BY revenue DESC
LIMIT 10;




-- 21.Highest Revenue Cities
SELECT
pickup_city,
SUM(final_fare) AS revenue
FROM rides
GROUP BY pickup_city
ORDER BY revenue DESC;


-- 22.Longest Trips
SELECT
booking_id,
pickup_city,
drop_city,
trip_distance
FROM rides
ORDER BY trip_distance DESC
LIMIT 10;


-- 23.Most Expensive Trips

SELECT
booking_id,
driver_name,
final_fare
FROM rides
ORDER BY final_fare DESC
LIMIT 10;

