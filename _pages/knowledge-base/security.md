---
layout: page
title: Security aware programming
dropdown: Knowledge Base
pos: 4.10
---

# Security aware programming

This article should serve as guideline how to implement functionality with user restricted access, in particular how to set up database entities and its CRUD methods via an REST api. 

## OwnedResource

FREMECommon provides the entity superclass `OwnedResource` which can be used to ease the implementation of [Spring Data JPA](http://projects.spring.io/spring-data-jpa/) based entities hold by a certain FREME user. 
A full implementation of restricted database entities has to contain implementations of the classes:

* OwnedResource: define the entity model
* OwnedResourceRepository: define the interface to the database
* OwnedResourceDAO: define CRUD operations
   
   
### OwnedResource model

Entities inheriting from OwnedResource contain the following fields:

 * `id`: an auto incrementing id
 * `creationTime`: a timestamp holding the creation time of the entity object
 * `owner`: the user object which owns the entity object
 * `visibility`: defines the accessibility for FREME users other than the owner. Could be `PRIVATE` (no access) or `PUBLIC` (read access, this is the default).
 * `description`: a short description
 
Furthermore they have to implement the java interface `Serializable`.

A simple entity model class could look like this:

```
// Ensure to use this package, otherwise your entities are not integrated into the database schema!
package eu.freme.common.persistence.model

//// if you want to do some manual (de)serialization of complex objects, uncomment this
// import com.fasterxml.jackson.annotation.JsonIgnore;
// import com.fasterxml.jackson.core.JsonProcessingException;
// import com.fasterxml.jackson.databind.ObjectMapper;
// import com.fasterxml.jackson.databind.ObjectWriter;
// import com.fasterxml.jackson.databind.type.TypeFactory;

@Entity
//// uncomment this to set a specific table name
// @Table(name = "TABLE_NAME")
public class SimpleEntity extends OwnedResource {

    @Lob
    String someData;

    public SimpleEntity(){super();}
   
    
    public String getSomeData(){
       return someData;
    }
    
    public void setSomeData(String newData){
        this.someData = newData;
    }
    
    //// uncomment this if you want to use 'name' as object identifier instead of the 'id' field
    // String name;
    //
    // public String getName(){
    //    return name;
    // }
    //    
    // public void setName(String newName){
    //    this.name = newName;
    // }
    
    
    //// using manual deserialization
    // 
    // @JsonIgnore
    // public List<OtherClass> getDeserializedData(){
    //   // do deserialization via Jackson
    //   ObjectMapper mapper = new ObjectMapper();
    //   return mapper.readValue(someData,
    //   				TypeFactory.defaultInstance().constructCollectionType(List.class, OtherClass.class));
    // }
    //
    // @JsonIgnore
    // public void setSerializedData(List<OtherClass> newObjects){
    //   // do serialization via Jackson
    //   ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
    //   someData = ow.writeValueAsString(newObjects);
    // }
    
}
```

### OwnedResourceRepository

To enable the database interface via [Spring Data JPA](http://projects.spring.io/spring-data-jpa/) you can implement a class inheriting from `OwnedResourceRepository`. By default, just a getter for entities via the `id` field is initialized. If this satisfies your needs, let the class empty:

```
// Ensure to use this package, otherwise the repository interface will not be scanned by Spring!
package eu.freme.common.persistence.repository;

import eu.freme.common.persistence.model.SimpleEntity;

public interface SimpleEntityRepository extends OwnedResourceRepository<SimpleEntity> {
  //// uncomment this if you want to use 'name' as object identifier instead of the 'id' field
  // SimpleEntity findOneByName(String name);
}
```

### OwnedResource Data Access Object (OwnedResourceDAO)

CRUD operations should be performed via DAO objects inheriting from `OwnedResourceDAO`.  

Children of `OwnedResourceDAO` provide the following functionality:

 * `findOneByIdentifier(String identifier)`
 * `save(Entity entity)`
 * `delete(Entity entity)`
 * `updateOwner(Entity entity, User newOwner)`
 
All these methods ensure the needed access rights, that is read access for `findOneByIdentifier` and read and write access for the other methods. An `AccessDeniedException` is thrown if the access is permitted.  

To enable default access restrictions just implement the abstract method `tableName()` according to your entity model class. By default, if you have not especially defined a table name via the `@Table` annotation, this should look like:
 
 ```
 // Ensure to use this package, otherwise the repository interface will not be scanned by Spring!
 package eu.freme.common.persistence.dao;
 
 import eu.freme.common.persistence.model.SimpleEntity;
 import eu.freme.common.persistence.repository.SimpleEntityRepository;
 import org.springframework.stereotype.Component;
 
 @Component
 public class SimpleEntityDAO extends OwnedResourceDAO<SimpleEntity> {
 
 public String tableName() {
         return SimpleEntity.class.getSimpleName(); //unless you have not set a specific table name in the model class via the @Table(name = "TABLE_NAME") annotation
     }
 ```
 
 If you have the need for a specific identifier other than the auto incremented `id`, you have to overwrite the method `findOneByIdentifierUnsecured`. The following code uses the field `name` as entity identifier:
 
 ```
 @Override
 public SimpleEntity findOneByIdentifierUnsecured(String identifier){
     return ((SimpleEntityRepository)repository).findOneByName(identifier);
 }
 ```

## REST controller

// TODO

## Test the REST controller

// TODO

## Authentication

// TODO