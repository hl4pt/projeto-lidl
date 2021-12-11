from artigo import *
from cartao import *
import pandas as pd
import re

cartao = Cartao()
artigo = Artigo()


def regex(regex=None, text=None, campo=None):
    matched = bool(re.match(regex, text))
    if matched is True:
        return True
    else:
        st.warning(f'{campo} é inválido')


def st_artigos():
    # Titulo da Página
    st.title("Lidl - Gestão de Artigos")

    # Opções para gerir artigos
    # Ao escolher uma opção vai carregar uma página diferente
    user = st.selectbox("Gerir...", ("Adicionar Artigo", "Eliminar Artigo",
                                     "Atualizar Stock", "Alterar Preço",
                                     "Listar Artigos"))
    # Página adicionar artigo
    if user == "Adicionar Artigo":

        # User inputs
        col1, col2, col3 = st.columns(3)
        with col1:
            nome_artigo = st.text_input("Nome de artigo")
        with col2:
            preco = st.number_input("Preço do artigo")
        with col3:
            stock = st.number_input("Quantidade - Stock", step=1)

        # Butão "Adicionar Artigo"
        ok_adicionar_artigo = st.button('Adicionar Artigo')

        # Adicionar artigo à base de dados
        if ok_adicionar_artigo:
            artigo.adicionar_artigo(nome=nome_artigo, preco=preco, stock=stock)
            st.success("Registo adicionado com sucesso")
            artigo.listar_artigos_tabela()

    # Página eliminar artigo
    if user == "Eliminar Artigo":
        # criar uma lista com os nomes de todos os artigos com uma list comprehension
        artigos = [i[0] for i in query('listar_artigos_del', [])]

        # user input
        nome_artigo = st.selectbox("Nome de artigo", artigos)

        # butão "Eliminar Artigo"
        ok_elimnar_artigo = st.button('Eliminar Artigo')

        # eliminar o artigo escolhido da base de dados
        if ok_elimnar_artigo:
            try:
                artigo.eliminar_artigo(nome=nome_artigo)
                st.success("Eliminado com sucesso")
                artigo.listar_artigos_tabela()
            except:
                st.error('O artigo não pode ser eliminado.\n'
                        'Este artigo está associado à tabela compras.')

    if user == "Atualizar Stock":
        col1, col2 = st.columns(2)
        with col1:
            # criar uma lista com os nomes de todos os artigos com uma list comprehension
            artigos = [i[0] for i in query('listar_artigos_del', [])]

            # user input
            nome_artigo = st.selectbox("Nome de artigo", artigos)

        with col2:
            # user input
            stock = st.number_input("Quantidade - Stock", step=1)

        # butão "Atualizar Stock"
        ok_atualizar_stock = st.button('Atualizar Stock')

        # atualizar o stock na tabela artigos, usamos o nome de artigo como filtro
        if ok_atualizar_stock:
            artigo.atualizar_stock(nome=nome_artigo, stock=stock)
            st.success("Registo adicionado com sucesso")

        st.caption('Stock Atual')
        artigo.listar_artigos_tabela()


    if user == "Alterar Preço":
        col1, col2 = st.columns(2)
        with col1:
            # criar uma lista com os nomes de todos os artigos com uma list comprehension
            artigos = [i[0] for i in query('listar_artigos_del', [])]

            # user input
            nome_artigo = st.selectbox("Nome de artigo", artigos)
        with col2:
            # user input
            preco = st.number_input("Preço")

        # Atualizar o preço na base de dados usando o nome como filtro
        ok_atualizar_preco = st.button('Atualizar Preço')
        if ok_atualizar_preco:
            artigo.alterar_preço(nome=nome_artigo, preco=preco)
            st.success("Registo adicionado com sucesso")

        st.caption('Preços Atuais')
        artigo.listar_artigos_tabela()


    if user == "Listar Artigos":

        ok_listar_artigos = st.button('Listar Artigos')
        if ok_listar_artigos:
            artigo.listar_artigos_tabela()



