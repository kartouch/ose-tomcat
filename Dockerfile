FROM registry.access.redhat.com/rhel7                                                                                                                                                  [0/1

RUN yum -y install java-1.8.0-openjdk.x86_64 unzip

ENV CATALINA_HOME /usr/local/tomcat

ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"

RUN curl -k http://apache.miloslavbrada.cz/tomcat/tomcat-8/v8.0.30/bin/apache-tomcat-8.0.30.zip -o /tmp/tomcat-8.0.30.zip && cd /tmp && unzip tomcat-8.0.30.zip && mv apache-tomcat-8.0.30/* $CATALINA_HOME && rm tomcat-8.0.30.zip 

EXPOSE 8080

RUN groupadd tomcat -g 33
RUN useradd tomcat -u 33 -g 33 -G tomcat
RUN echo "tomcat:tomcat" | chpasswd
RUN test "$(id tomcat)" = "uid=33(tomcat) gid=33(tomcat) groups=33(tomcat)"
RUN chmod +x $CATALINA_HOME/bin/catalina.sh

 # Loosen permission bits to avoid problems running container with arbitrary UID
 RUN chown -R tomcat.0 $CATALINA_HOME
 RUN chmod -R g+rwx $CATALINA_HOME

 WORKDIR $CATALINA_HOME

 ENV MONGODB_DATABASE dummy

 ENV MONGODB_USER dummy

 ENV MONGODB_PASSWORD dummy

 ENV OPENSHIFT_MONGODB_DB_URL=mongodb://$MONGODB_USER:$MONGODB_PASSWORD@$MONGODB_SERVICE_HOST:$MONGODB_SERVICE_PORT/

 VOLUME ["/usr/local/tomcat"]

 USER 33

 CMD $CATALINA_HOME/bin/catalina.sh run

