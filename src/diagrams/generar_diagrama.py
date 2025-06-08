#!/usr/bin/env python3
import argparse

def generar_diagrama(pattern: str, salida: str):
    print("Patrones: ", pattern, ": ", salida)

def parse_args():
    parser = argparse.ArgumentParser(
        description="Diagrama:"
    )
    parser.add_argument(
        "-p", "--pattern",
        required=True,
        choices=["singleton", "composite", "factory", "prototype", "builder"]
    )
    parser.add_argument(
        "-o", "--output",
        default="diagram.png"
    )
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    generar_diagrama(args.pattern, args.output)
