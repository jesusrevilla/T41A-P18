INSERT INTO empleados (nombre, jefe_id) VALUES
('Ana', NULL),
('Luis', 1),
('Marta', 2),
('Pedro', 2);

INSERT INTO productos (nombre, etiquetas)
VALUES ('TV', ARRAY['Tecnologia', 'Descuento', 'Hogar']),
        ('Libro', ARRAY['Lectura', 'Regalo', 'Accesorio']),
        ('Playera', ARRAY['Ropa', 'Tela', 'Deportivo']);
