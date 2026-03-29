INSERT INTO productos (nombre, etiquetas) VALUES 
('PC', ARRAY['tecnología', 'computo', 'portátil']),
('Moto', ARRAY['transporte', 'tecnología', 'mecánica']),
('Sofa', ARRAY['hogar', 'asiento', 'comodidad']);

INSERT INTO empleados (nombre, jefe_id) VALUES
('Uriel', NULL),
('Fernanda', 3),
('María', 1),
('Alejandro', 3);

INSERT INTO ciudades (nombre, alrededores) VALUES
('San Luis Potosí', ARRAY['Rioverde', 'Santa María']),
('Rioverde', ARRAY['Cd Valles', 'Cerritos']),
('Cd Valles', ARRAY['Rascon', 'Tamuin']),
('Santa María', ARRAY['Villa de Reyes', 'Soledad']),
('Rascon', ARRAY[NULL]),
('Cerritos', ARRAY[NULL]),
('Soledad', ARRAY[NULL]),
('Tamuin', ARRAY[NULL]),
('Villa de Reyes', ARRAY[NULL]);
