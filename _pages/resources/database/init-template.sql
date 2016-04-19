
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

LOCK TABLES `template` WRITE;
/*!40000 ALTER TABLE `template` DISABLE KEYS */;
INSERT INTO `template` (`visibility`, `owner_name`, `description`, `endpoint`, `label`, `query`, `endpoint_type`, `creation_time`)
VALUES 
(1,'admin','This template enriches with a list of museums (max 10) within a 50km radius around each location entity.','http://live.dbpedia.org/sparql/','Find nearest museums','PREFIX dbpedia: <http://dbpedia.org/resource/> PREFIX dbo: <http://dbpedia.org/ontology/> PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> CONSTRUCT {  ?museum <http://xmlns.com/foaf/0.1/based_near> <@@@entity_uri@@@> . } WHERE {  <@@@entity_uri@@@> geo:geometry ?citygeo .  OPTIONAL { ?museum rdf:type dbo:Museum . }  ?museum geo:geometry ?museumgeo .  FILTER (<bif:st_intersects>(?museumgeo, ?citygeo, 50)) } LIMIT 10',0,0),
(1,'admin','The template retrieves events (max 10) related to a place. The information is retrieved from the DBpedia live SPARQL endpoint.','http://live.dbpedia.org/sparql','Events related to a place','PREFIX dbpedia: <http://dbpedia.org/resource/> PREFIX dbpedia-owl: <http://dbpedia.org/ontology/> PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> CONSTRUCT { ?event <http://dbpedia.org/ontology/place> <@@@entity_uri@@@> . } WHERE { ?event rdf:type <http://dbpedia.org/ontology/Event> .  ?event <http://dbpedia.org/ontology/place> <@@@entity_uri@@@> .  } LIMIT 10',0,0),
(1,'admin','','http://factforge.net/sparql','dataset label','PREFIX geo-pos: <http://www.w3.org/2003/01/geo/wgs84_pos#> CONSTRUCT { <@@@entity_uri@@@> geo-pos:lat ?lat . <@@@entity_uri@@@> geo-pos:long ?long . } WHERE { <@@@entity_uri@@@> geo-pos:lat ?lat . <@@@entity_uri@@@> geo-pos:long ?long . }',0,0),
(1,'admin','This template enriches with a list of persons (max 10) born in locations provided in the text. This template is using Europeana SPARQL endpoint as source for information.','http://europeana.ontotext.com/sparql','Authors born in place','PREFIX edm: <http://www.europeana.eu/schemas/edm/> PREFIX ore: <http://www.openarchives.org/ore/terms/> CONSTRUCT {  ?person  <http://rdvocab.info/ElementsGr2/placeOfBirth> <@@@entity_uri@@@> ;  } WHERE {  ?person  <http://rdvocab.info/ElementsGr2/placeOfBirth> <@@@entity_uri@@@> ;  } LIMIT 10',0,0),
(1,'admin','','http://europeana.ontotext.com/sparql','','PREFIX dbpedia: <http://dbpedia.org/resource/> PREFIX dbpedia-owl: <http://dbpedia.org/ontology/> PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> CONSTRUCT { ?event <http://dbpedia.org/ontology/place> <@@@entity_uri@@@> . } WHERE { ?event rdf:type <http://dbpedia.org/ontology/@@@event_type@@@> .  ?event <http://dbpedia.org/ontology/place> <@@@entity_uri@@@> .  } LIMIT 10',0,0),
(1,'admin','This template retrieves bakeries near a place within radius of 10 km. The places should be identified with DBpedia or GeoNames URIs.','http://linkedgeodata.org/sparql/','Bakeries near a place','Prefix lgdo: <http://linkedgeodata.org/ontology/> Prefix geom: <http://geovocab.org/geometry#> Prefix ogc: <http://www.opengis.net/ont/geosparql#> Prefix owl: <http://www.w3.org/2002/07/owl#> CONSTRUCT {  ?b <http://xmlns.com/foaf/0.1/based_near> <@@@entity_uri@@@> .  ?b <http://www.w3.org/2000/01/rdf-schema#label> ?label . } WHERE {  ?c    owl:sameAs <@@@entity_uri@@@> ;    geom:geometry [      ogc:asWKT ?cg    ] .  ?b    a lgdo:Bakery ;    <http://www.w3.org/2000/01/rdf-schema#label> ?label ;        geom:geometry [      ogc:asWKT ?bg    ] .    Filter(<bif:st_intersects>(?cg, ?bg, 10)) .} Limit 10',0,0),
(1,'admin','This template is using a Linked Data Frament endpoint to fetch DBpedia categories for a DBpedia resource.','http://rv2622.1blu.de:5000/dbpedia-categories','DBpedia Categories via LDF','CONSTRUCT {  <@@@entity_uri@@@> <http://purl.org/dc/terms/subject> ?category .  ?category <http://www.w3.org/2000/01/rdf-schema#label> ?label } WHERE { <@@@entity_uri@@@> <http://purl.org/dc/terms/subject> ?category . ?category <http://www.w3.org/2000/01/rdf-schema#label> ?label }',1,1446716795534),
(1,'admin','Retrieve all bakeries 10km close to a place.','http://linkedgeodata.org/vsnorql','Linked Geo Data','  PREFIX owl: <http://www.w3.org/2002/07/owl# >	PREFIX ogc: <http://www.opengis.net/ont/geosparql# >	PREFIX geom: <http://geovocab.org/geometry# >	PREFIX lgdo: <http://linkedgeodata.org/ontology/ >	CONSTRUCT {	?s <http://xmlns.com/foaf/0.1/based_near > <@@@entity_uri@@@ > .	} WHERE {	?s	a lgdo:Bakery ;	geom:geometry [ ogc:asWKT ?sg ] .	?a	owl:sameAs <@@@entity_uri@@@ > ;	geom:geometry [ ogc:asWKT ?ag ] .	FILTER(bif:st_intersects(?sg, ?ag, 10))	} LIMIT 10 ',0,1447063868052),
/*!40000 ALTER TABLE `template` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

