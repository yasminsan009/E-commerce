-- Criando Views para personalização de acessos

-- Número de empregados por departamento e localidade
CREATE VIEW employees_by_department AS
SELECT d.idDepartment, d.departmentName, d.location, COUNT(e.idEmployee) AS numEmployees
FROM department d
JOIN employee e ON d.idDepartment = e.idDepartment
GROUP BY d.idDepartment, d.departmentName, d.location;

-- Lista de departamentos e seus gerentes
CREATE VIEW department_managers AS
SELECT d.idDepartment, d.departmentName, e.idEmployee, e.Fname, e.Lname
FROM department d
JOIN employee e ON d.managerId = e.idEmployee;

-- Projetos com maior número de empregados
CREATE VIEW projects_by_employee_count AS
SELECT p.idProject, p.projectName, COUNT(e.idEmployee) AS numEmployees
FROM project p
JOIN employee_project ep ON p.idProject = ep.idProject
JOIN employee e ON ep.idEmployee = e.idEmployee
GROUP BY p.idProject, p.projectName
ORDER BY numEmployees DESC;

-- Lista de projetos, departamentos e gerentes
CREATE VIEW project_department_manager AS
SELECT p.idProject, p.projectName, d.idDepartment, d.departmentName, e.idEmployee AS managerId, e.Fname, e.Lname
FROM project p
JOIN department d ON p.idDepartment = d.idDepartment
JOIN employee e ON d.managerId = e.idEmployee;

-- Empregados com dependentes e se são gerentes
CREATE VIEW employees_with_dependents AS
SELECT e.idEmployee, e.Fname, e.Lname, e.isManager, COUNT(d.idDependent) AS numDependents
FROM employee e
LEFT JOIN dependent d ON e.idEmployee = d.idEmployee
GROUP BY e.idEmployee, e.Fname, e.Lname, e.isManager;

-- Criando usuários e permissões
CREATE USER 'gerente'@'localhost' IDENTIFIED BY 'senha_gerente';
CREATE USER 'employee'@'localhost' IDENTIFIED BY 'senha_employee';

GRANT SELECT ON employees_by_department TO 'gerente'@'localhost';
GRANT SELECT ON department_managers TO 'gerente'@'localhost';
GRANT SELECT ON projects_by_employee_count TO 'gerente'@'localhost';
GRANT SELECT ON project_department_manager TO 'gerente'@'localhost';
GRANT SELECT ON employees_with_dependents TO 'gerente'@'localhost';

GRANT SELECT ON employees_with_dependents TO 'employee'@'localhost';

-- Criando Triggers para manipulação de dados

-- Trigger Before DELETE para armazenar informações antes da remoção de usuários
DELIMITER //
CREATE TRIGGER before_delete_client
BEFORE DELETE ON clients
FOR EACH ROW
BEGIN
    INSERT INTO deleted_clients (idClient, Fname, Lname, CPF, CNPJ, Address, deletionDate)
    VALUES (OLD.idClient, OLD.Fname, OLD.Lname, OLD.CPF, OLD.CNPJ, OLD.Address, NOW());
END //
DELIMITER ;

-- Trigger Before UPDATE para atualizar salário base
DELIMITER //
CREATE TRIGGER before_update_salary
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salário não pode ser reduzido!';
    END IF;
END //
DELIMITER ;