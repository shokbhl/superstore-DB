
CREATE TABLE Orders (
  row_id int DEFAULT NULL,
  OrderID int NOT NULL,
  Category varchar(15) DEFAULT NULL,
  Sub_Category varchar(11) DEFAULT NULL,
 ProductName varchar(128) DEFAULT NULL,
  Sales float DEFAULT NULL,
  Quantity int DEFAULT NULL,
  Discount float DEFAULT NULL,
  Profit float DEFAULT NULL,
  Customer_Name varchar(25) DEFAULT NULL,
  Country varchar(15) DEFAULT NULL,
  Region varchar(10) DEFAULT NULL,
  State varchar(20) DEFAULT NULL,
  City varchar(17) DEFAULT NULL,
  zipcode int DEFAULT NULL,
  OrderDate DATE NOT NULL,
  OrderPriority VARCHAR(50) NOT NULL,
  Market VARCHAR(100) NOT NULL,
  Segment varchar(15) DEFAULT NULL,
  ShippingDate date DEFAULT NULL,
  ShippingMode varchar(15) DEFAULT NULL,
  ProductID int NOT NULL,
  CustomerID int NOT NULL,
 categoryID INT NOT NULL,
 regionid INT NOT NULL,
  PRIMARY KEY (OrderID),
  CONSTRAINT customerId_fk_orders
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (customerid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT productId_fk_orders
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
	

	 CREATE TABLE returned (
        returnID integer,
        OrderID integer NOT NULL,
        return_status varchar(20) NOT NULL,
        PRIMARY KEY (returnID),
        FOREIGN KEY (OrderID)
         REFERENCES Orders (OrderID));
    
	
	CREATE TABLE product_categories (
        categoryid     integer,
        category        varchar(60) NOT NULL,
        sub_category    varchar(100) NOT NULL,
        PRIMARY KEY (categoryid)
    );
	CREATE TABLE Products (
  ProductID integer NOT NULL,
  ProductName VARCHAR(255) NOT NULL,
  CategoryID int NOT NULL,
  category varchar(60) NOT NULL,
  Sub_category VARCHAR(100) NOT NULL,
  product_container   varchar(40) NOT NULL,
  unit_price          numeric(8,2) NOT NULL,
  product_base_margin numeric(5,2),
  PRIMARY KEY (ProductID),
  FOREIGN KEY (CategoryID) REFERENCES product_categories(CategoryID));
	
	CREATE TABLE customers (
        customerid   integer Not Null,
        customer_name varchar(100) NOT NULL,
        zipcode       integer NOT NULL,
        city          varchar(40) NOT NULL,
        PRIMARY KEY (customerid),
	CONSTRAINT customerId_fk_customersegment
        FOREIGN KEY (zipcode, city) REFERENCES addresses(zipcode, city)
    );
	
	- -----------------------------------------------------
-- Table Address
-- -----------------------------------------------------
CREATE TABLE addresses (
        zipcode    integer,
        city       varchar(40),
        state      varchar(40) NOT NULL
        region_id  integer NOT NULL,
        PRIMARY KEY (zipcode, city),
        FOREIGN KEY (region_id) REFERENCES regions(region_id)
    );
	
	-- Add a new column named 'Country' to the 'addresses' table
ALTER TABLE addresses
ADD COLUMN Country varchar(40) NOT NULL; 
ALTER TABLE addresses
ADD COLUMN region varchar(40) NOT NULL; 
	
	CREATE TABLE managers (
        manager_id integer,
        manager    varchar(50) NOT NULL,
        PRIMARY KEY (manager_id)
    );    
    
    CREATE TABLE regions (
        region_id  integer,
        region     varchar(15) NOT NULL,
        manager_id integer NOT NULL,
        PRIMARY KEY (region_id),
        FOREIGN KEY (manager_id) REFERENCES managers(manager_id)
    );
-- -----------------------------------------------------
-- Table Shipping
-- -----------------------------------------------------
CREATE TABLE Shipping (
  shipping_id    integer,
  transaction_id integer NOT NULL,
  OrderID int NOT NULL,
   zipcode    integer,
   city       varchar(40),
  ShippingDate DATE NOT NULL,
  ShippingMode VARCHAR(100) NOT NULL,
  ShippingCost DECIMAL NOT NULL,
  PRIMARY KEY (OrderID,shipping_id),
 FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
 FOREIGN KEY (OrderID) REFERENCES Orders (OrderID),
 FOREIGN KEY (zipcode, city) REFERENCES addresses (zipcode, city));
 
CREATE TABLE transactions (
        transaction_id   integer,
        orderid         integer NOT NULL,
        ProductID       integer NOT NULL,
        customerid      integer NOT NULL,
        orderdate       date NOT NULL,
        OrderPriority    varchar(30) NOT NULL,
        discount         numeric(5,2) NOT NULL,
        quantity_ordered integer,
        sales            numeric(10,2) NOT NULL,
        profit           numeric(16,8) NOT NULL,
        PRIMARY KEY (transaction_id),
        FOREIGN KEY (ProductID) REFERENCES products(ProductID),
        FOREIGN KEY (customerid) REFERENCES customers(customerid),
	FOREIGN KEY (orderid) REFERENCES orders(orderid)
    );
	
CREATE TABLE  Sales (
  OrderID int NOT NULL,
  ProductID INT NULL,
  Quantity INT NOT NULL,
  sales DECIMAL NOT NULL,
  Price DECIMAL NOT NULL,
  Discount DECIMAL NOT NULL,
  Profit DECIMAL NOT NULL,
  ShippingCost DECIMAL NOT NULL,
	 PRIMARY KEY (orderid),
  CONSTRAINT orderId_fk_sales
	 FOREIGN KEY (orderid) REFERENCES orders (orderid));
	




-- Drop the existing primary key constraint
ALTER TABLE orders
DROP CONSTRAINT pk_orderid;

-- Add a new primary key constraint with modified columns
ALTER TABLE orders
ADD PRIMARY KEY (orderid);

-- Drop the existing primary key constraint along with dependent objects
ALTER TABLE orders
DROP CONSTRAINT orders_pkey CASCADE;

-- Add a new composite primary key constraint
ALTER TABLE orders
ADD PRIMARY KEY (productid, orderid);



-- Add the new column 'productid' to the 'returned' table
ALTER TABLE returned
ADD COLUMN productid int; -- Replace <datatype> with the actual data type for productid

-- Update the 'productid' column with appropriate values (if needed)
-- UPDATE returned SET productid = ...;

-- Add a primary key constraint on the 'productid' column


ALTER TABLE returned
DROP CONSTRAINT returned_pkey;

-- Add the new column 'productid'
ALTER TABLE returned
ADD COLUMN productid int; -- Replace <datatype> with the actual data type for productid
-- Update null values in the 'productid' column
UPDATE returned
SET productid = 0
WHERE productid IS NULL;

-- Add a primary key constraint
ALTER TABLE returned
ADD PRIMARY KEY (returnid, productid);


SELECT *
FROM returned
WHERE (orderid, productid) NOT IN (SELECT orderid, productid FROM orders);




-- Example: Delete rows with conflicting foreign key values
DELETE FROM returned
WHERE (orderid, productid) NOT IN (SELECT orderid, productid FROM orders);

-- Add a foreign key constraint on the 'returned' table
ALTER TABLE returned
ADD CONSTRAINT returned_orders_fkey
FOREIGN KEY (orderid, productid)
REFERENCES orders(orderid, productid);

-- Add a foreign key constraint on the 'sales' table
-- Add a foreign key constraint on the 'sales' table for a composite key relationship
ALTER TABLE sales
ADD CONSTRAINT sales_orders_fk
FOREIGN KEY (orderid, productid)
REFERENCES orders(orderid, productid);

SELECT *
FROM sales
WHERE (orderid, productid) NOT IN (SELECT orderid, productid FROM orders);

-- Example: Delete rows with conflicting foreign key values
DELETE FROM sales
WHERE (orderid, productid) NOT IN (SELECT orderid, productid FROM orders);





-- Add a 'shipping_id' column to the 'orders' table
ALTER TABLE orders
ADD COLUMN shipping_id INT;  -- Adjust the data type accordingly

-- Populate the 'shipping_id' column in the 'orders' table with appropriate values
-- UPDATE orders SET shipping_id = ...;

-- Add a foreign key constraint on the 'shipping' table
-- Add a foreign key constraint on the 'shipping' table



-- Add data types for constraints
ALTER TABLE comparison_results
ADD COLUMN data_type VARCHAR;

-- Update data types for constraints
UPDATE comparison_results
SET data_type = c.data_type
FROM information_schema.columns c
WHERE c.table_name = comparison_results.table_name
  AND c.column_name = comparison_results.column_name;

-- Display the comparison results
SELECT * FROM comparison_results;

-- Drop the temporary table
DROP TABLE IF EXISTS comparison_results;

ALTER TABLE orders
ADD CONSTRAINT orders_unique_constraint
UNIQUE (orderid, shipping_id);



ALTER TABLE shipping
ADD CONSTRAINT shipping_orders_fk
FOREIGN KEY (orderid,shipping_id)
REFERENCES orders(orderid,shipping_id);



-- Add a foreign key constraint on the 'transactions' table

ALTER TABLE transactions
ADD CONSTRAINT transactions_orders_fk
FOREIGN KEY (orderid, productid)
REFERENCES orders(orderid, productid);


-- Add a foreign key constraint on the 'transactions' table for a composite key relationship
-- Add a new foreign key constraint with a different name
ALTER TABLE transactions
ADD CONSTRAINT transactions_orders_fk_new
FOREIGN KEY (orderid, productid)
REFERENCES orders(orderid, productid);



-- Drop the existing primary key constraint
ALTER TABLE public.returned
DROP CONSTRAINT returned_pkey;

-- Add a new primary key constraint (if needed) or remove the primary key constraint on productid
-- If you want to keep a primary key, you can add a new column as a surrogate key
-- If you want to remove the primary key entirely, you can skip the following line
-- ALTER TABLE public.returned ADD CONSTRAINT returned_new_pkey PRIMARY KEY (returnid);

-- If you want to keep a unique constraint on returnid and productid, you can add it here
-- ALTER TABLE public.returned ADD CONSTRAINT returned_unique_constraint UNIQUE (returnid, productid);
	
	
	-- Drop the existing primary key constraint
ALTER TABLE public.returned
DROP CONSTRAINT returned_pkey;

-- Add a new primary key constraint on returnid
ALTER TABLE public.returned
ADD CONSTRAINT returned_pkey PRIMARY KEY (returnid);



-- Add a unique constraint on orderid in the orders table
ALTER TABLE public.orders
ADD CONSTRAINT orders_orderid_unique UNIQUE (orderid);

-- Add a foreign key constraint on orderid in the returned table
ALTER TABLE public.returned
ADD CONSTRAINT returned_orderid_fk FOREIGN KEY (orderid)
REFERENCES public.orders (orderid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;
	
	
	-- Drop the existing primary key constraint on returnid
ALTER TABLE public.returned
DROP CONSTRAINT returned_pkey;

-- Drop the existing foreign key constraint on orderid
ALTER TABLE public.returned
DROP CONSTRAINT returned_orderid_fk;

-- Add the new composite primary key constraint on returnid and orderid
ALTER TABLE public.returned
ADD CONSTRAINT returned_pkey PRIMARY KEY (returnid, orderid);




