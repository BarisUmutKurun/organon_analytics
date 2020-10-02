/* Firstly, the data is observed with the following queries.
*/
SELECT *
FROM int_transaction;
SELECT *
FROM int_base_customer LIMIT 100;
/*Then an aggregate table is created to see the total_spend_per_customer and
  total_transaction_per_customer in the following dates.
*/
WITH agg_transactions AS (
    SELECT "CustomerID",
           SUM("UnitPrice"*"Quantity") AS total_spend_per_customer,
           SUM("Quantity") AS total_transaction_per_customer,
           date_part('day', '2011-11-30'- MAX("InvoiceDate"))
FROM int_transaction
WHERE "InvoiceDate" >= '2010-11-30' AND "InvoiceDate" <= '2011-12-09'
GROUP BY "CustomerID")
/* In the WHERE query, the date should be changed from 2010*-11-30 to 2011*-11-30.
 However, that produced no transaction since there is none in the int_transaction
 between 2011-11-30 and 2011-12-09.
*/
SELECT "CustomerID",
       total_spend_per_customer,
CASE WHEN total_spend_per_customer >= 5 THEN 'P' ELSE 'N' END AS target
FROM agg_transactions;
/* Then a new query is made to fetch the data that shows the total amount of shopping and
   the number of days passed from the last shopping date; until the observation date.
*/
SELECT "CustomerID", SUM("Quantity") AS total_amount_of_shopping, date_part('day', '2011-11-30'- MAX("InvoiceDate"))
FROM int_transaction
WHERE "InvoiceDate" >= '2010-11-30'
GROUP BY "CustomerID"
ORDER BY 2 DESC;
