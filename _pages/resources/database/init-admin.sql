LOCK TABLES `user` WRITE;
INSERT INTO `user` (`name`, `password`, `role`) VALUES ('admin','CHANGE_THIS_PASSWORD','ROLE_ADMIN');
UNLOCK TABLES;