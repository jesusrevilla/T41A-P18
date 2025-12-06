import psycopg2
import sys

def fail(msg):
    print(f"ERROR: {msg}")
    sys.exit(1)

def ok(msg):
    print(f"OK: {msg}")

try:
    conn = psycopg2.connect(
        host="localhost",
        dbname="postgres",
        user="postgres",
        password="postgres"
    )
    cur = conn.cursor()
except Exception as e:
    fail(f"No se pudo conectar a PostgreSQL: {e}")

# ---------------------------
# TEST 1: Tabla productos
# ---------------------------
cur.execute("SELECT COUNT(*) FROM productos;")
count = cur.fetchone()[0]

if count >= 3:
    ok("Se insertaron al menos 3 productos.")
else:
    fail("No se insertaron 3 productos en la tabla productos.")

# ---------------------------
# TEST 2: Consulta de etiqueta 'tecnología'
# ---------------------------
cur.execute("""
SELECT nombre FROM productos 
WHERE 'tecnología' = ANY(etiquetas);
""")

result = cur.fetchall()

if len(result) >= 1:
    ok("Consulta de productos con etiqueta 'tecnología' funcionando.")
else:
    fail("La consulta de productos con la etiqueta 'tecnología' no regresó resultados.")

# ---------------------------
# TEST 3: Tabla empleados creada
# ---------------------------
try:
    cur.execute("SELECT COUNT(*) FROM empleados;")
    total_emps = cur.fetchone()[0]
    ok("Tabla empleados creada correctamente.")
except:
    fail("La tabla empleados no existe.")

# ---------------------------
# TEST 4: Jerarquía insertada
# ---------------------------
cur.execute("SELECT nombre FROM empleados ORDER BY id;")
names = [row[0] for row in cur.fetchall()]

# Validamos que existan los empleados clave
expected = {"Angel", "Robert", "Pedro", "Cruz"}

if expected.issubset(set(names)):
    ok("Jerarquía de empleados insertada correctamente.")
else:
    fail("Falta uno o más empleados en la jerarquía.")

# ---------------------------
# TEST 5: CTE recursiva — subordinados del jefe 2
# ---------------------------
cur.execute("""
WITH RECURSIVE subs_jefe AS(
  SELECT id, nombre, jefe_id FROM empleados WHERE jefe_id = 2
  UNION ALL
  SELECT e.id, e.nombre, e.jefe_id
  FROM empleados e
  INNER JOIN subs_jefe j ON e.jefe_id = j.id
)
SELECT nombre FROM subs_jefe;
""")

subs = [row[0] for row in cur.fetchall()]

if "Pedro" in subs and "Cruz" in subs:
    ok("CTE recursiva funciona correctamente (subordinados del jefe 2).")
else:
    fail("La CTE recursiva no devolvió los subordinados correctos.")

print("\nTODOS LOS TESTS PASARON CORRECTAMENTE 🎉")

cur.close()
conn.close()

