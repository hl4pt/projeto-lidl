from db_conn import *
import pandas as pd
from datetime import datetime
import streamlit as st

class Cartao:

        def adicionar_cliente(self, nome, id_cartao, nif, morada, telefone, email):
            # registar um novo cliente na base de dados
            values = [nome, id_cartao, nif, morada, telefone, email]
            query('adicionar_cliente', values)

            # consultar o id do novo cliente
            id_cliente = query('consultar_id_cliente', [])

            # inserir na tabela cartao o cliente id
            # fazer update da tabela clientes para adicionar o id_cartao
            self.atribuir_cartao(id_cliente=id_cliente)

        def atribuir_cartao(self, id_cliente):
            # atribuir e adicionar um novo cartao ao cliente
            values = [id_cliente, 0, 0]
            query('atribuir_cartao', values)

        def registar_compras(self, id_compra, id_artigo, id_cartao, quantidade):
            # calcular o valor_total
            preco_artigo = query('consultar_artigo_preco', [id_artigo])
            valor_total = quantidade * preco_artigo[0][0]

            # verificar se existe stock suficiente
            verificar_stock_suficiente = query('verificar_stock_suficiente', [id_artigo])
            if quantidade > verificar_stock_suficiente[0][0]:
                st.warning('A quantidade escolhida ultrapassa o stock atual')

            else:
                # actualizar o stock
                value_atualizar = [quantidade, id_artigo]
                query('atualizar_stock_apos_compra', value_atualizar)

                # registar o registo de compra na tabela compras
                time = datetime.now()
                values = [id_compra, id_artigo, id_cartao, quantidade, valor_total, time]
                query('registar_compras', values)

                # actualizar os pontos e saldo quando o cliente faz uma compra
                self.cumulativo_pontos(id_cartao)
                self.cumulativo_saldo(id_cartao)

        def listar_compras(self, id_cartao):
            result = query('listar_compras', [id_cartao])
            columns = ['id', 'id_compra', 'id_artigo', 'id_cartao', 'quantidade', 'valor_total', 'Data']
            df = pd.DataFrame(result, columns=columns)

            return df

        def consultar_saldo(self, id_cartao):
            result = query('consultar_saldo', [id_cartao])
            columns = ['saldo', 'pontos']
            df = pd.DataFrame(result, columns=columns)

            return df

        def cumulativo_saldo(self, id_cartao):
            values = [id_cartao]
            query('cumulativo_saldo', values)

        def cumulativo_pontos(self, id_cartao):
            # query para obter os pontos por id_cartao
            values = [id_cartao]
            result = query('cumulativo_pontos', values)
            id, valor_total = result[0][0], result[0][1]

            # calcular pontos
            verificar = int(valor_total / 50)
            pontos_total = verificar * 3

            values = [id_cartao, pontos_total]
            query('calcular_pontos', values)
