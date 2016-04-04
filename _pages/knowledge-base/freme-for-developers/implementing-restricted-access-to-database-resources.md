---
layout: page
title: Implementing Restricted Access for Database Resources
dropdown: Knowledge Base, FREME for Developers
pos: 4.10
---

# Implementing Restricted Access for Database Resources

This article should serve as guideline how to implement functionality with user restricted access, in particular how to set up secured database entities and functionality to execute CRUD methods via a secured REST api.

## OwnedResource

FREME provides a framework to provide access control to any kind of database entity. A database entity using the FREME access control is an `OwnedResource`. Using this framework you can implement easily the following security rules:
* A database field `visibility` which can be set to `PRIVATE` or `PUBLIC` controls the access control. Further, every OwnedResource has a database field `owner` which points to the user that has created the entity.
* Everyone has read access to `PUBLIC` entities but only the owner has write (update / delete) access.
* Only the owner can read, update or delete `PRIVATE` entities.
* Anonymous users (API requests that do not contain an authentication token) cannot create resources.

**NOTE**: See also the [knowledge-base authentication article](../freme-for-api-users/authentication.html) to have an overview about FREME authentication. The restricted resources mentioned
there implement (partly) the OwnedResource architecture.

FREMECommon provides the entity superclass `OwnedResource` which can be used to ease the implementation of [Spring Data JPA](http://projects.spring.io/spring-data-jpa/) based entities hold by a certain FREME user.
A full implementation of restricted database entities has to contain implementations of the classes:

* OwnedResource: define the entity model
* OwnedResourceRepository: define the interface to the database
* OwnedResourceDAO: define CRUD operations

**NOTE**: Check out the [freme-examples git repository](https://github.com/freme-project/freme-examples), it contains the module [diary](https://github.com/freme-project/freme-examples/tree/master/diary) which provides two well documented working examples of implemented OwnedResources.

Have a look at the [Spring Security Reference Documentation](https://docs.spring.io/spring-security/site/docs/3.0.x/reference/springsecurity.html) if you want to dive deeper into the topic.

## OwnedResource model

Entities inheriting from OwnedResource contain the following fields:

 * `id`: an auto incremented id
 * `creationTime`: a timestamp holding the creation time of the entity object
 * `owner`: the user object which owns the entity object
 * `visibility`: defines the accessibility for FREME users other than the owner. Could be `PRIVATE` (no access) or `PUBLIC` (read access, this is the default).
 * `description`: a short description

Furthermore they have to implement the java interface `Serializable`.

**NOTE**: To let Spring JPA include your entity into the databse schema, your entity class has to belong to the package `eu.freme.common.persistence`.

A simple entity model class could look like this:

```
// Ensure to use this package, otherwise your entities are not integrated into the database schema!
package eu.freme.common.persistence.model

@Entity
//// uncomment this to set a specific table name
// @Table(name = "TABLE_NAME")
public class SimpleEntity extends OwnedResource {

    @Lob
    String someData;

    //// This constructor is needed for spring jpa schema
    //// construction. This occures very early in the Spring
    //// processing, so we call the parent constructor with
    //// a parameter, which makes to set the owner to this value,
    //// "null" in our case. Just calling "super();" would
    //// try to set the current authenticated user as owner,
    //// which does not exist during jpa schema construction.
    public SimpleEntity(){super(null);}

    public SimpleEntity(String data){
       super();
       this.someData = data;
    }

    public String getSomeData(){
       return someData;
    }

    public void setSomeData(String newData){
        this.someData = newData;
    }

    //// uncomment this if you want to use 'name' as object identifier instead of the 'id' field
    // String name;
    //
    // @JsonIgnore
    // @Override
    // public String getIdentifier(){
    //    return getName();
    // }
    //
    // public String getName(){
    //    return name;
    // }
    //
    // public void setName(String newName){
    //    this.name = newName;
    // }

}
```

## OwnedResourceRepository

To enable the database interface via [Spring Data JPA](http://projects.spring.io/spring-data-jpa/) you can implement a class inheriting from `OwnedResourceRepository`.

**NOTE**: Your repository class has to belong to the package `eu.freme.common.persistence` to let Spring JPA notice your repository interface. Otherwise the database accessors are not constructed.

By default, just a getter for entities via the `id` field is initialized. If this satisfies your needs, let the class empty:

```
// Ensure to use this package, otherwise the repository interface will not be scanned by Spring!
package eu.freme.common.persistence.repository;

import eu.freme.common.persistence.model.SimpleEntity;

public interface SimpleEntityRepository extends OwnedResourceRepository<SimpleEntity> {
  //// uncomment this if you want to use 'name' as object identifier instead of the 'id' field
  // SimpleEntity findOneByName(String name);
}
```

## OwnedResource Data Access Object (OwnedResourceDAO)

CRUD operations should be performed via DAO objects inheriting from `OwnedResourceDAO`.

Children of `OwnedResourceDAO` provide the following functionality:

 * `findOneByIdentifier(String identifier)`
 * `findOneByIdentifierUnsecured(String identifier)`
 * `save(Entity entity)`
 * `delete(Entity entity)`
 * `updateOwner(Entity entity, User newOwner)`

Except `findOneByIdentifierUnsecured`, these methods ensure the needed access rights, that is read access for `findOneByIdentifier` and read and write access for the other methods. An `AccessDeniedException` is thrown if the access is permitted. `findOneByIdentifierUnsecured` should be called (only) for identifier collision detection in your REST controller (if you have implemented a specific identifier, see below).

To enable default access restrictions just implement the abstract method `tableName()` according to your entity model class. By default, if you have not especially defined a table name via the `@Table` annotation, this should look like:

```
package eu.freme.common.persistence.dao;

import eu.freme.common.persistence.model.SimpleEntity;
import eu.freme.common.persistence.repository.SimpleEntityRepository;
import org.springframework.stereotype.Component;

@Component
public class SimpleEntityDAO extends OwnedResourceDAO<SimpleEntity> {

public String tableName() {
   //// unless you have not set a specific table name in the model class
   //// via the @Table(name = "TABLE_NAME") annotation
   return SimpleEntity.class.getSimpleName();
}
```

If you have the need for a specific identifier other than the auto incremented `id`, you have to overwrite the method `findOneByIdentifierUnsecured`, which is called by `findOneByIdentifier`. The following code uses the field `name` as entity identifier:

```
@Override
public SimpleEntity findOneByIdentifierUnsecured(String identifier){
   return ((SimpleEntityRepository)repository).findOneByName(identifier);
}
```

Classes inheriting from OwnedResourceDAO also can check the read and write access for an entity directly by calling
`checkReadAccess(Entity entity)` and `checkWriteAccess(Entity entity)`.


## REST controller

If you have implemented the classes above, it is very easy to set up a REST controller to manipulate your entities in a restricted manner. That is, the user credentials encoded in the token send as HTTP header `X-Auth-Token` are used to decide if the current request is permitted.

FREMECommon provides the abstract class `OwnedResourceManagingController`, which enables the following endpoints:

 * `POST /`: add an entity and return the created entity serialized as JSON
 * `GET /`: request all entities, which are accessible, serialized as JSON
 * `GET /{identifier}`: request a certain entity, serialized as JSON
 * `PUT /{identifier}`: update a certain entity and return the updated entity serialized as JSON
 * `DELETE /{identifier}`: delete a certain entity

To get this functionality, you have to create a class inheriting from `OwnedResourceManagingController<Entity>` and implement at least these methods:

 * `Entity createEntity(String body, Map<String, String> parameters, Map<String, String> headers) throws BadRequestException`
 * `void updateEntity(Entity entity, String body, Map<String, String> parameters, Map<String, String> headers) throws BadRequestException`

`createEntity` will be executed when calling `POST /`, `updateEntity` when calling `PUT /{identifier}`.
These methods do not have to handle the modification of `owner` or `visibility`, these fields are set/updated after these methods. To change these properties, the query parameters:

 * `visibility` and
 * `newOwner` (only via `PUT /{identifier}`)

are used. So it is possible to ensure the state of these properties while testing.

Exceptions like `org.springframework.security.access.AccessDeniedException`, `eu.freme.common.exception.BadRequestException`, `org.json.JSONException` and `eu.freme.common.exception.FREMEHttpException` are caught in the methods they can occur in and forwarded as HTTP error responses.

The following code provides the HTTP endpoints (like described above):

 * `POST /mysandbox`
 * `GET /mysandbox`
 * `GET /mysandbox/{identifier}`
 * `PUT /mysandbox/{identifier}`
 * `DELETE /mysandbox/{identifier}`

```

import eu.freme.common.exception.BadRequestException;
import eu.freme.common.persistence.model.SimpleEntity;
import eu.freme.common.rest.OwnedResourceManagingController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import java.util.Map;

@RestController
@RequestMapping("/mysandbox")
public class SimpleEntityController extends OwnedResourceManagingController<SimpleEntity> {
    @Override
    protected SimpleEntity createEntity(String body, Map<String, String> parameters, Map<String, String> headers) throws BadRequestException {
        //// implement body/parameter validation here
        SimpleEntity newEntity = new SimpleEntity(body);
        return newEntity;
    }

    @Override
    protected void updateEntity(SimpleEntity simpleEntity, String body, Map<String, String> parameters, Map<String, String> headers) throws BadRequestException {
        //// implement body/parameter validation here
        simpleEntity.setSomeData(body);
    }
}

```


## Test the REST controller

The class `OwnedResourceManagingHelper` in the package `eu.freme.bservices.testhelper` contains functionality to ease testing of the CRUD methods. The test setting should be similar to the one described in [How to write an e Service](https://github.com/freme-project/freme-parent/wiki/How-to-write-an-e-Service#ecapitalizationservicetestjava-explained).

OwnedResourceManagingHelper includes the following methods:
 * `checkCRUDOperations`: check CRUD (CREATE, READ, UPDATE and DELETE) operations of the controller
 * `createEntity`: sends a request to the controller to create an entity
 * `getEntity`: sends a request to the controller to fetch a certain entity
 * `getAllEntities`: sends a request to the controller to fetch all read accessible entities, for further information, see [knowledge-base authentication article](../freme-for-api-users/authentication.html)
 * `updateEntity`: sends a request to the controller to update a certain entity
 * `deleteEntity`: sends a request to the controller to delete a certain entity

The Following code should work together with the implementations of OwnedResource,
OwnedResourceDAO and OwnedResourceRepository from above.

```
public class SimpleEntityControllerTest {
    private Logger logger = Logger.getLogger(SimpleEntityControllerTest.class);
    private AuthenticatedTestHelper ath;
    private OwnedResourceManagingHelper<SimpleEntity> ormh;
    //// according to the RequestMapping annotation in the SimpleEntityController
    final static String serviceUrl = "/mysandbox";

    //// Initialize the ApplicationContext, helper objects and authenticate the users needed for the tests.
    public SparqlConverterControllerTest() throws  UnirestException {
        //// load the needed modules and create the ApplicationContext
        ApplicationContext context = IntegrationTestSetup.getContext("simple-entity-controller-test-package.xml");
        //// Create the AuthenticatedTestHelper.
        //// It provides tokens for a userWithPermission, a userWithoutPermission and an admin.
        //// There is no difference between the userWithPermission and the userWithoutPermission,
        //// but it is intended to use the first one to create items, so it will be the owner of them,
        //// and check access restrictions with the other.
        ath = context.getBean(AuthenticatedTestHelper.class);
        //// Create a OwnedResourceManagingHelper handling SimpleEntity entities.
        //// All CRUD operations will be send to the management endpoints at serviceUrl ("/mysandbox")
        //// according to the RequestMapping annotation of the SimpleEntityController.
        //// To let the ormh convert the SimpleEntity to json and back to check its content,
        //// the entity class has to be provided as second argument.
        //// Furthermore, it needs the AuthenticatedTestHelper.
        ormh = new OwnedResourceManagingHelper<>(serviceUrl, SimpleEntity.class, ath);
        //// create the tokens for the users described above
        ath.authenticateUsers();
    }

    @Test
    public void testSimpleEntityManagement() throws UnirestException, IOException {
        //// Set up two requests.
        //// SimpleEntityRequests are helper objects of the package eu.freme.bservices.testhelper
        //// containing a string holding the body and lists for parameters and headers.
        //// The createRequest just has the body="data1"
        SimpleEntityRequest createRequest = new SimpleEntityRequest("data1");
        //// The updateRequest just has the body="data2"
        SimpleEntityRequest updateRequest = new SimpleEntityRequest("data2");

        //// Set up a SimpleEntity which has to be contained in the result
        //// of the createRequest.
        SimpleEntity expectedCreatedEntity = new SimpleEntity();
        expectedCreatedEntity.setSomeData("data1");
        //// Set up a SimpleEntity which has to be contained in the result
        //// of the updateRequest .
        SimpleEntity expectedUpdatedEntity = new SimpleEntity();
        expectedUpdatedEntity.setSomeData("data2");

        //// Let the ormh do all CRUD checks. To Check the behaviour when
        //// calling not existing entities, we have to provide an identifier
        //// which must not belong to an entity: "-1".
        ormh.checkCRUDOperations(createRequest , updateRequest, expectedCreatedEntity, expectedUpdatedEntity, "-1");
    }
}

```