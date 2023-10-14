# FROM arm64v8/maven
FROM gradle:8-jdk8 AS builder

WORKDIR /app/ElectronMS

COPY build.gradle settings.gradle gradle ./
# COPY gradle .
RUN gradle build || return 0 
COPY . .
RUN gradle shadowJar
RUN cp /app/ElectronMS/build/libs/ElectronMS-1.0-all.jar /app/ElectronMS/ElectronMS-1.0-all.jar
ENTRYPOINT [ "java","-jar","/app/ElectronMS/ElectronMS-1.0-all.jar" ]

FROM openjdk:8-jre as prod
WORKDIR /app/ElectronMS

COPY --from=builder /app/ElectronMS/build/libs/ElectronMS-1.0-all.jar . 

ENTRYPOINT [ "java","-jar","ElectronMS-1.0-all.jar" ]