def st_cliente():
    st.title("Lidl - Adicionar cliente")

    # user input - nome
    nome_cliente = st.text_input("Nome completo")
    col1, col2 = st.columns(2)
    with col1:
        # user input - nif
        nif_cliente = st.text_input("NIF")
    with col2:
        # user input - telefone
        telefone_cliente = st.text_input("Telefone")

    # user input - email
    email_cliente = st.text_input("Email")

    # user input - morada
    morada_cliente = st.text_input("Morada")

    adicionar_cliente = st.button('Adicionar Cliente')

    # Adicionar novo cliente na base de dados com todos os inputs do utilizador
    if adicionar_cliente:
        matched_nif = regex("^\d{9}$", nif_cliente, 'NIF')
        matched_tel = regex("^\d{9}$", telefone_cliente, 'Telefone')
        matched_email = regex("^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$", email_cliente, 'Email')
        if matched_nif is True and matched_tel is True and matched_email is True:
            cartao.adicionar_cliente(nome=nome_cliente, id_cartao=None,
                                     nif=int(nif_cliente), morada=morada_cliente,
                                     telefone=int(telefone_cliente),
                                     email=email_cliente)
            st.success("Cliente adicionado com sucesso")


def st_cartao():
    st.title("Lidl - Gerir Cartões")

    user = st.selectbox("Gerir...", ("Listar Compras", "Consultar Saldo e Pontos"))

    if user == "Listar Compras":

        # criar uma lista com todos os id_cartao usando uma list comprehension
        id_cartao = [i[0] for i in query('listar_id_cartao', [])]

        # user input
        numero_cartao = st.selectbox("Número do Cartão", id_cartao)

        ok_listar_compras = st.button('Listar Compras')

        # listar as compras do cliente
        if ok_listar_compras:
            # criar um dataframe com pandas
            df = cartao.listar_compras(id_cartao=numero_cartao)
            # listar todas as linhas do dataframe
            pd.set_option("max_rows", None)
            # iterar a coluna valor total e modificar para float
            styler = df.style.format({
                "valor_total": lambda x: float(x)
            })
            # mostrar tabela
            st.table(styler)

    if user == "Consultar Saldo e Pontos":

        # criar uma lista com todos os id_cartao usando uma list comprehension
        id_cartao = [i[0] for i in query('listar_id_cartao', [])]

        # user input
        numero_cartao = st.selectbox("Número do Cartão", id_cartao)

        ok_listar_compras = st.button('Consultar Pontos')
        if ok_listar_compras:
            # criar um dataframe com pandas
            df = cartao.consultar_saldo(id_cartao=numero_cartao)
            # listar todas as linhas do dataframe
            pd.set_option("max_rows", None)
            # iterar a coluna valor total e modificar para float
            styler = df.style.format({
                "saldo": lambda x: float(x)
            })
            # mostrar tabela
            st.table(styler)


def compras():
    st.title("Lidl - Comprar")

    col1, col2 = st.columns(2)
    # user inputs
    with col1:
        id_cartao = [i[0] for i in query('listar_id_cartao', [])]
        id_cartao = st.selectbox("ID Cartão", id_cartao)
    with col2:
        nr_artigos = st.selectbox('Quantidade de Artigos', [i+1 for i in range(20)])

    # session_state é uma forma de guardar dados no streamlit
    # como num dicionario
    if 'key' not in st.session_state:
        st.session_state['key'] = 'value'

    # para nao repetir codigo, criamos um for loop conforme o numero de artigos
    # que o utilizar pretende comprar, depois é guardado no session state
    # para podermos iterar mais tarde
    with st.form("my_form"):
        artigos = [i[1] for i in query('listar_artigos', [])]
        for i in range(nr_artigos):
            with col1:
                artigo = st.selectbox('Artigo', artigos, key=str(i)+'1')
                st.session_state['artigo'+str(i)] = artigo
            with col2:
                quantidade = st.selectbox('Quantidade', [i+1 for i in range(10)], key=str(i)+'2')
                st.session_state['quantidade' + str(i)] = quantidade

        submitted = st.form_submit_button("Comprar")

        # submeter a compra na base de dados
        if submitted:
            # obter o ultimo id_compra e adicionar 1
            id_compra = query('ultima_compra', [])
            with st.spinner('A processar as compras'):
                # iterar todos os session states para obter os dados e registar
                # na base de dados
                for j in range(nr_artigos):
                    cartao.registar_compras(
                        id_compra=id_compra,
                        id_artigo=query('get_art_id', [st.session_state['artigo'+str(j)]]), # procedure para obter o artigo id atraves do nome do artigo - "select id_artigo from artigos where nome = s_nome"
                        id_cartao=id_cartao,
                        quantidade=st.session_state['quantidade'+str(j)])

            st.success('Compra adicionada com sucesso!')
