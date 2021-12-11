from app import *

paginas = st.sidebar.selectbox("Página",
                               ("Gestão de Artigos",
                                "Adicionar Cliente",
                                "Gestão do Cartão",
                                "Compras"))

logo = st.image('lidl.png', width=100)

if paginas == "Gestão de Artigos":
    st_artigos()

if paginas == "Adicionar Cliente":
    st_cliente()

if paginas == "Gestão do Cartão":
    st_cartao()

if paginas == "Compras":
    compras()