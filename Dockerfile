FROM ghcr.io/cienciadedatosysalud/aspire:latest
ARG pipeline_version="Non-versioned"
ENV PIPELINE_VERSION=$pipeline_version

#########################################################
# Dependency management: Installing system libraries    #
#########################################################

USER root
RUN apt update && apt install -y --no-install-recommends \
  && apt install -y xdg-utils \
  && rm -rf /var/lib/apt/lists/*

#############################################################
# Customization: Set time zone within the container         #
#############################################################

# Set time Europe/Madrid
RUN micromamba -n aspire install tzdata -c conda-forge && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN micromamba run -n aspire date


#############################################################
# Dependency management: Installing declared dependencies   #
#############################################################

USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER env_project.yaml /tmp/env_project.yaml

# Installing dependencies
RUN micromamba install -y -n aspire -f /tmp/env_project.yaml \
    && micromamba clean --all --yes \
    && rm -rf /opt/conda/conda-meta /tmp/env_project.yaml


#########################################################
# Copy the folder structure to the appropriate path     #
#########################################################
COPY --chown=$MAMBA_USER:$MAMBA_USER . /home/$MAMBA_USER/projects/your_project

# Change the folder name 'your_project' to a valid folder name that refers to your project.

################################
# Customization: Add logo      #
################################
COPY --chown=$MAMBA_USER:$MAMBA_USER main_logo.png /temp/main_logo.png
RUN cp /temp/main_logo.png $(find front -name main_logo**)

ENV APP_PORT=3000
ENV APP_HOST=0.0.0.0
EXPOSE 3000

WORKDIR /home/$MAMBA_USER

ENTRYPOINT ["micromamba","run","-n","aspire","/opt/entrypoint.sh"]
