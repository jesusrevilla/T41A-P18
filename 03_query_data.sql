SELECT * FROM productos 
WHERE etiquetas @> ARRAY['Tecnologia'];
