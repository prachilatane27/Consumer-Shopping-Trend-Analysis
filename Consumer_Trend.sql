CREATE DATABASE consumer_trend_db;
USE consumer_trend_db;

-- Total Records and Shopping Preference Distribution
SELECT 
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN shopping_preference = 'Store' THEN 1 END) AS store_count,
    COUNT(CASE WHEN shopping_preference = 'Online' THEN 1 END) AS online_count,
    COUNT(CASE WHEN shopping_preference = 'Hybrid' THEN 1 END) AS hybrid_count,
    ROUND(COUNT(CASE WHEN shopping_preference = 'Store' THEN 1 END) * 100.0 / COUNT(*), 2) AS store_pct,
    ROUND(COUNT(CASE WHEN shopping_preference = 'Online' THEN 1 END) * 100.0 / COUNT(*), 2) AS online_pct,
    ROUND(COUNT(CASE WHEN shopping_preference = 'Hybrid' THEN 1 END) * 100.0 / COUNT(*), 2) AS hybrid_pct
FROM df_consumer_cleaned;

-- Average Spending & Orders by Shopping Preference
SELECT 
    shopping_preference,
    COUNT(*) AS customer_count,
    ROUND(AVG(monthly_income), 0) AS avg_monthly_income,
    ROUND(AVG(avg_online_spend), 0) AS avg_online_spend,
    ROUND(AVG(avg_store_spend), 0) AS avg_store_spend,
    ROUND(AVG(monthly_online_orders), 2) AS avg_online_orders
FROM df_consumer_cleaned
GROUP BY shopping_preference
ORDER BY customer_count DESC;


-- Gender + Shopping Preference
SELECT 
    gender,
    shopping_preference,
    COUNT(*) AS count,
    ROUND(AVG(monthly_income), 0) AS avg_income
FROM df_consumer_cleaned
GROUP BY gender, shopping_preference;

-- City Tier Analysis
SELECT 
    city_tier,
    shopping_preference,
    COUNT(*) AS customer_count,
    ROUND(AVG(monthly_income), 0) AS avg_income,
    ROUND(AVG(tech_savvy_score), 2) AS avg_tech_savvy
FROM df_consumer_cleaned
GROUP BY city_tier, shopping_preference
ORDER BY city_tier, customer_count DESC;

-- Key Behavioral Scores by Shopping Preference
SELECT 
    shopping_preference,
    ROUND(AVG(tech_savvy_score), 2) AS avg_tech_savvy,
    ROUND(AVG(need_touch_feel_score), 2) AS avg_need_touch_feel,
    ROUND(AVG(online_payment_trust_score), 2) AS avg_payment_trust,
    ROUND(AVG(discount_sensitivity), 2) AS avg_discount_sensitivity,
    ROUND(AVG(impulse_buying_score), 2) AS avg_impulse_buying
FROM df_consumer_cleaned
GROUP BY shopping_preference;

-- Internet & Social Media Behavior
SELECT 
    shopping_preference,
    ROUND(AVG(daily_internet_hours), 2) AS avg_internet_hours,
    ROUND(AVG(social_media_hours), 2) AS avg_social_media_hours,
    ROUND(AVG(monthly_online_orders), 2) AS avg_online_orders_per_month
FROM df_consumer_cleaned
GROUP BY shopping_preference;


--  City Tier Analysis


SELECT 
    city_tier,
    COUNT(*) AS total_customers,
    ROUND(AVG(CASE WHEN shopping_preference = 'Online' THEN 1 ELSE 0 END)*100, 2) AS online_preference_pct,
    ROUND(AVG(CASE WHEN shopping_preference = 'Hybrid' THEN 1 ELSE 0 END)*100, 2) AS hybrid_preference_pct,
    ROUND(AVG(tech_savvy_score), 2) AS avg_tech_score
FROM df_consumer_cleaned
GROUP BY city_tier;


-- High Value Customers
SELECT 
    shopping_preference,
    COUNT(*) AS high_value_customers,
    ROUND(AVG(avg_online_spend + avg_store_spend), 0) AS avg_total_spend
FROM df_consumer_cleaned
WHERE monthly_income > (SELECT AVG(monthly_income) FROM df_consumer_cleaned)
GROUP BY shopping_preference;

-- Tech Savvy Level Analysis
SELECT 
    CASE 
        WHEN tech_savvy_score >= 8 THEN 'High Tech Savvy'
        WHEN tech_savvy_score >= 5 THEN 'Medium Tech Savvy'
        ELSE 'Low Tech Savvy'
    END AS tech_level,
    shopping_preference,
    COUNT(*) AS customer_count
FROM df_consumer_cleaned
GROUP BY tech_level, shopping_preference
ORDER BY tech_level;

-- Need Touch & Feel Impact on Store Preference
SELECT 
    CASE 
        WHEN need_touch_feel_score >= 8 THEN 'High Need Touch & Feel'
        WHEN need_touch_feel_score >= 5 THEN 'Medium'
        ELSE 'Low'
    END AS touch_feel_level,
    COUNT(CASE WHEN shopping_preference = 'Store' THEN 1 END) AS store_preference_count,
    ROUND(COUNT(CASE WHEN shopping_preference = 'Store' THEN 1 END) * 100.0 / COUNT(*), 2) AS store_pct
FROM df_consumer_cleaned
GROUP BY touch_feel_level;