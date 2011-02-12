USE food_stage;

CREATE TABLE IF NOT EXISTS `tmp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `recipe_id` varchar(45) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `recipe_id` (`recipe_id`),
  KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
