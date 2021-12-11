from db_conn import *
import pandas as pd
import streamlit as st

class Artigo:

    def adicionar_artigo(self, nome=None, preco=None, stock=None):
        values = [nome, preco, stock]
        query('adicionar_artigo', values)

    def eliminar_artigo(self, nome):
        values = [nome]
        query('eliminar_artigo', values)

    def atualizar_stock(self, stock, nome):
        # manualmente
        values = [stock, nome]
        query('atualizar_stock', values)

    def alterar_preço(self, preco, nome):
        values = [preco, nome]
        query('alterar_preço', values)

    def listar_artigos(self, size=10):
        result = query('listar_artigos', [])
        columns = ['id', 'nome', 'preço', 'stock']
        df = pd.DataFrame(result, columns=columns)

        return df

    def listar_artigos_tabela(self):
        df = self.listar_artigos()
        pd.set_option("max_rows", None)
        styler = df.style.format({
            "preço": lambda x: float(x)
        })

        st.table(styler)
