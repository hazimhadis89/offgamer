
# Readme
This repo is the answer for **Question 1**.
- composer is **required**
- php: `7.4`
- `dump` & `schema` in `extra\mysql` folder
- `flowchart` in `extra\flowchart` folder
- Reward functions at `app\Models\Reward.php`
- example use case at `main.php`

## Question 2
Query below able to run using mysqldump from **Question 1**.
```
SELECT COUNT(DISTINCT orders.id) AS number_of_order,
SUM(IF(`type` = 'Normal',`normal_price`,`promotion_price`)) AS total_sales_amount
FROM order_product
LEFT JOIN orders ON order_product.order_id = orders.id;
