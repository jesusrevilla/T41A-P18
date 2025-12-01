DO $$
BEGIN
  -- Validar que Ana tiene 'PostgreSQL' como primer interés
  IF EXISTS (
    SELECT 1 FROM usuarios WHERE nombre = 'Ana' AND intereses[1] = 'PostgreSQL'
  ) THEN
    RAISE NOTICE 'OK: interés correcto para Ana';
  ELSE
    RAISE EXCEPTION 'Fallo: interés incorrecto para Ana';
  END IF;

  -- Validar que Laptop tiene etiqueta 'tecnología'
  IF EXISTS (
    SELECT 1 FROM productos WHERE nombre = 'Laptop' AND 'tecnología' = ANY(etiquetas)
  ) THEN
    RAISE NOTICE 'OK: etiqueta correcta para Laptop';
  ELSE
    RAISE EXCEPTION 'Fallo: etiqueta incorrecta para Laptop';
  END IF;

  -- Validar que Pedro está en la red de amigos de Ana
  IF EXISTS (
    WITH RECURSIVE red_amigos AS (
      SELECT id, nombre, amigo_id FROM amigos WHERE nombre = 'Ana'
      UNION ALL
      SELECT a.id, a.nombre, a.amigo_id
      FROM amigos a
      INNER JOIN red_amigos r ON a.amigo_id = r.id
    )
    SELECT 1 FROM red_amigos WHERE nombre = 'Pedro'
  ) THEN
    RAISE NOTICE 'OK: Pedro está en la red de Ana';
  ELSE
    RAISE EXCEPTION 'Fallo: Pedro no está en la red de Ana';
  END IF;
END;
$$;
