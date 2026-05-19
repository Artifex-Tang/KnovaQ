-- docker/init/equipment_iqas.sql
-- Runs automatically on first MySQL container boot (data dir empty).
-- Replace this file with the actual gaisoft-mes DB dump before deployment.

CREATE DATABASE IF NOT EXISTS `equipment_iqas`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `equipment_iqas`;

-- TODO: paste full schema + seed data here
-- Source: gaisoft-mes team / DB admin
