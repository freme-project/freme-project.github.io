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

/*!40000 ALTER TABLE `sparqlconverter` DISABLE KEYS */;
INSERT INTO `sparqlconverter` (`creation_time`, `visibility`, `name`, `owner_name`, `query`, `description`)
VALUES 
(0,1,'extract-entities-only','admin','PREFIX itsrdf: <http://www.w3.org/2005/11/its/rdf#> SELECT ?entity WHERE {?charsequence itsrdf:taIdentRef ?entity}',NULL),
(0,1,'terminology-terms-only','admin','PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\r\nselect  (lang(?anchorOf) as ?language) (str(?anchorOf) as ?anchor) ?confidence (GROUP_CONCAT(DISTINCT ?label;SEPARATOR = \", \") AS ?new_label) (GROUP_CONCAT(DISTINCT ?uri;SEPARATOR = \", \") AS ?new_uri) where {\r\n ?term <http://www.w3.org/2005/11/its/rdf#term> \"yes\".\r\n ?term <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#annotationUnit> ?annotationUnit .\r\n  ?term <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#anchorOf> ?anchorOf.\r\n ?annotationUnit rdfs:label ?label.\r\n ?annotationUnit <http://www.w3.org/2005/11/its/rdf#taConfidence> ?confidence.\r\n ?term <http://www.w3.org/2005/11/its/rdf#termInfoRef> ?uri\r\n}\r\ngroup by  ?annotationUnit ?confidence ?anchorOf ORDER by desc ( ?confidence )',NULL),
(0,1,'sourcelang-targetlang','admin','PREFIX nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> PREFIX its: <http://www.w3.org/2005/11/its/rdf#> PREFIX ontolex: <http://www.w3.org/ns/lemon/ontolex#> PREFIX skos: <http://www.w3.org/2004/02/skos/core#> PREFIX itsrdf: <http://www.w3.org/2005/11/its/rdf#> PREFIX tbx: <http://tbx2rdf.lider-project.eu/tbx#> SELECT    ?annotationString ?concept ?writtenRep (lang(?writtenRep) as ?language) WHERE {   ?annotationString a nif:RFC5147String.   ?annotationString its:termInfoRef ?concept.   ?concept tbx:definition ?definition.   ?concept a skos:Concept.   ?sense ontolex:reference ?concept.   ?entry ontolex:sense ?sense.   ?entry ontolex:canonicalForm ?canonicalForm.   ?canonicalForm ontolex:writtenRep ?writtenRep. }',NULL),
(0,1,'original-and-translation','admin','SELECT ?source ?target \nWHERE {  ?s <http://www.w3.org/2005/11/its/rdf#target> ?target.  ?s <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#isString> ?source.}',NULL),
(0,1,'entities-detailed-info','admin','PREFIX itsrdf: <http://www.w3.org/2005/11/its/rdf#> prefix nif:  <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> SELECT ?uri ?ident ?class ?string ?charbegin ?charend WHERE {?uri itsrdf:taIdentRef ?ident. ?uri itsrdf:taClassRef ?class. ?uri nif:anchorOf ?string. ?uri nif:beginIndex ?charbegin. ?uri nif:endIndex ?charend.}',NULL),
(0,1,'place-and-lat-long','admin','PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> SELECT ?place ?lat ?long WHERE {  ?place <http://www.w3.org/2003/01/geo/wgs84_pos#lat> ?lat.  ?place <http://www.w3.org/2003/01/geo/wgs84_pos#long> ?long.  sparqlconverter (datatype(?lat) = xsd:double)  sparqlconverter (datatype(?long) = xsd:double)}',NULL),
(0,1,'museums-nearby','admin','SELECT ?place ?museum WHERE {  ?museum <http://xmlns.com/foaf/0.1/based_near> ?place.} ORDER by ?place',NULL),
(0,1,'freme-workflow-editor-terminology','admin','\nPREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\nselect  (lang(?anchorOf) as ?language) (str(?anchorOf) as ?anchor) (SAMPLE(?bIndex) as ?beginIndex) (SAMPLE(?eIndex) as ?endIndex) ?confidence (GROUP_CONCAT(DISTINCT ?label;SEPARATOR = \", \") AS ?new_label) (GROUP_CONCAT(DISTINCT ?uri;SEPARATOR = \", \") AS ?new_uri) where {\n ?term <http://www.w3.org/2005/11/its/rdf#term> \"yes\".\n ?term <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#annotationUnit> ?annotationUnit .\n  ?term <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#anchorOf> ?anchorOf.   \n  ?term <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#beginIndex> ?bIndex.    \n  ?term <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#endIndex> ?eIndex.\n ?annotationUnit rdfs:label ?label.\n ?annotationUnit <http://www.w3.org/2005/11/its/rdf#taConfidence> ?confidence.\n ?term <http://www.w3.org/2005/11/its/rdf#termInfoRef> ?uri\n}\ngroup by  ?annotationUnit ?confidence ?anchorOf ORDER by desc ( ?confidence )',NULL);
/*!40000 ALTER TABLE `sparqlconverter` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
