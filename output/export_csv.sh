#!/bin/bash

DB="ride_analytics"
OUT=~/RideSharingAnalytics/output

mkdir -p $OUT

run_query () {
    filename=$1
    query=$2

    hive -S -e "USE $DB; $query" | sed 's/\t/,/g' > "$OUT/$filename.csv"

    echo "Saved $filename.csv"
}

run_query "01_total_trips" \
"SELECT COUNT(*) AS total_trips FROM rides;"

run_query "02_total_revenue" \
"SELECT SUM(final_fare) AS total_revenue FROM rides;"

run_query "03_average_fare" \
"SELECT ROUND(AVG(final_fare),2) AS average_fare FROM rides;"

run_query "04_average_trip_distance" \
"SELECT ROUND(AVG(trip_distance),2) AS average_distance FROM rides;"

run_query "05_average_ride_duration" \
"SELECT ROUND(AVG(ride_duration),2) AS average_duration FROM rides;"

run_query "06_trips_by_pickup_city" \
"SELECT pickup_city, COUNT(*) AS total_trips FROM rides GROUP BY pickup_city ORDER BY total_trips DESC;"

run_query "07_trips_by_drop_city" \
"SELECT drop_city, COUNT(*) AS total_trips FROM rides GROUP BY drop_city ORDER BY total_trips DESC;"

run_query "08_revenue_by_pickup_city" \
"SELECT pickup_city, SUM(final_fare) AS revenue FROM rides GROUP BY pickup_city ORDER BY revenue DESC;"

run_query "09_peak_booking_hours" \
"SELECT hour, COUNT(*) AS total_rides FROM rides GROUP BY hour ORDER BY total_rides DESC;"

run_query "10_trips_by_day_of_week" \
"SELECT day_of_week, COUNT(*) AS total_rides FROM rides GROUP BY day_of_week ORDER BY total_rides DESC;"

run_query "11_monthly_revenue" \
"SELECT year, month, SUM(final_fare) AS revenue FROM rides GROUP BY year, month ORDER BY year, month;"

run_query "12_payment_methods" \
"SELECT payment_type, COUNT(*) AS total FROM rides GROUP BY payment_type ORDER BY total DESC;"

run_query "13_ride_category" \
"SELECT ride_category, COUNT(*) AS total FROM rides GROUP BY ride_category ORDER BY total DESC;"

run_query "14_trip_status" \
"SELECT trip_status, COUNT(*) AS total FROM rides GROUP BY trip_status;"

run_query "15_driver_performance" \
"SELECT driver_name, ROUND(AVG(driver_rating),2) AS avg_rating, COUNT(*) AS total_trips FROM rides GROUP BY driver_name ORDER BY avg_rating DESC LIMIT 10;"

run_query "16_customer_rating" \
"SELECT ROUND(AVG(customer_rating),2) AS avg_customer_rating FROM rides;"

run_query "17_traffic_condition" \
"SELECT traffic_condition, COUNT(*) AS total FROM rides GROUP BY traffic_condition ORDER BY total DESC;"

run_query "18_weather_analysis" \
"SELECT weather, COUNT(*) AS total FROM rides GROUP BY weather ORDER BY total DESC;"

run_query "19_average_surge" \
"SELECT ROUND(AVG(surge_multiplier),2) AS average_surge FROM rides;"

run_query "20_highest_revenue_drivers" \
"SELECT driver_name, SUM(final_fare) AS revenue FROM rides GROUP BY driver_name ORDER BY revenue DESC LIMIT 10;"

run_query "21_highest_revenue_cities" \
"SELECT pickup_city, SUM(final_fare) AS revenue FROM rides GROUP BY pickup_city ORDER BY revenue DESC;"

run_query "22_longest_trips" \
"SELECT booking_id, pickup_city, drop_city, trip_distance FROM rides ORDER BY trip_distance DESC LIMIT 10;"

run_query "23_most_expensive_trips" \
"SELECT booking_id, driver_name, final_fare FROM rides ORDER BY final_fare DESC LIMIT 10;"

echo ""
echo "======================================"
echo "All 23 CSV files exported successfully"
echo "Location: $OUT"
echo "======================================"
