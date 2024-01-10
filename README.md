![Logo of the project](https://cienciadedatosysalud.org/wp-content/uploads/logo-Data-Science-VPM.png)


- [ASPIRE (Analytic Software Pipeline Interface for Reproducible Execution)](#aspire-analytic-software-pipeline-interface-for-reproducible-execution)
  
- [Common Data Model Builder](#authoring)
- [Repositorio Github](#github)
- [Automatización del repositorio](#github-automatization)
    - [GitHub Action](#github-action)
    - [Referenciar y citar contenido](#zenodo)
- [Docker](#docker)
    - [Dockerfile](#dockerfle)
- [Dependencias](#authoring)
    - [Dependencias código de análisis](#authoring)
    - [Dependencias de sistema](#authoring)
- [Personalización](#how-to-contribute)
    - [Logo del proyecto](#how-to-use-the-application)
    - [Uso horario](#how-to-use-the-application)
- [Construcción imagen de docker](#dockerimage)
- [Despliegue y ejecución del Pipeline de análisis](#dockercontainer)
    - [Descarga de la imagen del pipeline](#dockerpull)
    - [ejecución del contenedor](#dockerrun)
        - [Crear y correr el contenedor](#dockerrunform)
        - [Puertos](#dockerports)
        - [Visibilidad](#dockerports)
    - [Actualización](#dockerpull)
- [How to use the application](#how-to-use-the-application)
- [References](#references)


<p align="center">
  
  [:es: Español](#despliega-tu-pipeline-de-analisis-usando-aspire) • [:uk: English](#como-usar-aspire) 
  
</p>


# Despliega tu pipeline de análisis usando ASPIRE

Bienvenido al tutorial para aprender a desplegar tu pipeline de análisis obtenido del uso de la librería Common Data Model Builder usando ASPIRE (Analytic Software Pipeline Interface for Reproducible Execution). 

Más información de las herramientas utilizadas:
<p align="left">
<a href="https://github.com/cienciadedatosysalud/aspire"><img width="375" src="https://github-readme-stats-git-masterrstaa-rickstaa.vercel.app/api/pin/?username=cienciadedatosysalud&repo=ASPIRE&theme=react&bg_color=1F222E&title_color=F85D7F&icon_color=F8D866&hide_border=true&show_icons=false" alt="aspire"></a>
<a href="https://github.com/cienciadedatosysalud/cdmb"><img width="430" src="https://github-readme-stats-git-masterrstaa-rickstaa.vercel.app/api/pin/?username=cienciadedatosysalud&repo=cdmb&theme=react&bg_color=1F222E&title_color=F85D7F&icon_color=F8D866&hide_border=true&show_icons=false" alt="cdmb"></a>
</p>


# Estructura del repositorio de código

Para poder empaquetar nuestro pipeline de análisis es necesario partir de una estructura de proyecto estandarizada que consiste en la estructura de trabajo obtenida de la creación del modelo común de datos utilizando la librería Common Data Model Builder (cdmb) y elementos auxiliares que nos ayudaran a instalar las dependencias necesarias de nuestro código de análisis y el empaquetamiento usando ASPIRE.

Obteniendo una estructura de proyecto como la siguiente:

(imagen de la estructura)


> [!TIP]
> Puedes utilizar este repositorio como plantilla en el despliegue de tu pipeline de análisis. Para más información, visite [Crear un repositorio desde una plantilla](https://docs.github.com/es/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template)

> [!IMPORTANT]  
> Revisa tu fichero .gitignore, asegurate de que no se publica ningún dato sensible utilizado en el desarrollo de los análisis en el respositorio.



## Gestión de dependencias

En el siguiente apartado vamos a hablar de los elementos que se encargan de instalar las dependencias de tu código de análisis.

ASPIRE usa [Micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html) para la gestión de dependencias de librerías y paquetes. Micromamba es una versión ligera y rápida de Mamba, un gestor de paquetes y entornos para Python y otros lenguajes.

La imagen base de ASPIRE tiene por defecto instalado el siguiente paquete de software (más información, enlace al readme con lo instalado).

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

En este punto es necesario actualizar el entorno **aspire** y añadir las dependencias restantes para poder ejecutar nuestros scripts de análisis. 

> [!TIP]
> Apunta durante el desarrollo del código de análisis todas las liberías/paquetes que has necesitado con sus correspondientes versiones y evita tener en el código dependencias que no se utilizan declaradas.

#### Declaración de dependencias: fichero env_project.yaml

El fichero **env_project.yaml** es un fichero que sigue las especificaciones YAML de Conda.

Los archivos YAML de Conda son archivos que contienen la información necesaria para crear y reproducir un entorno de Conda, como el nombre, los canales, las dependencias y las variables de entorno. 

Los archivos YAML de Conda tienen una estructura simple y legible, donde cada elemento se separa por dos puntos (:) o por guiones (-). Por ejemplo, el siguiente archivo YAML crea un entorno llamado myenv con Python 3.9 y las librerías 



> [!NOTE]  
> Un canal es una estructura de repositorios independiente y aislada que se utiliza para clasificar y administrar más fácilmente un servidor de paquetes. (más [información](https://mamba.readthedocs.io/en/latest/advanced_usage/more_concepts.html))

Cambia el ejemplo proporcionado por las librerías necesarias para el análisis y disponibles en los canales declarado (channels). Por ejemplo:

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

<details>

<summary>Dockerfile</summary>

### You can add a header

You can add text within a collapsed section. 

You can add an image or a code block, too.

```dockerfile
   puts "Hello World"
```

</details>



#### Instalación manual: fichero Dockerfile

Es posible que algún paquete/librería no se encuentre en ninguno de los canales utilizados por Micromamba y se tenga que instalar de forma manual dentro del fichero Dockerfile.

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
> micromamba es posible que modifique el versionado de algunas librerias respecto a lo especificado para asegurar compatibilidades. Por favor, compruebe en local que todo funciona correctamente (Construcción de la imagen -> Despliegue -> Ejecución del pipeline de análisis).


## Automatización del repositorio

### GitHub Actions


### Referenciar y citar contenido

https://docs.github.com/es/repositories/archiving-a-github-repository/referencing-and-citing-content

## Despliegue

### Descarga la imagen pipeline
```console
myuser@:~$ whoami
foo
```



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


## Como usar ASPIRE

### Mapear input de entrada

### Ejecutar scripts de análisis

### Obtener outputs



## Referencias
