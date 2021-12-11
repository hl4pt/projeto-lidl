CREATE TABLE `artigos` (
  `id_artigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) DEFAULT NULL,
  `preco` decimal(10,2) NOT NULL,
  `stock` int NOT NULL,
  PRIMARY KEY (`id_artigo`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='		';
CREATE TABLE `cartao` (
  `id_cartao` int NOT NULL AUTO_INCREMENT,
  `id_cliente` int DEFAULT NULL,
  `saldo` decimal(10,2) DEFAULT NULL,
  `pontos` int DEFAULT NULL,
  PRIMARY KEY (`id_cartao`),
  KEY `test_idx` (`id_cliente`),
  CONSTRAINT `cartao_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nome_cliente` varchar(50) NOT NULL,
  `id_cartao` int DEFAULT NULL,
  `nif` int NOT NULL,
  `morada` varchar(50) DEFAULT NULL,
  `telefone` int NOT NULL,
  `email` varchar(45) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  KEY `clientes_ibfk_1` (`id_cartao`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`id_cartao`) REFERENCES `cartao` (`id_cartao`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='					';
CREATE TABLE `compras` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_compra` int NOT NULL,
  `id_artigo` int DEFAULT NULL,
  `id_cartao` int DEFAULT NULL,
  `quantidade` int NOT NULL,
  `valor_total` decimal(10,2) DEFAULT NULL,
  `datac` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_artigo` (`id_artigo`),
  CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`id_artigo`) REFERENCES `artigos` (`id_artigo`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `adicionar_artigo`(
        IN s_descricao VARCHAR(50),
        IN s_preco FLOAT,
        IN s_stock INT
)
BEGIN
    INSERT INTO artigos (nome, preco, stock)
    VALUES (s_descricao, s_preco, s_stock);
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `adicionar_cliente`(
        IN s_nome VARCHAR(50),
        IN s_id_cartao INT,
        IN s_nif INT,
        IN s_morada VARCHAR(50),
        IN s_telefone INT,
        IN s_email VARCHAR(50)
)
BEGIN
    INSERT INTO clientes (nome_cliente, id_cartao, nif, morada, telefone, email)
    VALUES (s_nome, s_id_cartao, s_nif, s_morada, s_telefone, s_email);
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `adicionar_pontos`(
        IN s_id_cartao INT,
        IN s_pontos INT
)
BEGIN
    UPDATE cartao SET pontos = pontos + s_pontos WHERE id_cartao = s_id_cartao;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `alterar_pontos`(
        IN s_id_cartao INT,
        IN s_pontos INT
)
BEGIN
    UPDATE cartao SET pontos = s_pontos WHERE id_cartao = s_id_cartao;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `alterar_preço`(
        IN s_preco decimal(10,2),
        IN s_nome VARCHAR(50)
)
BEGIN
    UPDATE artigos SET preco = s_preco WHERE nome = s_nome;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `atribuir_cartao`(
        IN s_id_cliente INT,
        IN s_saldo FLOAT,
        IN s_pontos INT
)
BEGIN
    INSERT INTO cartao (id_cliente, saldo, pontos)
    VALUES (s_id_cliente, s_saldo, s_pontos);
    update clientes set id_cartao = (select max(id_cartao) from cartao) where id_cliente=s_id_cliente; 
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `atualizar_stock`(
        IN s_stock INT,
        IN s_nome VARCHAR(50)
)
BEGIN
    UPDATE artigos SET stock = s_stock WHERE nome = s_nome;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `atualizar_stock_apos_compra`(
        IN s_stock INT,
        IN s_id int
)
BEGIN
    UPDATE artigos SET stock = stock - s_stock WHERE id_artigo = s_id;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `calcular_pontos`(
        IN s_id_cartao INT,
        IN s_pontos INT
)
BEGIN
    UPDATE cartao SET pontos = s_pontos WHERE id_cartao = s_id_cartao;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `consultar_artigo_preco`(
    IN s_id_artigo INT
)
BEGIN
    SELECT preco FROM artigos WHERE id_artigo = s_id_artigo;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `consultar_id_cliente`()
BEGIN
    SELECT MAX(id_cliente) AS id_cliente FROM clientes;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `consultar_saldo`(
        IN s_id_cartao INT
)
BEGIN
    SELECT saldo,pontos FROM cartao WHERE id_cartao = s_id_cartao;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `cumulativo_pontos`(
        IN s_id_cartao INT
)
BEGIN
    SELECT id_cartao, SUM(valor_total) AS valor_total FROM compras where id_cartao = s_id_cartao GROUP BY id_cartao;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `cumulativo_saldo`(
        IN s_id_cartao INT
)
BEGIN
	update cartao set saldo = (SELECT SUM(valor_total) AS valor_total FROM compras where id_cartao = s_id_cartao GROUP BY id_cartao) where id_cartao = s_id_cartao;
    
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `eliminar_artigo`(
        IN s_nome VARCHAR(50)
)
BEGIN
    DELETE FROM artigos WHERE nome = s_nome;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `get_art_id`(
in s_nome text
)
BEGIN
	select id_artigo from artigos where nome = s_nome;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `listar_artigos`()
BEGIN
    SELECT * FROM artigos;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `listar_artigos_del`()
BEGIN
 SELECT nome FROM artigos;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `listar_clientes`()
BEGIN
	SELECT *  FROM clientes;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `listar_compras`(
in s_id_cartao int
)
BEGIN
    SELECT * FROM compras where id_cartao = s_id_cartao;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `listar_id_cartao`()
BEGIN
select id_cartao from cartao;
END$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `registar_compras`(
    IN s_id_compra int,
    IN s_id_artigo int,
    IN s_id_cartao int,
    IN s_quantidade int,
    IN s_valor_total decimal(10, 2),
    IN s_time timestamp)
BEGIN
    INSERT INTO compras (id_compra, id_artigo, id_cartao, quantidade, valor_total, datac)
    VALUES (s_id_compra, s_id_artigo, s_id_cartao, s_quantidade, s_valor_total,s_time);
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `ultima_compra`()
BEGIN
    SELECT MAX(id_compra) + 1 FROM compras;
end$$
DELIMITER ;
DELIMITER $$
CREATE DEFINER=`admin`@`%` PROCEDURE `verificar_stock_suficiente`(
    IN s_id_artigo INT
)
BEGIN
    SELECT stock FROM artigos WHERE id_artigo = s_id_artigo;
end$$
DELIMITER ;
