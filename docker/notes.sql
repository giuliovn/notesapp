--
-- Database: `Notes`
--

CREATE DATABASE IF NOT EXISTS `Notes`;

-- --------------------------------------------------------

USE Notes;


CREATE TABLE IF NOT EXISTS `Users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE(`user`)
);


CREATE TABLE IF NOT EXISTS `Posts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user` VARCHAR(20) NOT NULL,
  `title` VARCHAR(80) DEFAULT NULL,
  `post` TEXT NOT NULL,
  `time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

show tables;

describe Users;
describe Posts;