-- Inserindo dados na tabela clients
USE ecommerce;

INSERT INTO clients (Fname, Minit, Lname, CPF, CNPJ, isPJ, Address) VALUES
('João', 'A', 'Silva', '12345678901', NULL, 0, 'Rua A, 123'),
('Maria', 'B', 'Oliveira', '23456789012', NULL, 0, 'Rua B, 456'),
('Carlos', 'C', 'Souza', NULL, '12345678000195', 1, 'Av. Empresarial, 789');

-- Inserindo dados na tabela product
INSERT INTO product (Pname, classification_kids, category, avaliação, size) VALUES
('Celular', FALSE, 'Eletrônico', 4.5, '15cm'),
('Camiseta', FALSE, 'Vestimenta', 4.2, 'M'),
('Boneca', TRUE, 'Brinquedo', 4.8, '30cm');

-- Inserindo dados na tabela payments
INSERT INTO payments (idClient, paymentMethod, limitAvailable) VALUES
(1, 'Cartão', 5000.00),
(1, 'PIX', 2000.00),
(2, 'Boleto', 1500.00),
(3, 'Cartão', 10000.00);

-- Inserindo dados na tabela orders
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, delivery, paymentCash, deliveryStatus, trackingCode) VALUES
(1, 'Confirmado', 'Compra de um celular', 10.00, FALSE, 'Em trânsito', 'TRK123456'),
(2, 'Em processamento', 'Compra de uma camiseta', 10.00, TRUE, 'Pendente', NULL),
(3, 'Confirmado', 'Compra de uma boneca', 10.00, FALSE, 'Entregue', 'TRK789123');

-- Inserindo dados na tabela productStorage
INSERT INTO productStorage (storageLocation, quantity) VALUES
('Depósito A', 100),
('Depósito B', 50),
('Depósito C', 30);

-- Inserindo dados na tabela suplier
INSERT INTO suplier (socialName, CNPJ, contact) VALUES
('Fornecedor A', '11111111000199', '11999999999'),
('Fornecedor B', '22222222000188', '21988888888');

-- Inserindo dados na tabela seller
INSERT INTO seller (socialName, fantasyName, CNPJ, CPF, location, contact) VALUES
('Loja Tech', 'Tech Store', '33333333000177', NULL, 'Rua das Vendas, 100', '31977777777'),
('Loja Moda', 'Fashion Store', NULL, '34567890123', 'Rua da Moda, 200', '11966666666');

-- Inserindo dados na tabela productSeller
INSERT INTO productSeller (idPseller, idProduct, quantity) VALUES
(1, 1, 20),
(2, 2, 15);

-- Inserindo dados na tabela productOrder
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
(1, 1, 1, 'Disponível'),
(2, 2, 1, 'Disponível');

-- Inserindo dados na tabela productSupplier
INSERT INTO productSupplier (idPsSupplier, idPsProduct, quantity) VALUES
(1, 1, 50),
(2, 2, 40);


-- 1. Quantos pedidos foram feitos por cada cliente?
SELECT c.Fname, c.Lname, COUNT(o.idOrder) AS total_pedidos
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient;

-- 2. Algum vendedor também é fornecedor?
SELECT s.socialName AS vendedor, su.socialName AS fornecedor
FROM seller s
JOIN suplier su ON s.CNPJ = su.CNPJ
WHERE s.CNPJ IS NOT NULL AND su.CNPJ IS NOT NULL;

-- 3. Relação de produtos fornecedores e estoques;
SELECT p.Pname, su.socialName AS fornecedor, ps.quantity AS estoque
FROM product p
JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
JOIN suplier su ON ps.idPsSupplier = su.idSuplier;

-- 4. Relação de nomes dos fornecedores e nomes dos produtos;
SELECT su.socialName AS fornecedor, p.Pname AS produto
FROM product p
JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
JOIN suplier su ON ps.idPsSupplier = su.idSuplier;







