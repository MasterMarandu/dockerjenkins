FROM jenkins/jenkins:lts

USER root

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get -y install lsb-release apt-transport-https ca-certificates curl gnupg software-properties-common

# Crear directorio para claves GPG
RUN mkdir -p /etc/apt/keyrings

# Descargar clave GPG de Docker y almacenarla en el directorio correcto
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | tee /etc/apt/keyrings/docker.gpg > /dev/null && \
    chmod a+r /etc/apt/keyrings/docker.gpg

# Agregar repositorio oficial de Docker para Debian
RUN echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar lista de paquetes e instalar Docker
RUN apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Instalar Docker Compose manualmente
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Agregar usuario Jenkins al grupo Docker
RUN usermod -aG docker jenkins

USER jenkins



