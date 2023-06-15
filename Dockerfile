FROM openjdk:17
ADD ./target/*.jar  myapp.jar
CMD java -jar -Dspring.profiles.active=postgres myapp.jar
EXPOSE 8080