-- how many burgers were ordered?
select count(runner_id) 
from runner_orders;

-- how many unique customer orders were made ?
select count(distinct customer_id) 
from customer_orders;

-- how many successful orders were delivered by eah runner ?
select runner_id, count(distinct order_id) as successful_orders 
from runner_orders 
where cancellation is NULL
group by runner_id;

-- how many of each type of burger was delivered ?
select b.burger_name ,count(c.burger_id) 
from burger_names b 
join customer_orders c on b.burger_id = c.burger_id 
join runner_orders r on r.order_id = c.order_id 
where cancellation is null
group by burger_name;

-- how many vegeterain and meatlovers were ordered by each customer ?
select customer_id,burger_name,count(burger_name) 
from customer_orders c 
join burger_names b on b.burger_id = c.burger_id 
group by customer_id,burger_name;

-- what was the maximum number of burgers were delivered in a single order ?
with max_order as
(
select c.order_id,count(c.burger_id) as burger_per_order
from customer_orders c 
join runner_orders r on r.order_id = c.order_id
group by c.order_id
)
select max(burger_per_order) as max_burgers_per_order 
from max_order ;

-- for each customer,how many delivered burgers had at least 1 change and 
-- how many had no change ?
select customer_id,count(exclusions and extras) 
from customer_orders c 
join runner_orders r on c.order_id=r.order_id
where cancellation is null 
group by customer_id ;

-- For each customer, how many delivered burgers had at least 1 change and
-- how many had no changes?
select c.customer_id,
sum(case 
when c.exclusions<> ' ' or c.extras <> ' ' then 1 else 0 end) as at_least_1change,
sum(case 
when c.exclusions=' ' and c.extras = ' ' then 1 else 0 end ) as no_change 
from customer_orders c join runner_orders r on c.order_id=r.order_id
where cancellation is null 
group by customer_id ;

-- what was the total volume of burgers ordered for each hour of the day ?
select extract(hour from order_time) as hour_of_the_day,
count(burger_id) as burgers_count
from customer_orders
group by extract(hour from order_time);

-- how many runners signed up for each 1 week period?
select extract(week from registration_date) as weeek_num,
count(runner_id) as runner_signup
from burger_runner
group by extract(week from registration_date);

-- what was the avg distance travelled for each customer ?
select customer_id ,round(avg(distance),2) as avg_distance 
from customer_orders c 
join runner_orders r on c.order_id = r.order_id
group by customer_id;