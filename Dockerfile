FROM openshift/base-centos7

MAINTAINER Tobias Brunner <tobias.brunner@vshn.ch> 
#Modified by Chris Duffield <cnduffield@hotmail.com>

ENV GRADLE_VERSION=5.6.2

# Docker Image Metadata
LABEL io.k8s.description="Platform for building (Gradle) and running plain Java applications" \
      io.k8s.display-name="Java Applications" \
      io.openshift.tags="builder,java,gradle" \
      io.openshift.expose-services="8080" \
      org.jboss.deployments-dir="/deployments"

# Install Java
#RUN INSTALL_PKGS="java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
RUN INSTALL_PKGS="java-11-openjdk java-11-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/s2i/destination

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip && \
    rm gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle/gradle-${GRADLE_VERSION}/bin/gradle /usr/local/bin/gradle

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# S2I scripts
COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root
USER 1001

EXPOSE 8080


CMD ["/usr/libexec/s2i/usage"]
