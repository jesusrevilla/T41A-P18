import pytest
import psycopg2
import os

class TestPostgreSQLFeatures:
    
    @pytest.fixture(scope="class")
    def db_connection(self):
        """Fixture para establecer conexión a la base de datos de prueba"""
        conn = psycopg2.connect(
            host="localhost",
            database="test_db",
            user="postgres",
            password="postgres",
            port=5432
        )
        yield conn
        conn.close()
    
    def test_products_table_exists(self, db_connection):
        """Test 1: Verificar que la tabla productos existe"""
        with db_connection.cursor() as cursor:
            cursor.execute("""
                SELECT EXISTS (
                    SELECT 1 FROM information_schema.tables 
                    WHERE table_name = 'productos'
                );
            """)
            result = cursor.fetchone()[0]
            assert result == True, "La tabla 'productos' no existe"
    
    def test_products_inserted(self, db_connection):
        """Test 2: Verificar que se insertaron al menos 3 productos"""
        with db_connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM productos;")
            count = cursor.fetchone()[0]
            assert count >= 3, f"Solo hay {count} productos, se esperaban al menos 3"
    
    def test_technology_products(self, db_connection):
        """Test 3: Verificar productos con etiqueta 'tecnología'"""
        with db_connection.cursor() as cursor:
            cursor.execute("""
                SELECT COUNT(*) FROM productos 
                WHERE 'tecnología' = ANY(etiquetas);
            """)
            count = cursor.fetchone()[0]
            assert count > 0, "No hay productos con etiqueta 'tecnología'"
    
    def test_employees_hierarchy(self, db_connection):
        """Test 4: Verificar jerarquía de empleados"""
        with db_connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM empleados;")
            count = cursor.fetchone()[0]
            assert count >= 5, f"Solo hay {count} empleados, se esperaban al menos 5"
    
    def test_cities_graph(self, db_connection):
        """Test 5: Verificar grafo de ciudades"""
        with db_connection.cursor() as cursor:
            cursor.execute("SELECT COUNT(*) FROM ciudades;")
            cities_count = cursor.fetchone()[0]
            
            cursor.execute("SELECT COUNT(*) FROM rutas;")
            routes_count = cursor.fetchone()[0]
            
            assert cities_count >= 5, f"Solo hay {cities_count} ciudades"
            assert routes_count >= 8, f"Solo hay {routes_count} rutas"
    
    def test_reachable_cities(self, db_connection):
        """Test 6: Verificar que se pueden encontrar ciudades alcanzables"""
        with db_connection.cursor() as cursor:
            cursor.execute("""
                WITH RECURSIVE ciudades_alcanzables AS (
                    SELECT c.id, c.nombre, 0 as depth
                    FROM ciudades c WHERE c.nombre = 'Madrid'
                    UNION ALL
                    SELECT cd.id, cd.nombre, ca.depth + 1
                    FROM rutas r
                    INNER JOIN ciudades cd ON r.ciudad_destino_id = cd.id
                    INNER JOIN ciudades_alcanzables ca ON r.ciudad_origen_id = ca.id
                    WHERE ca.nombre != cd.nombre AND ca.depth < 3
                )
                SELECT COUNT(DISTINCT nombre) FROM ciudades_alcanzables;
            """)
            reachable_count = cursor.fetchone()[0]
            assert reachable_count > 1, "No se pueden encontrar rutas desde Madrid"

if __name__ == "__main__":
    pytest.main([__file__, "-v"])
