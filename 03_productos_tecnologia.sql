SELECT
    id,
    nombre,
    etiquetas
FROM productos
WHERE 'tecnología' = ANY(etiquetas)
ORDER BY id;
