import sqlite3
import pytest

def test_insert_user():
    conn = sqlite3.connect(":memory:")
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE usuarios(id INTEGER PRIMARY KEY, nombre TEXT)")
    cursor.execute("INSERT INTO usuarios(nombre) VALUES ('Ana')")
    cursor.execute("SELECT nombre FROM usuarios WHERE id=1")
    result = cursor.fetchone()
    assert result[0] == "Ana"
