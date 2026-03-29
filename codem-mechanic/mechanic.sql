CREATE TABLE IF NOT EXISTS `codem_mechanic_boss` (
  `name` longtext NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `employees` longtext DEFAULT NULL,
  `permissions` longtext DEFAULT NULL,
  UNIQUE KEY `name` (`name`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;


CREATE TABLE IF NOT EXISTS `codem_mechanic_logs` (
  `name` longtext DEFAULT NULL,
  `message` longtext DEFAULT NULL,
  `date` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;