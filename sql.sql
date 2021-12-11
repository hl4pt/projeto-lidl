DELIMITER $$

CREATE PROCEDURE adicionar_artigo(
        IN s_nome VARCHAR(50),
        IN s_preco FLOAT,
        IN s_stock INT
)
BEGIN
    INSERT INTO artigos (nome, preco, stock)
    VALUES (s_descricao, s_preco, s_stock);
end $$


#############

DELIMITER $$

CREATE PROCEDURE eliminar_artigo(
        IN s_nome VARCHAR(50)
)
BEGIN
    DELETE FROM artigos WHERE nome = s_nome;
end $$


############

DELIMITER $$

CREATE PROCEDURE atualizar_stock(
        IN s_stock INT,
        IN s_nome VARCHAR(50)
)
BEGIN
    UPDATE artigos SET stock = s_stock WHERE nome = s_nome;
end $$


############

DELIMITER $$

CREATE PROCEDURE atualizar_stock_apos_compra(
        IN s_stock INT,
        IN s_nome VARCHAR(50)
)
BEGIN
    UPDATE artigos SET stock = stock - s_stock WHERE nome = s_nome;
end $$


#####################

DELIMITER $$

CREATE PROCEDURE listar_artigos()
BEGIN
    SELECT * FROM artigos;
end $$

#####################

DELIMITER $$

CREATE PROCEDURE alterar_preco(
        IN s_preco FLOAT,
        IN s_nome VARCHAR(50)
)
BEGIN
    UPDATE artigos SET preco = s_preco WHERE nome = s_nome;
end $$

#####################

DELIMITER $$

CREATE PROCEDURE adicionar_cliente(
    IN s_nome varchar(50),
    IN s_id_cartao int, IN s_nif int,
    IN s_morada varchar(50),
    IN s_telefone int,
    IN s_email varchar(50))

BEGIN
    INSERT INTO clientes (nome_cliente, id_cartao, nif, morada, telefone, email)
    VALUES (s_nome, s_id_cartao, s_nif, s_morada, s_telefone, s_email);
end;


########

DELIMITER $$

CREATE PROCEDURE atribuir_cartao(
        IN s_id_cliente INT,
        IN s_saldo FLOAT,
        IN s_id_compra INT,
        IN s_pontos INT
)
BEGIN
    INSERT INTO cartao (id_cliente, saldo, id_compra, pontos)
    VALUES (s_id_cliente, s_saldo, s_id_compra, s_pontos);
end $$


################

DELIMITER $$

CREATE PROCEDURE registar_compras(
        IN s_id_artigo INT,
        IN s_descricao FLOAT,
        IN s_quantidade INT,
        IN s_valor_total INT
)
BEGIN
    INSERT INTO compras (id_artigo, descriçao, quantidade, valor_total)
    VALUES (s_id_artigo, s_descricao, s_quantidade, s_valor_total);
end $$


##############

DELIMITER $$

CREATE PROCEDURE listar_compras()
BEGIN
    SELECT * FROM compras;
end $$


######################


DELIMITER $$

CREATE PROCEDURE consultar_saldo(
        IN s_id_cartao INT
)
BEGIN
    SELECT saldo FROM cartao WHERE id_cartao = s_id_cartao;
end $$


#####################

DELIMITER $$

CREATE PROCEDURE alterar_pontos(
        IN s_id_cartao INT,
        IN s_pontos INT
)
BEGIN
    UPDATE cartao SET pontos = s_pontos WHERE id_cartao = s_id_cartao;
end $$