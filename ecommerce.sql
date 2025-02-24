-- Criando o banco de dados
CREATE DATABASE ecommerce;
USE ecommerce;

-- Tabela clients
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) DEFAULT NULL,     -- Campo CPF, pode ser NULL se for PJ
    CNPJ CHAR(14) DEFAULT NULL,    -- Campo CNPJ, pode ser NULL se for PF
    isPJ BOOL NOT NULL DEFAULT 0,  -- 0 para PF, 1 para PJ
    Address VARCHAR(30),
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT cpf_or_cnpj CHECK (
        (CPF IS NOT NULL AND CNPJ IS NULL AND isPJ = 0) OR 
        (CNPJ IS NOT NULL AND CPF IS NULL AND isPJ = 1)
    )
);
ALTER TABLE clients AUTO_INCREMENT = 1;

-- Tabela product
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10), 
    classification_kids BOOL DEFAULT FALSE,
    category ENUM("Eletrônico", "Vestimenta", "Brinquedo", "Alimento", "Móveis") NOT NULL,
    avaliação FLOAT DEFAULT 0,
    size VARCHAR(10)
);

-- Tabela payments
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    paymentMethod ENUM('Boleto', 'Cartão', 'PIX') NOT NULL,
    limitAvailable FLOAT,
    CONSTRAINT fk_payments_client FOREIGN KEY (idClient) REFERENCES clients(idClient)
);
-- Tabela orders
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM("Cancelado", "Confirmado", "Em processamento") DEFAULT "Em Processamento",
    orderDescription VARCHAR(255),
    delivery FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT FALSE,
    deliveryStatus ENUM('Pendente', 'Em trânsito', 'Entregue') DEFAULT 'Pendente',  -- Status da entrega
    trackingCode VARCHAR(50) DEFAULT NULL,  -- Código de rastreio
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);

-- Tabela productStorage
CREATE TABLE productStorage (
    idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255), 
    quantity INT DEFAULT 0
);

-- Tabela suplier
CREATE TABLE suplier (
    idSuplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL, 
    CNPJ CHAR(15),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_suplier UNIQUE (CNPJ)
);

-- Tabela seller
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL, 
    fantasyName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- Tabela productSeller
CREATE TABLE productSeller (
    idPseller INT AUTO_INCREMENT,
    idProduct INT,
    quantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idProduct) REFERENCES product(idProduct)
);

-- Tabela productOrder
CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM("Disponível", "Indisponível") DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder) -- Corrigindo o nome da constraint
);

-- Tabela productSupplier
CREATE TABLE productSupplier (
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_productSupplier_supplier FOREIGN KEY (idPsSupplier)
        REFERENCES suplier(idSuplier),
    CONSTRAINT fk_productSupplier_product FOREIGN KEY (idPsProduct)
        REFERENCES product(idProduct)
);
