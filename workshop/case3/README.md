# Case 3: Bazel and Spring Boot

Spring Boot executable jars need a different layout than regular Java jars.  
Luckily, we can use [Salesforce rules_spring](https://github.com/salesforce/rules_spring) to create Spring Boot compatible jars in Bazel

In this case, we also have set up Bazel targets for creating Docker images for our application.

## Things to try out

### Start the application
`bazel run :app` starts the Spring Boot application

### Build the application
`bazel build :app`

### Create a Docker image
`bazel run :tarball` builds an OCI compatible image and loads it into your Docker context.  
Afterwards, you can run the application with `docker run --rm -it -p8080:8080 case3:latest`

## Additional things to try out

The controller tests does not depend on all the controllers in the application. 
If you run: 
`bazel test ...`
and then make a change in ProductController.java, only the ContextTest and ProductControllerTest will be re-run. CustomerControllerTest will be cached. 
