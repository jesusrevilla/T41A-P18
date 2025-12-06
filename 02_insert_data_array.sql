--Insertar al menos 3 productos con diferentes etiquetas
INSERT INTO productos(nombre,etiquetas)
VALUES ('Computadora',ARRAY['tecnología','Hogar']),
       ('Celular',ARRAY['tecnología','Personal']),
       ('Cama',ARRAY['Hogar','Personal']);
