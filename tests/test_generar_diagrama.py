import io
import sys
import pytest
from scripts.generate_diagram import parse_args, generate_diagram

def test_parse_args_minimal(tmp_path, monkeypatch):
    """
    Verifica que el argumento --pattern se procese correctamente 
    y que --output tome el valor por defecto cuando no se especifica.
    """
    # No mostará warnings innecesarios durante la prueba
    monkeypatch.setenv("PYTHONWARNINGS", "ignore")

    # Simular argumentos pasados por consola
    sys_argv = ["generate_diagram.py", "-p", "singleton"]
    monkeypatch.setattr(sys, "argv", sys_argv)

    # Ejecutar el parser de argumentos
    args = parse_args()

    assert args.pattern == "singleton"
    assert args.output == "diagram.png"

def test_generate_diagram_prints_correctly(capsys):
    """
    Comprobar que la función generate_diagram imprima correctamente
    el mensaje con el nombre del patrón y el archivo de salida.
    """

    generate_diagram("factory", "out.png")

    captured = capsys.readouterr()

    assert "Patrones:  factory :  out.png" in captured.out