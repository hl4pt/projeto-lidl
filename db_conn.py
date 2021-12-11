import streamlit
from sqlalchemy import create_engine


def db_connection():
    engine = create_engine(streamlit.secrets['db'])

    return engine


def query(prod=None, values=None):
    engine = db_connection()
    connection = engine.raw_connection()
    cursor = connection.cursor()
    cursor.callproc(prod, values)
    results = list(cursor.fetchall())
    connection.commit()
    connection.close()

    return results


