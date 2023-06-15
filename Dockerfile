FROM openjdk:17
add ./target/*.jar  myapp.jar
cmd java -jar -Dspring.profiles.active=postgres myapp.jar
EXPOSE 8080