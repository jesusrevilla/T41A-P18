import os
from pathlib import Path

import psycopg2


ROOT = Path(__file__).resolve().parents[1]

SQL_CREATE = ROOT / "01_create_tables.sql"
SQL_INSERT = ROOT / "02_insert_data.sql"
SQL_EXER_PRODUCTOS = ROOT / "03_productos_tecnologia.sql"
SQL_EXER_EMPLEADOS = ROOT / "04_empleados_subordinados.sql"
SQL_EXER_CIUDADES = ROOT / "05_ciudades_alcanzables.sql"


def connect():
    """
    Crea una conexión a PostgreSQL usando variables de entorno
    o valores por defecto compatibles con GitHub Actions.
    """
    conn = psycopg2.connect(
        dbname=os.getenv("POSTGRES_DB", "test_db"),
        user=os.getenv("POSTGRES_USER", "postgres"),
        password=os.getenv("POSTGRES_PASSWORD", "postgres"),
        host=os.getenv("POSTGRES_HOST", "localhost"),
        port=os.getenv("POSTGRES_PORT", "5432"),
    )
    conn.autocommit = True
    return conn


def run_sql_file(cur, path: Path) -> None:
    """
    Ejecuta todo el contenido de un archivo .sql.
    Se asume que no hay parámetros y que el contenido es seguro.
    """
    with open(path, encoding="utf-8") as f:
        sql = f.read()
    cur.execute(sql)


def run_exercise_and_fetchall(sql_exercise_path: Path):
    """
    Vuelve a crear las tablas, inserta los datos
    y luego ejecuta el archivo de ejercicio, regresando todas las filas.
    """
    conn = connect()
    try:
        cur = conn.cursor()
        # Recrear el esquema y datos cada vez para que las pruebas sean independientes
        run_sql_file(cur, SQL_CREATE)
        run_sql_file(cur, SQL_INSERT)

        with open(sql_exercise_path, encoding="utf-8") as f:
            sql = f.read()
        cur.execute(sql)
        rows = cur.fetchall()
        return rows
    finally:
        conn.close()


def test_productos_etiquetas_es_array_text():
    """
    Verifica que la columna etiquetas de productos sea un ARRAY de TEXT.
    """
    conn = connect()
    try:
        cur = conn.cursor()
        run_sql_file(cur, SQL_CREATE)

        cur.execute("""
            SELECT data_type, udt_name
            FROM information_schema.columns
            WHERE table_name = 'productos'
              AND column_name = 'etiquetas';
        """)
        row = cur.fetchone()
        assert row is not None, "La columna productos.etiquetas no existe."
        data_type, udt_name = row
        assert data_type == "ARRAY", "La columna etiquetas debe ser de tipo ARRAY."
        assert udt_name == "_text", "La columna etiquetas debe ser un array de TEXT (udt_name = _text)."
    finally:
        conn.close()


def test_productos_tecnologia():
    """
    Verifica que la consulta 03_productos_tecnologia.sql
    regrese sólo productos que tienen la etiqueta 'tecnología'.
    """
    rows = run_exercise_and_fetchall(SQL_EXER_PRODUCTOS)
    assert rows, "La consulta no devolvió ningún producto."

    for _id, nombre, etiquetas in rows:
        assert 'tecnología' in etiquetas, (
            f"El producto {nombre} (id={_id}) no contiene la etiqueta 'tecnología'."
        )


def test_empleados_subordinados_de_ana():
    """
    Verifica que la CTE recursiva de 04_empleados_subordinados.sql
    devuelva los subordinados directos e indirectos de 'Ana'.
    """
    rows = run_exercise_and_fetchall(SQL_EXER_EMPLEADOS)
    nombres = {r[1] for r in rows}

    # Subordinados esperados según los datos insertados en 02_insert_data.sql
    expected = {'Luis', 'Marta', 'Pedro', 'Sofía', 'Carlos'}

    assert expected.issubset(nombres), (
        f"Faltan subordinados en el resultado. Esperados: {expected}, obtenidos: {nombres}"
    )
    assert 'Ana' not in nombres, "La jefa 'Ana' no debe aparecer como su propia subordinada."


def test_ciudades_alcanzables_desde_monterrey():
    """
    Verifica que la CTE recursiva de 05_ciudades_alcanzables.sql
    devuelva todas las ciudades alcanzables desde 'Monterrey'.
    """
    rows = run_exercise_and_fetchall(SQL_EXER_CIUDADES)
    ciudades = {r[0] for r in rows}

    expected = {'Saltillo', 'Torreón', 'CDMX', 'Guadalajara', 'Puerto Vallarta'}

    assert ciudades == expected, (
        f"Las ciudades alcanzables desde Monterrey no coinciden. "
        f"Esperadas: {expected}, obtenidas: {ciudades}"
    )
