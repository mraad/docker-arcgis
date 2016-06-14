FROM centos:latest

MAINTAINER @mraad <mraad@esri.com>

RUN yum -y --nogpg install xorg-x11-server-Xvfb.x86_64 fontconfig freetype gettext less htop vim \
             mesa-libGLU libXtst libXi libXrender

RUN mkdir /arcgis
ADD Server_Ent_Adv.prvc /arcgis/
ADD ArcGIS_for_Server_Linux_104_149446.tar.gz /arcgis/

ENV USER arcgis
ENV GROUP arcgis

RUN groupadd $GROUP
RUN useradd -m -r $USER -g $GROUP

RUN mkdir -p /arcgis/server
RUN chown -R $USER:$GROUP /arcgis
RUN chmod -R 755 /arcgis

EXPOSE 6080 6443 4001 4002 4004

USER $USER

RUN /arcgis/ArcGISServer/Setup -m silent -l yes -a /arcgis/Server_Ent_Adv.prvc -d /

ENTRYPOINT /arcgis/server/startserver.sh && /bin/bash
