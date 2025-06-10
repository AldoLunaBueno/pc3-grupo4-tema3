import sys
import pytest
from pathlib import Path

@pytest.fixture(autouse=True)
def add_project_root_to_syspath(monkeypatch):
    """
    Asegura que 'scripts/' sea importable como paquete.
    """
    project_root = Path(__file__).parent.parent.resolve()
    monkeypatch.syspath_prepend(str(project_root))

def test_parse_args_minimal(monkeypatch):
    # --pattern es obligatorio, --output por defecto
    monkeypatch.setenv("PYTHONWARNINGS", "ignore")
    monkeypatch.setattr(sys, "argv", ["generar_diagrama.py", "-p", "singleton"])
    from scripts.generar_diagrama import parse_args

    args = parse_args()
    assert args.pattern == "singleton"
    assert args.output == "diagram.png"

def test_parse_args_with_output(monkeypatch):
    # Combinación -p y -o
    monkeypatch.setattr(sys, "argv", ["generar_diagrama.py", "-p", "factory", "-o", "foo.png"])
    from scripts.generar_diagrama import parse_args

    args = parse_args()
    assert args.pattern == "factory"
    assert args.output == "foo.png"

def test_generar_diagrama_prints_correctly(capsys):
    # Verifica que la función imprime el texto esperado
    from scripts.generar_diagrama import generar_diagrama

    generar_diagrama("composite", "out.png")
    captured = capsys.readouterr().out

    assert "Patrones:" in captured
    assert "composite" in captured
    assert "out.png" in captured