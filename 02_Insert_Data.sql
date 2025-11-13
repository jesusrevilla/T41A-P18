-- CEO
INSERT INTO empleados (nombre, jefe_id)
VALUES ('Carlos CEO', NULL);

-- Directores
INSERT INTO empleados (nombre, jefe_id)
VALUES ('Ana Directora Finanzas', 1),
       ('Luis Director TI', 1),
       ('María Directora Marketing', 1);

-- Subordinados de Finanzas
INSERT INTO empleados (nombre, jefe_id)
VALUES ('Pedro Analista Finanzas', 2),
       ('Lucía Contadora', 2);

-- Subordinados de TI
INSERT INTO empleados (nombre, jefe_id)
VALUES ('Javier SysAdmin', 3),
       ('Sofía Desarrolladora', 3),
       ('Miguel QA Tester', 3);

-- Subordinados de Marketing
INSERT INTO empleados (nombre, jefe_id)
VALUES ('Sandra Diseñadora', 4),
       ('Diego Social Media', 4);
