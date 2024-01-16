![Logo of the project](https://cienciadedatosysalud.org/wp-content/uploads/logo-Data-Science-VPM.png)


<p align="center">
  
  [:es: Español](#como-desplegar-tu-pipeline-de-análisis-usando-aspire) • [:uk: English](#how-to-deploy-your-analysis-pipeline-using-aspire) 
  
</p>


# Como desplegar los análisis de tu proyecto de investigación usando ASPIRE

Bienvenido al tutorial para aprender a desplegar los análisis de tu proyecto de investigación configurado a partir del uso de la librería Common Data Model Builder ('cdmb') usando ASPIRE (Analytic Software Pipeline Interface for Reproducible Execution). 

En primer lugar, echemos un vistazo a la metodología de trabajo seguida en una arquitectura federada. 

```mermaid
---
title: Flujo de trabajo en una arquitectura federada
---
flowchart LR
   question["Research\n Question"]
   cdm["Common\n Data Model"]
   synthetic["Synthetic\n dataset"]
   quality["Quality\nAnalysis\n(scripts)"]
   analysis["Analysis\n(scripts)"]
   usecase["Use Case\n Deployment"]
   outputs["Outputs\n recollection\n & synthesis"]
   deliverable["Use Case\n Deliverable\n production"]
   question --> cdm
   cdm -- Data hubs / \n Domain Experts --> synthetic
   synthetic -- CDM  / \n Availability Survey --> cdm
   synthetic --> quality
   quality -- IT + Epi methods +\n Domain Experts --> analysis
   analysis --> quality
   analysis --> usecase
   usecase --> outputs
   outputs --> deliverable

```

```mermaid
journey
    title Flujo de trabajo en una arquitectura federada
    section Common Data Model Builder (cdmb)
      Common Data Model:20:cdmb
      Synthetic dataset:20: cdmb
      Quality Analysis (scripts): 20: cdmb
      Analysis (scripts): 20: cdmb, aspire
    section Aspire
      Use Case Deployment: 20 : aspire
      Outputs recollection & synthesis: 20 : aspire
      Use Case Deliverable production: 20 : aspire
```

Más información de las herramientas utilizadas:
<p align="left">
<a href="https://github.com/cienciadedatosysalud/aspire"><img width="375" src="https://github-readme-stats-git-masterrstaa-rickstaa.vercel.app/api/pin/?username=cienciadedatosysalud&repo=ASPIRE&theme=react&bg_color=1F222E&title_color=F85D7F&icon_color=F8D866&hide_border=true&show_icons=false" alt="aspire"></a>
<a href="https://github.com/cienciadedatosysalud/cdmb"><img width="430" src="https://github-readme-stats-git-masterrstaa-rickstaa.vercel.app/api/pin/?username=cienciadedatosysalud&repo=cdmb&theme=react&bg_color=1F222E&title_color=F85D7F&icon_color=F8D866&hide_border=true&show_icons=false" alt="cdmb"></a>
</p>

Una vez formulada la pregunta de investigación, completa las siguientes tareas antes de empezar el tutorial:

Tareas:

- [ ] 1. Crear el modelo común de datos usando la librería [cdmb](https://github.com/cienciadedatosysalud/cdmb).
- [ ] 2. Implementar los scripts de análisis en R o Python en la estructura de trabajo que se obtiene del [cdmb](https://github.com/cienciadedatosysalud/cdmb).
- [ ] 3. Realizar el testeo adecuado de los scripts con dato sintético.
- [ ] 4. Seguir este tutorial :blush:

Una vez hayas completado los tres primeros pasos podemos empezar con el tutorial.

# Tutorial

 [Estructura del proyecto](#estructura-del-proyecto) • [Gestión de dependencias](#gestión-de-dependencias) • [Personalización](#personalización) • [Automatización del repositorio](#automatización-del-repositorio) • [Despliegue](#despliegue-del-pipeline-de-análisis) • [Como usar ASPIRE](#como-usar-aspire)

```mermaid
 timeline
    title Despliegue y ejecución de tu proyecto
    Estructura de proyecto : Añadir estructura de trabajo obtenida del cdmb.
                           : Añadir fichero env_project.yaml
                           : Añadir fichero Dockerfile
                           : Añadir fichero .dockerignore
    Gestión de dependencias : Modificar fichero env_project.yaml
                            : Modificar fichero Dockerfile
    Personalización : Añadir logo
                    : Establecer horario en la imagen Docker
    Automatización del repositorio : [GitHub] Añadir directorio .github/workflows
                                   : [GitHub] Añadir acción de GitHub "build_image.yml"
                                   : [GitHub Opcional] Referenciar y citar repositorio
                                   : [GitHub] Crear lanzamiento
                                   : Crear imagen Docker del proyecto
    Despliegue : Build imagen Docker
               : Pull imagen Docker
               : Run imagen Docker
               : [Opcional] Actualizar imagen Docker
               : Visualizar aplicación (ASPIRE)
    Usar ASPIRE : Mapear ficheros de entrada
                : Ejecutar análisis
                : Obtener ficheros de salida
```

## Estructura del proyecto

Para poder empaquetar nuestro pipeline de análisis es necesario partir de una estructura de proyecto estandarizada. En concreto, este tutorial se basa en la integración de la estructura de proyecto del modelo común de datos generada a partir de la utilización de la librería Common Data Model Builder (cdmb) y elementos auxiliares que nos ayudarán a instalar las dependencias necesarias de nuestro código de análisis y el empaquetamiento usando ASPIRE.

Tareas:
- [ ] Añadir el fichero `env_project.yaml`
- [ ] Añadir el fichero `Dockerfile`
- [ ] Añadir el fichero `.dockerignore`


Obteniendo una estructura de proyecto como la siguiente:

![github repo structure](.github/img/github_repository.png)


> [!TIP]
> Puedes utilizar este repositorio como plantilla en el despliegue de tu pipeline de análisis. Para más información, visite [Crear un repositorio desde una plantilla](https://docs.github.com/es/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)

> [!IMPORTANT]  
> Revisa tus ficheros `.gitignore` y `.dockerignore`, asegúrate que no se publica ningún dato sensible utilizado en el desarrollo de los análisis en el repositorio de código ni en la imagen Docker.



## Gestión de dependencias

En este apartado trabajaremos los elementos que se encargan de instalar las dependencias (i.e., paquetes y/o librerías) requeridas por tus análisis.

ASPIRE usa [Micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html) para la gestión de dependencias de librerías y paquetes. Micromamba es una versión ligera y rápida de Mamba, un gestor de paquetes y entornos para Python y otros lenguajes.

La imagen base de ASPIRE (imagen Docker) tiene instalado por defecto el siguiente conjunto de tecnologías/programas (más información, enlace al README con lo instalado).

- Python
- R
- Quarto
- Librerias/paquetes:
<table>
<tr><td>

| Software  | librería/paquete |
| ------------- | ------------- |
| Python  | fastapi  |
| Python  | chardet  |
| Python  | starlette  |
| Python  | urllib3  |
| Python  | uvicorn  |
| Python  | ydata-profiling  |
| Python  | python-multipart  |
| Python  | pandas  |
| Python  | duckdb  |
| &nbsp;  |   |
| &nbsp;  |   |
| &nbsp;  |   |
| &nbsp;  |   |
| &nbsp;  |   |

</td><td>

| Software  | librería/paquete |
| ------------- | ------------- |
| R  | base  |
| R  | knitr  |
| R  | rmarkdown  |
| R  | urllib3  |
| R  | uvicorn  |
| R  | logger  |
| R  | kableextra |
| R  | dbi  |
| R  | dplyr  |
| R  | purrr  |
| R  | remotes  |
| R  | rjson  |
| R  | hmisc  |
| R  | duckdb  |

</td>

</tr> </table>

Todas las dependencias de ASPIRE están instaladas en el entorno (environment) denominado **aspire**. 
Una vez completado el paso anterior es necesario actualizar el entorno **aspire** y añadir las dependencias restantes para poder ejecutar nuestros scripts de análisis. 

Tareas:

- [ ] Modificar el fichero env_project.yaml
- [ ] Modificar el fichero Dockerfile 

> [!TIP]
> Apunta durante el desarrollo del código de análisis todas las librerías/paquetes que has necesitado con sus correspondientes versiones y evita tener en el código declaradas dependencias que no se utilizan.

###  Modificar fichero env_project.yaml

El fichero **env_project.yaml** es un fichero que sigue las especificaciones YAML de Conda.

Los archivos YAML de Conda son archivos que contienen la información necesaria para crear y reproducir un entorno de Conda, como el nombre, los canales, las dependencias y las variables de entorno. 

Los archivos YAML de Conda tienen una estructura simple y legible, donde cada elemento se separa por dos puntos (:) o por guiones (-). 

> [!NOTE]  
> Un canal es una estructura de repositorios independiente y aislada que se utiliza para clasificar y administrar más fácilmente un servidor de paquetes. (más [información](https://mamba.readthedocs.io/en/latest/advanced_usage/more_concepts.html))

Cambia el ejemplo proporcionado por las librerías necesarias para el análisis y disponibles en los canales declarado (channels). Por ejemplo, el siguiente archivo YAML actualiza el entorno llamado aspire usando el canal [conda-forge](https://conda-forge.org/) con pandas versión 2.1.0, el paquete plotly de R versión 4.10.2, etc. 


``` yaml
name: aspire
channels:
 - conda-forge
dependencies:
- r-sf=1.0_14
- r-sjmisc=2.8.9
- r-gt=0.9.0
- r-cowplot=1.1.1
- r-ggalluvial=0.12.5
- r-ggrepel=0.9.3
- r-ggplot2=3.4.2
- r-plotly=4.10.2
- r-htmlwidgets=1.6.2
- pip:
  - ydata-profiling==4.6.0
- pandas==2.1.0
```

### Modificar fichero Dockerfile

En ocasiones, es posible que algún paquete/librería no se encuentre en ninguno de los canales utilizados por Micromamba y se tenga que instalar de forma manual especificandolo dentro del fichero Dockerfile.

Para realizarlo, modifique el fichero Dockerfile y añada el fragmento de código para que se instale la librería en el entorno aspire.

```
micromamba run -n aspire Rscript -e "remotes::install_github('gadenbuie/epoxy')"
```

En este ejemplo, se instala desde GitHub la librería epoxy de R haciendo uso de la librería *remotes*. Ahora el fichero Dockerfile se debería ver de la siguiente manera:

```dockerfile
# Installing dependencies
RUN micromamba install -y -n aspire -f /tmp/env_project.yaml \
    && micromamba run -n aspire Rscript -e "remotes::install_github('gadenbuie/epoxy')" \ 
    && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta /tmp/env_project.yaml
```

> [!NOTE]  
> Un environment o entorno es un conjunto de paquetes y dependencias que se instalan en una ubicación específica y que se pueden activar o desactivar según se necesiten. (más [información](https://mamba.readthedocs.io/en/latest/user_guide/concepts.html))


> [!CAUTION]
> Micromamba es posible que modifique el versionado de algunas librerias respecto a lo especificado para asegurar compatibilidades. Por favor, compruebe en local que todo funciona correctamente (Construcción de la imagen -> Despliegue -> Ejecución del pipeline de análisis).


## Personalización

Tareas: 

- [ ] [Opcional] Añadir el fichero main_logo.png a la estructura de trabajo
- [ ] [Opcional] Modificar el fichero Dockerfile y establecer zona horaria

### Añadir logo

ASPIRE permite cambiar el logo que se muestra en la landing page de la aplicación. Sigue los siguientes pasos para realizarlo de forma correcta:

1- Añade tu logo a la estructura de carpetas
2- Asegúrate que el nombre y formato del fichero cumple con "main_logo.png".
3- Modifica el fichero Dockerfile añadiendo la instrucción que te permite sustituir el logo por defecto por tu logo.

```dockerfile
COPY --chown=$MAMBA_USER:$MAMBA_USER main_logo.png /temp/main_logo.png
RUN cp /temp/main_logo.png $(find front -name main_logo**)
```

> [!IMPORTANT]  
> El logo debe cumplir con el nombre y el formato exigido: **main_logo.png**.

### Establecer horario en la imagen Docker

 Si deseas que la aplicación muestre el horario acorde a tu localización y concuerde la hora de la creación de los ficheros de salida con tu zona horaria, modifica el fichero Dockerfile añadiendo las siguientes lineas de código. 

```dockerfile
# Set time Europe/Madrid

RUN micromamba -n aspire install tzdata -c conda-forge && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN micromamba run -n aspire date
```


<details>

<summary>Fichero Dockerfile base</summary>

``` dockerfile
FROM ghcr.io/cienciadedatosysalud/aspire:latest
ARG pipeline_version="Non-versioned"
ENV PIPELINE_VERSION=$pipeline_version

#########################################################
# Gestión de dependencias: Instalar liberías de sistema #
#########################################################

USER root
RUN apt update && apt install -y --no-install-recommends \
  && apt install -y xdg-utils \
  && rm -rf /var/lib/apt/lists/*

#############################################################
# Personalización: Establecer horario dentro del contenedor #
#############################################################

# Set time Europe/Madrid
RUN micromamba -n aspire install tzdata -c conda-forge && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN micromamba run -n aspire date


#############################################################
# Gestión de dependencias: Instalar dependencias declaradas #
#############################################################

USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER env_project.yaml /tmp/env_project.yaml

# Installing dependencies
RUN micromamba install -y -n aspire -f /tmp/env_project.yaml \
    && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta /tmp/env_project.yaml


#########################################################
# Copiar la estructura de carpetas en la ruta adecuada  #
#########################################################
COPY --chown=$MAMBA_USER:$MAMBA_USER . /home/$MAMBA_USER/projects/your_project

# Cambia el nombre de carpeta 'your_project' por un nombre de carpeta válido que haga referencia a tu proyecto.

################################
# Personalización: Añadir logo #
################################
COPY --chown=$MAMBA_USER:$MAMBA_USER main_logo.png /temp/main_logo.png
RUN cp /temp/main_logo.png $(find front -name main_logo**)

ENV APP_PORT=3000
ENV APP_HOST=0.0.0.0
EXPOSE 3000

WORKDIR /home/$MAMBA_USER

ENTRYPOINT ["micromamba","run","-n","aspire","/opt/entrypoint.sh"]
```

</details>


## Automatización del repositorio

El grupo Ciencia de datos para la investigación en servicios y políticas sanitarias recomienda el uso de repositorios de código para afrontar abordajes federados.
Esta aproximación ayuda a fomentar el trabajo en paralelo y permite a terceros el seguimiento de cambios, el control de versiones, la transparencia en los códigos de análisis y el futuro mantenimiento.

A continuación se muestra como aprovechar algunas caracteristicas que ofrece GitHub como las Acciones de GitHub, que nos permite empaquetar nuestro software de forma automática en cada lanzamiento, y poder referenciar el repositorio del proyecto en plataformas bajo el programa europeo OpenAIRE como Zenodo.

Tareas:

- [ ] [GitHub] Crear directorio `.github/workflows`
- [ ] [GitHub] Crear acción de GitHub `build_image.yml`
- [ ] [GitHub] Aprende a referenciar y citar contenido del repositorio
- [ ] [GitHub] Crea un nuevo lanzamiento (release)

### GitHub Actions

Las Acciones de GitHub facilitan la automatización de tus flujos de trabajo de Software. 
En esta plantilla se proporciona el código de una acción que se encarga de crear la imagen Docker de tu proyecto de forma automatizada usando ASPIRE.

> [!NOTE]  
> Aprende más sobre [GitHub Actions](https://github.com/features/actions).

> [!NOTE]  
> Aprende más sobre [Administrar lanzamientos en un repositorio](https://docs.github.com/es/repositories/releasing-projects-on-github/managing-releases-in-a-repository).

La acción se lanza de forma automática cuando se crea un nuevo lanzamiento (release) en el repositorio. En el fichero `.github/workflows/build_image.yml` se encuentra el flujo de trabajo que crea la imagen Docker con nombre `<account>/<repo>:<tag>` de tu proyecto asignando la etiqueta correspondiente al lanzamiento del repositorio. Esta versión se asigna a la versión del pipeline de análisis.

Código de la acción de GitHub:

<details>
<summary>build_image.yml</summary>

``` yaml
name: Docker Image CI

on:
  push:
    tags:
      - "*.*.*"
  workflow_dispatch:
env:
  # github.repository as <account>/<repo>
  IMAGE_NAME: ${{ github.repository }}
jobs:
  compile:
    name: Build and push the image
    runs-on: ubuntu-latest
    permissions:
        contents: read
        packages: write
        id-token: write # needed for signing the images with GitHub OIDC Token
    steps:
      - name: Get tag name from GITHUB_REF
        run: echo "TAG_NAME=${{ github.ref == '' && 'nonversioned' || github.ref#refs/tags/ }}" >> $GITHUB_ENV
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v2
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - name: Build and push
        uses: docker/build-push-action@v2
        with:
          push: true
          tags: ghcr.io/${{ env.IMAGE_NAME }}:${{env.TAG_NAME}},ghcr.io/${{ env.IMAGE_NAME }}:latest
          file: ./Dockerfile
          build-args: |
            pipeline_version=${{ env.TAG_NAME }}
```

</details>

> [!NOTE]  
> Aprende más sobre el [empaquetado con Acciones de GitHub](https://docs.github.com/es/actions/publishing-packages/about-packaging-with-github-actions).

### Referenciar y citar contenido

GitHub permite utilizar herramientas de terceros para citar y referenciar contenido. 
Si quieres aprender como archivar tu repositorio en Zenodo o Figshare, visite [Referenciar y citar contenido](https://docs.github.com/es/repositories/archiving-a-github-repository/referencing-and-citing-content).


## Despliegue del pipeline de análisis



Tareas:

- [ ] [Opcional] Construir (Build) la imagen Docker
- [ ] Descargar (Pull) imagen de Docker
- [ ] Iniciar (Run) imagen Docker
- [ ] [Opcional] Actualizar imagen Docker
- [ ] Visualizar aplicación (ASPIRE)

### [Opcional] Construir (Build) la imagen Docker

### Descargar (Pull) imagen de Docker

### Iniciar (Run) imagen Docker

### [Opcional] Actualizar imagen Docker

### [Opcional] Actualizar imagen Docker

### Visualizar aplicación (ASPIRE)


## Como usar ASPIRE

Tareas:

- [ ] Mapear ficheros de entrada
- [ ] Ejecutar scripts de análisis
- [ ] Obtener ficheros de salida (outputs)

### Mapear ficheros de entrada

### Ejecutar scripts de análisis

### Obtener ficheros de salida (outputs)

## Referencias


> [!NOTE]  
> Concepto release.

> [!TIP]
> Puedes copiar la estructura de este repositorio y añadir la salida obtenida de la Common Data Model Builder.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.
> 

# How to deploy your analysis pipeline using ASPIRE

[Code repository structure](#code-repository-structure) • [Dependency management](#dependency-management) • [Customization](#customization) • [Deployment](#deployment-of-the-analysis-pipeline) • [How to use ASPIRE](#how-to-use-aspire)

## Code repository structure

## Dependency management

## Customization

## Deployment of the analysis pipeline

## How to use ASPIRE


