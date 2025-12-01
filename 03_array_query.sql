-- Consultar productos con la etiqueta 'tecnología'

SELECT * FROM productos
WHERE 'tecnología' = ANY(etiquetas);
