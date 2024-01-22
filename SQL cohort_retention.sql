---cleaning data
--- Total records =  541909
--- 135080 Records have no CustomerID
--- 406829 Records have CustomerID

;WITH online_retail as
(
SELECT *
FROM dbo.[Online Retailcvs]
WHERE CustomerID != 0
)
, quantity_unit_price as
(
--- 358364 Records with quantity and unit price
 SELECT *
 FROM online_retail
 WHERE Quantity > 0 AND UnitPrice > 0
 )

 ,dup_check as
 (
 --- duplicate check
 SELECT *, ROW_NUMBER()over (partition by InvoiceNO, StockCode, Quantity order by InvoiceDate)dup_flag
 FROM quantity_unit_price
 )
 --- 353682 where dup_flag is 1
 --- 4682 where dup_flag is greater than 1
 SELECT *
 INTO #online_retail_main
 FROM dup_check
 WHERE dup_flag = 1

 --- Begin corhort analysis
 SELECT *
 FROM #online_retail_main 

 --- Unique Identifier(CustomerID)
 --- Initail start date(first invoice date)
 --- Reveune date

 SELECT CustomerID, MIN(InvoiceDate)First_purchase_date, DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(invoiceDate)), 1) cohort_date
 INTO #cohort
 FROM #online_retail_main
 GROUP BY CustomerID

 --- Implementing a time-based cohort/retention analysis
  SELECT *
  FROM  #cohort

  ---create cohort index
SELECT 
  mmm.*,
  cohort_index = year_diff * 12 + month_diff + 1
INTO #cohort_retention
FROM
   (
  SELECT
     mm.*,
	 year_diff = invoice_year - cohort_year,
	 month_diff = invoice_month - cohort_month
  FROM 
      (
      SELECT 
          m.*,
	      YEAR(m.InvoiceDate) invoice_year,
	      MONTH(M.InvoiceDate) invoice_month,
	      YEAR(c.cohort_date) cohort_year,
	      MONTH(c.cohort_date) cohort_month
     FROM #online_retail_main m
     LEFT JOIN #cohort c
          ON m.CustomerID = c.CustomerID 
    ) mm
 )mmm	
 --- pivot data to see cohort date
 SELECT *
 INTO #cohort_pivot
 FROM(

   SELECT distinct
         CustomerID,
		 cohort_index,
		 cohort_month
   FROM #cohort_retention
 
 )tbl
 pivot(
     count(CustomerID)
	 FOR cohort_index IN
           (
		   [1],
		   [2],
		   [3],
		   [4],
		   [5],
		   [6],
		   [7],
		   [8],
		   [9],
		   [10],
		   [11],
		   [12],
		   [13])


) AS pivot_table

SELECT *,1.0* [1]/[1] *100, 1.0 *[2]/[1] * 100
FROM #cohort_pivot
ORDER BY cohort_month