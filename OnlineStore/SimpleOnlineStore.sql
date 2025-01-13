-- SimpleOnlineStore
/*
-- Documentation

- Product Catalog Management:

	This would store information about the products available for sale.
	It would include attributes such as product name, description, price, quantity in stock,
	images, and other relevant details.
	
- Customer Information :

	This would store information about registered customers.

	It would include data such as customer name, contact details, shipping address, login credentials.

- Order Information:

	This would store information about customer orders. 
	It would include data such as order number, customer details, order date and time,
	purchased products, quantities, prices, shipping method, and order status.

	Order Status: 
		
		1.Delivered
		2.Cancelled
		3.Processing
		4.Pending
		5.Shipped
		6.Refunded
		
- Payment Transaction:

	This would store information about payment transactions.

	It would include data such as transaction ID, customer details, payment amount,
	payment method, timestamp.
	
- Shipping:

	This would store information about shipping and logistics.
	
	It would include data such as order ID, shipping carrier details, tracking number,
	shipping status, Estimated delivery date, Actual Delivery Date and any related notes or updates.
	
	Shipping Status:
	
		1. Processing
		2. Out for Delivery
		3. Delivered
		4. Return to Sender
		5. On Hold
		6. Delayed
		7. Lost
		
- Reviews and Ratings:

	This would store customer reviews and ratings for products.
	It would include data such as product ID, customer ID, review text, rating score (1 to 5), 
	and timestamps.
*/

-- Create a Database "SimpleOnlineStore" Has Tables About
--	(Categories, Products, ProductImages, Orders, OrderItems, Shippings, Transactions, 
--	Customers, Reviews)

CREATE DATABASE SimpleOnlineStore;

USE SimpleOnlineStore;
GO

-- Create Store Schema
CREATE SCHEMA Store;

-- Create Table Categories
CREATE TABLE Store.Categories (
	CategoryID INT IDENTITY (1, 1),
	CategoryName VARCHAR (100) NOT NULL,
	
	CONSTRAINT PK_Categories PRIMARY KEY (CategoryID),
	
	CONSTRAINT UQ_Categories_CategoryName UNIQUE (CategoryName)
);

-- Create Table Products
CREATE TABLE Store.Products (
	ProductID INT IDENTITY (1, 1),
	ProductName VARCHAR (100) NOT NULL,
	Description VARCHAR (500) NOT NULL,
	ProductPrice SMALLMONEY NOT NULL,
	Stock SMALLINT NOT NULL,
	CategoryID INT NOT NULL,
	
	CONSTRAINT PK_Products PRIMARY KEY (ProductID),
	
	CONSTRAINT UQ_Products_ProductName UNIQUE (ProductName),
	
	CONSTRAINT FK_Products_Categories FOREIGN KEY 
	(CategoryID) REFERENCES Store.Categories (CategoryID)
);

-- Create Table Customers
CREATE TABLE Store.Customers (
	CustomerID INT IDENTITY (1, 1),
	FirstName VARCHAR (30) NOT NULL,
	LastName VARCHAR (30) NOT NULL,
	EmailAddress VARCHAR (70) NOT NULL,
	PhoneNumber VARCHAR (20) NOT NULL,
	ShippingAddress VARCHAR (200) NOT NULL,
	UserName VARCHAR (100) NOT NULL,
	Password VARCHAR (50) NOT NULL,
	
	CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),
	
	CONSTRAINT UQ_Customers_EmailAddress UNIQUE (EmailAddress),
	CONSTRAINT UQ_Customers_PhoneNumber UNIQUE (PhoneNumber),
	CONSTRAINT UQ_Customers_UserName UNIQUE (UserName),

	CONSTRAINT CK_Customers_EmailAddress CHECK
	(EmailAddress LIKE '%@%.com'),
	CONSTRAINT CK_Customers_PhoneNumber CHECK
	(PhoneNumber LIKE '+201-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]')
);

-- Create Table Reviews
CREATE TABLE Store.Reviews (
	ReviewID INT IDENTITY (1, 1),
	ReviewText VARCHAR (500) NOT NULL,
	Rating TINYINT NOT NULL,
	ReviewDateTime DATETIME DEFAULT GETDATE(),
	ProductID INT NOT NULL,
	CustomerID INT NOT NULL,
	
	CONSTRAINT PK_Reviews PRIMARY KEY (ReviewID),
	
	CONSTRAINT CK_Reviews_Rating CHECK
	(Rating BETWEEN 1 and 5),
	
	CONSTRAINT FK_Reviews_Products FOREIGN KEY
	(ProductID) REFERENCES Store.Products (ProductID),
	CONSTRAINT FK_Reviews_Customers FOREIGN KEY
	(CustomerID) REFERENCES Store.Customers (CustomerID)
);	
	
-- Create Table Orders
CREATE TABLE Store.Orders (
	OrderID INT IDENTITY (1, 1),
	OrderDateTime DATETIME DEFAULT GETDATE(),
	OrderShipDateTime DATETIME NOT NULL,
	OrderDueDateTime DATETIME NOT NULL,
	TotalAmount SMALLMONEY NOT NULL,
	OrderStatus SMALLINT NOT NULL,
	CustomerID INT NOT NULL,
	
	CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
	
	CONSTRAINT FK_Orders_Customers FOREIGN KEY
	(CustomerID) REFERENCES Store.Customers (CustomerID)
);

-- Create Table OrderItems
CREATE TABLE Store.OrderItems (
	OrderID INT,
	ProductID INT,
	Quantity TINYINT NOT NULL,
	ItemPrice SMALLMONEY NOT NULL,
	TotalPrice AS (Quantity * ItemPrice) PERSISTED,
	
	CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ProductID),
	
	CONSTRAINT FK_OrderItems_Orders FOREIGN KEY 
	(OrderID) REFERENCES Store.Orders (OrderID),
	CONSTRAINT FK_OrderItems_Products FOREIGN KEY
	(ProductID) REFERENCES Store.Products (ProductID)
);

-- Create Table Shippings 
CREATE TABLE Store.Shippings (
	ShippingID INT IDENTITY (1, 1),
	CarrierName VARCHAR (100) NOT NULL,
	TrackingNumber VARCHAR (50) NOT NULL,
	ShippingStatus SMALLINT NOT NULL,
	DeliveryDateTime DATETIME NOT NULL,
	AdditionalNots VARCHAR (200),
	OrderID INT NOT NULL,
	
	CONSTRAINT PK_Shippings PRIMARY KEY (ShippingID),
	
	CONSTRAINT FK_Shippings_Orders FOREIGN KEY 
	(OrderID) REFERENCES Store.Orders (OrderID)
);

-- Create Table Transactions
CREATE TABLE Store.Transactions(
	TransactionID INT IDENTITY (1, 1),
	PaymentAmount SMALLMONEY NOT NULL,
	PaymentMethod VARCHAR (50) NOT NULL,
	TransactioDate DATETIME DEFAULT GETDATE(),
	OrderID INT NOT NULL,
	CustomerID INT NOT NULL,
	
	CONSTRAINT PK_Transactions PRIMARY KEY (TransactionID),
	
	CONSTRAINT FK_Transactions_Orders FOREIGN KEY 
	(OrderID) REFERENCES Store.orders (OrderID),
	CONSTRAINT FK_Transactions_Customers FOREIGN KEY 
	(CustomerID) REFERENCES Store.Customers (CustomerID)
);