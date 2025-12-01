
INSERT INTO usuarios (data) VALUES
    ('{"nombre": "Ana", "activo": true, "edad": 30}'),
    ('{"nombre": "Juan", "activo": false, "edad": 25}');

INSERT INTO productos (nombre, etiquetas) VALUES
    ('Laptop Pro', ARRAY['tecnología', 'portátil']),
    ('Teclado Mecánico RGB', ARRAY['tecnología', 'accesorios']),
    ('Monitor 4K UHD', ARRAY['tecnología', 'pantallas']),
    ('Teléfono', ARRAY['móvil', 'comunicación']);

INSERT INTO empleados (nombre, jefe_id) VALUES
    ('Ana (Jefa)', NULL),         -- id 1
    ('Maria (Desarrollador)', 1), -- id 2
    ('Luis (Pasante)', 2);        -- id 3

