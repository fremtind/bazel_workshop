# Case 3: Bazel and Spring Boot

Spring Boot executable jars need a different layout than regular Java jars.  
Luckily, we can use [Salesforce rules_spring](https://github.com/salesforce/rules_spring) to create Spring Boot compatible jars in Bazel

We have also split up the application into small modules which can be built separately. This allows for faster builds and better caching because you dont need to rebuild everything. 
Adding the small modules as dependencies to the tests also allows for Bazel to figure out which tests should be executed again when a file changes.
This is functionality which comes in very handy in a large codebase or monorepo with many apps, because it keeps build times low and it will 
easily allow you to figure out which apps are affected by a change (more on this in case 6)


## Things to try out

### Start the application
`bazel run :app` starts the Spring Boot application

### Build the application
`bazel build :app`

### Create a Docker image
`bazel run :tarball` builds an OCI compatible image and loads it into your Docker context.  
Afterwards, you can run the application with `docker run --rm -it -p8080:8080 case3:latest`

## Additional things to try out

#### Run the tests
The controller tests does not depend on all the controllers in the application. 
If you run: 
`bazel test ...`
and then make a change in ProductController.java, only the ContextTest and ProductControllerTest will be re-run. CustomerControllerTest will be cached. 

#### Add a new module with Spring contollers and tests

There is a test in com.example.shoppingcart. Make it pass by adding a new module with a controller and bazel targets
Bonus points if you use the openapi specification from 'case 5' "//workshop/case5:openapi_spring" (Her gir det også mening å flytte case 5 til 3?)
