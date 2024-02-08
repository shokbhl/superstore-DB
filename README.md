

--Here are brief definitions for each table and a short description of their relationships with other tables:

Table: addresses

Definition: Customers or stores address details, including zipcode, city, state, region, country, and region_id.
Relationship: Connected to public.regions through the Foreign Key region_id.

Table: customers

Definition: Contains customer information, such as customerid, customer_name, zipcode, and city.
Relationship: Linked to public.addresses using the Foreign Key on zipcode and city.

Table: managers

Definition: Stores manager details with manager_id and manager name.
Relationship: connected to regions by  manager_id to show that which manager  related to which region to find information about managers of each store 



Definition: Holds information about orders, including orderid, product details, customer details, and shipping information.
Relationships: Connected to multiple tables - products, customers, product_categories, regions, shipping.


Table: product_categories

Definition: Contains product category details, such as categoryid, category, and sub_category.
Relationship: Connected to products through the Foreign Key categoryid.


Table: products

Definition: Stores information about products, including productid, productname, category details, etc.
Relationship: Linked to product_categories through the Foreign Key categoryid.


Table: regions

Definition: Contains details about regions, including region_id, region name, and manager_id.
Relationship: Connected to managers through the Foreign Key manager_id.

Table: returned

Definition: Records information about returned items, including returnid, orderid, and return status.
Relationship: Connected to orders through the Foreign Key orderid.


Table: sales

Definition: Stores sales-related details, including orderid, productid, quantity, sales, etc.
Relationship: Connected to orders through the Foreign Key orderid and productid.


--Here's a brief explanation of each column in the 'orders' table:

orderid: Unique identifier for each order (Primary Key).
row_id: Identifier for the order row.
category, sub_category, productname: Categorization and name of the product.
sales, quantity, discount, profit: Numeric values related to the sales and profitability.
customer_name, country, region, state, city, zipcode: Customer and location details.
orderdate: Date of the order (Not NULL).
orderpriority: Priority of the order (Not NULL).
market: Market information (Not NULL).
segment: Segment information.
shippingdate: Date of shipping.
shippingmode: Mode of shipping.
productid: Foreign Key referencing products(productid).
customerid: Foreign Key referencing customers(customerid).
categoryid: Foreign Key referencing product_categories(categoryid).
regionid: Foreign Key referencing regions(region_id).
shipping_id: Foreign Key referencing shipping(orderid, shipping_id) (Unique constraint on (orderid, shipping_id) in shipping table).

Constraints:

Primary Key: orderid
Unique Constraint: Unique on orderid (implicitly added by being the primary key).
Foreign Key Relationships:

productid references products(productid)
customerid references customers(customerid)
categoryid references product_categories(categoryid)
regionid references regions(region_id)
shipping_id references shipping(orderid, shipping_id) (Unique constraint on (orderid, shipping_id) in shipping table).

-- Here's a brief explanation of how other tables relate to the orders table:

products table:

Relation: productid in orders Table is a Foreign Key referencing products(productid).
Explanation: The orders table is associated with the products table through the productid column, indicating the product details related to each order.
customers table:

Relation: customerid in orders is a Foreign Key referencing customers(customerid).
Explanation: The orders table is associated with the customers table through the customerid column, linking each order to a specific customer.
product_categories table:

Relation: categoryid in orders is a Foreign Key referencing product_categories(categoryid).
Explanation: The orders table is associated with the product_categories table through the categoryid column, providing information about the product category for each order.
regions table:

Relation: regionid in orders is a Foreign Key referencing regions(region_id).
Explanation: The orders table is associated with the regions table through the regionid column, connecting each order to a specific region.
shipping table:

Relation: orderid and shipping_id in orders are Foreign Keys referencing shipping(orderid, shipping_id) (Unique constraint on (orderid, shipping_id) in shipping table).
Explanation: The orders table is associated with the shipping table through the combination of orderid and shipping_id. This relationship uniquely identifies the shipping details for each order.	 

-----------
NOTICE : 
----------
After initially creating tables, I identified the need for modifications to the primary keys and foreign keys to prevent duplication issues. Consequently, I decided to alter the tables to address these concerns. However, this modification led to the unintentional loss of certain connections between the tables.

To rectify this situation, I carefully examined the relationships between the tables and made the necessary adjustments. This involved updating the tables to establish new connections and ensuring that the alterations maintained the integrity of the database structure. By doing so, I aimed to reconcile any lost connections and create a coherent and well-defined relational database.

In summary, my process involved initially altering the primary keys and foreign keys, acknowledging the resultant loss of connections, and subsequently re-establishing and refining these connections through meticulous updates to the tables. This iterative approach allowed me to maintain the consistency and reliability of the database while addressing the initial concerns of avoiding duplicate entries.

