# Proyecto 3: "Diseño y compartición de módulos IaC con patrones de software"

> Práctica calificada 3
> Grupo 4

---

## Instalación

El primer paso es obtener este repositorio con todos los contenidos necesarios. Para esto no basta clonar, también es necesario obtener los submódulos:

```bash
git clone --recurse-submodules <url-del-repo>
```

El segundo paso es asegurarte de que tienes Python (>=3.10) y Terraform (>=1.2) instalados, y que en tu entorno puedes usar Bash.

## Sprint 1

[Link Video del Sprint_1-Grupo3](https://drive.google.com/file/d/1ZWNHv99Dbc8p1jF8iGqgm0_ftpk_M3Xp/view?usp=sharing)

## Archivo `main.sh`

Archivo que automatiza la ejecución de todo el proyecto, dentro de sus funciones está lo siguiente:

* Si es ejecutado por primera vez:

  * Crea y activa el entorno virtual `.venv`.
  * Instala las dependencias.
  * Activa los hooks dentro de `git-hooks/`.

* Desde la segunda ejecución:

  * Acciona el patrón puesto.
  * limpia el estado.

```bash
cd scripts
source ./main.sh --pattern <nombre-patrón>
```

## Herramientas usadas

### 1. flake8, bandit

* **flake8**: Linter útil para verificar código en Python.
* **bandit**: Herramienta de análisis de seguridad para código en python.

### 2. Pytest

Framework de pruebas para python, usado para asegurar buenas pruebas en los scripts `verify_state.py`, `generate_documentation.py`, `generate_diagram.py`, `etc`.

### Git Hooks

Tomamos la decisión de versionar los hooks para que sean más trazables y más fáciles de obtener (con git pull).

Para esto, los hooks no están en la ruta habitual `.git/hooks`, donde no se puede versionar nada, sino en `git-hooks`. Queremos que cada colaborador pueda usar estos hooks, pero Git no sabe automáticamente cuál es el nuevo directorio que queremos usar para ellos, así que se lo decimos con el siguiente comando:

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

Este hook verifica la rama sobre la que estamos haciendo commit. No se permite hacer commit sobre una rama que no siga las convenciones de ramificación usadas para este proyecto. Por ejemplo, impide que se pueda hacer un commit sobre ``main``. Actualmente, seguimos el patrón de ``Continuous Integration``, así que **solo hacemos commits sobre ramas feature/\*, hotfix/\* y docs/\***.

## Scripts

### 1. `verify_state.py`

## Submodulos

Generación de submodulos para simular uso de futuros módulos externalizados.

## Sprint 2

## Patrones de diseño

### Singleton

#### 1. `variables.tf`

Define las variables de entrada para la generación de una instancia simple.

* `instance_name`: nombre de la instancia.

* `instance_type`: tipo de instancia, por defecto es "basic".

#### 2. `main.tf`

Ejecuta un script para controlar la creación de la instancia.

* Usa `null_resource` para representar la instancia única global.
* triggers para accionar las variables `instance_name` e `instance_type`.
* Ejecuta el script `singleton.sh` dentro de un provisioner.

#### 3. `outputs.tf`

* `create_instance` muestra el nombre de la instancia y da el visto bueno de la creación de dicha instancia.

#### 4. `singleton.sh`

Asegura que la instancia sea única en su creación.

* `LOCK_FILE` evita la creación de múltiples instancias simultaneas.
* `PID_FILE` guarda el PID del proceso actual.
  * Si este `PID` ya existe, ejecuta un mensaje de instancia existente.
  * Si no existe el `lock`, lo crea y muestra su creación.
* Limpia el `PID` al finalizar la ejecución del script.

### Ejecución

```bash
main.sh --pattern singleton
# ejecuta el ejemplo de creación de instancia.
```

### Builder

#### 1. `build_config.yaml`

Automatiza la ejecución secuencial de módulos definidos en build_config.yaml

* `global_settings:`: Ajusta el comando Terraform (`terraform_command`) y el flag `-auto-approve`.  
* `build_steps:`: Es la lista de pasos con:
  * `name`, `directory` y `action` 
  * Bloques `variables:` que se convierten en `-var="clave=valor"` .

#### 2. `main.tf`

Orquesta `null_resource` con triggers y dependencias:

* `step1_initialize_env`: Inicializa el entorno base según configuración e incluye timestamp() para volver a ejecutar.

* `step2_configure_network` : Configura la red con el cidr_block y número de subredes.

* `step3_deploy_app` : Despliega la aplicación con nombre y versión especificados; depende de step2.

#### 3. `builder.sh`

Lee `build_config.yaml` y ejecuta cada paso secuencialmente:

* Parseo de `global_settings:` para ajustar `TERRAFORM_CMD` y `AUTO_APPROVE_FLAG`.  
* Extracción de `build_steps:` con recuento de pasos y lectura de variables.  
* Para cada paso:
  1. `terraform init` (con reintentos silenciosos).  
  2. Genera argumentos `-var="clave=valor"` y lanza `terraform <action>`.  
  3. Imprime `[BUILD_SCRIPT_INFO]` o `[BUILD_SCRIPT_ERROR]` según el resultado.  

### Ejecución

```bash
bash builder.sh
# o
main.sh --pattern builder



### 2. Prototype

## Sprint 3
