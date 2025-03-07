-- Criando índices para otimizar consultas

-- Índice para busca rápida de clientes pelo CPF
CREATE UNIQUE INDEX idx_clients_cpf ON clients(CPF);

-- Índice para busca rápida de clientes pelo CNPJ
CREATE UNIQUE INDEX idx_clients_cnpj ON clients(CNPJ);

-- Índice para busca rápida de produtos por categoria
CREATE INDEX idx_product_category ON product(category);

-- Índice para busca rápida de pedidos por status
CREATE INDEX idx_orders_status ON orders(orderStatus);

-- Índice para busca rápida de status de entrega
CREATE INDEX idx_delivery_status ON orders(deliveryStatus);

-- Procedure para manipulação de dados no banco de dados e-commerce
DELIMITER //
CREATE PROCEDURE ManageClient (
    IN action INT,
    IN p_idClient INT,
    IN p_Fname VARCHAR(10),
    IN p_Minit CHAR(3),
    IN p_Lname VARCHAR(20),
    IN p_CPF CHAR(11),
    IN p_CNPJ CHAR(14),
    IN p_isPJ BOOL,
    IN p_Address VARCHAR(30)
)
BEGIN
    CASE action
        WHEN 1 THEN -- Inserção de novo cliente
            INSERT INTO clients (Fname, Minit, Lname, CPF, CNPJ, isPJ, Address)
            VALUES (p_Fname, p_Minit, p_Lname, p_CPF, p_CNPJ, p_isPJ, p_Address);
        WHEN 2 THEN -- Atualização de cliente
            UPDATE clients
            SET Fname = p_Fname, Minit = p_Minit, Lname = p_Lname,
                CPF = p_CPF, CNPJ = p_CNPJ, isPJ = p_isPJ, Address = p_Address
            WHERE idClient = p_idClient;
        WHEN 3 THEN -- Remoção de cliente
            DELETE FROM clients WHERE idClient = p_idClient;
    END CASE;
END //
DELIMITER ;
