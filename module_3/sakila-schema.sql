CREATE OR REPLACE DATABASE sakila;

USE DATABASE sakila;
USE SCHEMA PUBLIC;

CREATE TABLE actor (
  actor_id SMALLINT NOT NULL AUTOINCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id)
  --KEY idx_actor_last_name (last_name)
);

--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id SMALLINT NOT NULL AUTOINCREMENT,
  country VARCHAR(50) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (country_id)
) ;

-- Table structure for table `city`
--

CREATE TABLE city (
  city_id SMALLINT NOT NULL AUTOINCREMENT,
  city VARCHAR(50) NOT NULL,
  country_id SMALLINT NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (city_id),
  --KEY idx_fk_country_id (country_id),
  CONSTRAINT `fk_city_country` FOREIGN KEY (country_id) REFERENCES country (country_id) 
) ;

-- Table structure for table `address`
--


CREATE TABLE address (
  address_id SMALLINT  NOT NULL AUTOINCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
 
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (address_id),
  --KEY idx_fk_city_id (city_id),
  
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

--
-- Table structure for table `category`
--

CREATE TABLE category (
  category_id TINYINT  NOT NULL AUTOINCREMENT,
  name VARCHAR(25) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (category_id)
) ;

-- Table structure for table `staff`
--

CREATE or replace TABLE staff (
  staff_id TINYINT NOT NULL AUTOINCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id SMALLINT  NOT NULL,
  picture BINARY,
  email VARCHAR(50) DEFAULT NULL,
  store_id TINYINT  NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (staff_id),
  --KEY idx_fk_store_id (store_id),
  --KEY idx_fk_address_id (address_id),
  --CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

--
-- Table structure for table `store`
--

CREATE TABLE store (
  store_id TINYINT NOT NULL AUTOINCREMENT,
  manager_staff_id TINYINT  NOT NULL,
  address_id SMALLINT  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY  (store_id),
  --UNIQUE KEY manager_staff_id,
  --KEY idx_fk_address_id (address_id),
  CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

CREATE or replace TABLE staff (
  staff_id TINYINT NOT NULL AUTOINCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id SMALLINT  NOT NULL,
  picture BINARY,
  email VARCHAR(50) DEFAULT NULL,
  store_id TINYINT  NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) DEFAULT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (staff_id),
  --KEY idx_fk_store_id (store_id),
  --KEY idx_fk_address_id (address_id),
  CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;
--
-- Table structure for table `customer`
--

CREATE TABLE customer (
  customer_id SMALLINT  NOT NULL AUTOINCREMENT,
  store_id TINYINT  NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id SMALLINT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE,
  create_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (customer_id),
  --KEY idx_fk_store_id (store_id),
  --KEY idx_fk_address_id (address_id),
  --KEY idx_last_name (last_name),
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ,
  CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) 
) ;

--
-- Table structure for table `language`
--

CREATE TABLE language (
  language_id TINYINT  NOT NULL AUTOINCREMENT,
  name CHAR(20) NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (language_id)
);
--
-- Table structure for table `film`
--

CREATE or replace TABLE film (
  film_id SMALLINT  NOT NULL AUTOINCREMENT,
  title VARCHAR(128) NOT NULL,
  description TEXT DEFAULT NULL,
  release_year NUMBER(4,0) DEFAULT NULL,--change from year to NUMBER(4,0)
  language_id TINYINT NOT NULL,
  original_language_id TINYINT  DEFAULT NULL,
  rental_duration TINYINT  NOT NULL DEFAULT 3,
  rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99,
  length SMALLINT  DEFAULT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99,
  rating VARCHAR(128) DEFAULT 'G',--enum not accept
  special_features VARCHAR(128) DEFAULT NULL,--set not accept
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (film_id),
  --KEY idx_title (title),
  --KEY idx_fk_language_id (language_id),
  --KEY idx_fk_original_language_id (original_language_id),
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

--
-- Table structure for table `film_actor`
--

CREATE TABLE film_actor (
  actor_id SMALLINT  NOT NULL,
  film_id SMALLINT  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (actor_id,film_id),
  --KEY idx_fk_film_id (`film_id`),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

--
-- Table structure for table `film_category`
--

CREATE TABLE film_category (
  film_id SMALLINT  NOT NULL,
  category_id TINYINT  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;



--
-- Table structure for table `inventory`
--

CREATE TABLE inventory (
  inventory_id int  NOT NULL AUTOINCREMENT,-- change from mediumint into int
  film_id SMALLINT  NOT NULL,
  store_id TINYINT  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (inventory_id),
  --KEY idx_fk_film_id (film_id),
  --KEY idx_store_id_film_id (store_id,film_id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

-- Table structure for table `rental`
--

CREATE TABLE rental (
  rental_id INT NOT NULL AUTOINCREMENT,
  rental_date DATETIME NOT NULL,
  inventory_id int  NOT NULL,--change from mediumint into int
  customer_id SMALLINT  NOT NULL,
  return_date DATETIME DEFAULT NULL,
  staff_id TINYINT  NOT NULL,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (rental_id),
  --UNIQUE KEY  (rental_date,inventory_id,customer_id),
  --KEY idx_fk_inventory_id (inventory_id),
  --KEY idx_fk_customer_id (customer_id),
  --KEY idx_fk_staff_id (staff_id),
  CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;

--

--
-- Table structure for table `payment`
--

CREATE TABLE payment (
  payment_id SMALLINT  NOT NULL AUTOINCREMENT,
  customer_id SMALLINT  NOT NULL,
  staff_id TINYINT  NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME NOT NULL,
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (payment_id),
  --KEY idx_fk_staff_id (staff_id),
  --KEY idx_fk_customer_id (customer_id),
  CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ;


--

