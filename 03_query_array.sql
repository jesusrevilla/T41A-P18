-- 3 - Consultar todos los productos que contengan la etiqueta 'tecnología'.
SELECT nombre FROM productos WHERE 'tecnología' = ANY(etiquetas);
