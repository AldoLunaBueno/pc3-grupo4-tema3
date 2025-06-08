# Proyecto 3: "Diseño y compartición de módulos IaC con patrones de software"

> Práctica calificada 3
> Grupo 4

---

## Sprint 1

### Git Hooks

Tomamos la decisión de versionar los hooks para que sean más trazables y más fáciles de obtener (con git pull).

Para esto, los hooks no están en la ruta habitual ".git/hooks", donde no se puede versionar nada, sino en "git-hooks". Queremos que cada colaborador pueda usar estos hooks, pero Git no sabe automáticamente cuál es el nuevo directorio que queremos usar para ellos, así que se lo decimos con el siguiente comando:

```bash
git config core.hooksPath git-hooks
```

**Todos los colaboradores debemos correr este comando en nuestro repositorio local** para que los hooks funcionen y nos ayuden a no incurrir en inconsistencias en nuestros commits. Veremos más en detalle qué hace cada hook definido en [git-hooks](./git-hooks/).

#### commit-msg

Este hook nos ayuda a que cada mensaje de commit sea claro. La validación se hace con base en la convención [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). No implementamos todos los casos posibles, pero sí los más importantes. Para empezar, todos los commits deben seguir esta estructura:

```txt
<type>[optional scope]: <description>

[optional body]
```

Validamos tres puntos:

1. El campo ``type`` debe ser un tipo especificado en *Conventional commits*.
2. El campo ``scope`` es opcional, pero no se pueden dejar paréntesis vacíos.
3. El título del commit (la primera línea) no debe exceder los 72 caracteres (buena práctica no especificada en el documento oficial)

También se deja lugar para un cuerpo opcional para el mensaje del commit.

#### pre-commit

Este hook verifica la rama sobre la que estamos haciendo commit. No se permite hacer commit sobre una rama que no siga las convenciones de ramificación usadas para este proyecto. Por ejemplo, impide que se pueda hacer un commit sobre ``main``. Actualmente, seguimos el patrón de ``Continuous Integration``, así que **solo hacemos commits sobre ramas feature/\***.

## Sprint 2

## Sprint 3
