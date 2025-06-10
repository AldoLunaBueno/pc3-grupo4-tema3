import io
import sys
import pytest
from scripts.generar_diagrama import parse_args, generar_diagrama

def test_parse_args_minimal(tmp_path, monkeypatch):
    """
    Verifica que el argumento --pattern se procese correctamente 
    y que --output tome el valor por defecto cuando no se especifica.
    """
    # No mostará warnings innecesarios durante la prueba
    monkeypatch.setenv("PYTHONWARNINGS", "ignore")

    # Simular argumentos pasados por consola
    sys_argv = ["generar_diagrama.py", "-p", "singleton"]
    monkeypatch.setattr(sys, "argv", sys_argv)

    # Ejecutar el parser de argumentos
    args = parse_args()

    assert args.pattern == "singleton"
    assert args.output == "diagram.png"

def test_generar_diagrama_prints_correctly(capsys):
    """
    Comprobar que la función generar_diagrama imprima correctamente
    el mensaje con el nombre del patrón y el archivo de salida.
    """

    generar_diagrama("factory", "out.png")

    captured = capsys.readouterr()

    assert "Patrones:  factory :  out.png" in captured.out