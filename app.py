from dotenv import load_dotenv
load_dotenv() ## load all the environment variables
import streamlit as st
import os
import psycopg2
import google.generativeai as genai

##configure our API key
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))

#Fuction to load google gemini model and provide sql query as response
def get_gemini_response(question,prompt):
    model=genai.GenerativeModel('gemini-pro')
    response=model.generate_content([prompt[0],question])
    return response.text

## Fucntion To retrieve query from the database

def read_sql_query(sql,db):
    conn = psycopg2.connect(
            host="localhost",        # The host of the database
            dbname=db,   # The name of the database
            user="postgres",    # The database user
            password="2938",    # The user's password
            port="5432"         # The port (default 5432)
        )
    cur=conn.cursor()
    cur.execute(sql)
    rows=cur.fetchall()
    conn.commit()
    conn.close()
    for row in rows:
        print(row)
    return rows

## Define Your Prompt
prompt = [
    """
    You are an expert in converting English questions to SQL queries!
    The SQL database has the following tables:
    - `vehicle`: with columns `vehicle_id`, `make`, `model`, `year`, `vin`.
    - `customer`: with columns `customer_id`, `first_name`, `last_name`, `email`, `phone_number`, `street_address`, `city`, `state`, `zip`.
    - `appointment`: with columns `appointment_id`, `customer_id`, `vehicle_id`, `appointment_date`, `street_address`, `city`, `state`, `zip`.

    Examples:
    Example 1 - "How many vehicles are in the database?" 
    The SQL query will be:
    `SELECT COUNT(*) FROM vehicle;`

    Example 2 - "What are the details of all vehicles made by Toyota?"
    The SQL query will be:
    `SELECT * FROM vehicle WHERE make = 'Toyota';`

    Example 3 - "List all customers from Mumbai"
    The SQL query will be:
    `SELECT * FROM customer WHERE city = 'Mumbai';`

    Example 4 - "Show all appointments for the vehicle with VIN '1NXBR32E28Z174837'"
    The SQL query will be:
    `SELECT * FROM appointment WHERE vehicle_id = (SELECT vehicle_id FROM vehicle WHERE vin = '1NXBR32E28Z174837');`

    Example 5 - "What is the appointment date for customer 'John Doe' with vehicle model 'Corolla'?"
    The SQL query will be:
    `SELECT appointment_date FROM appointment 
    WHERE customer_id = (SELECT customer_id FROM customer WHERE first_name = 'John' AND last_name = 'Doe') 
    AND vehicle_id = (SELECT vehicle_id FROM vehicle WHERE model = 'Corolla');`

    Please note, do not include ``` at the beginning or end of the SQL query, and do not include the word 'SQL' in the output.
    """
]


## Streamlit App

st.set_page_config(page_title="I can Retrieve Any SQL query")
st.header("Gemini App To Retrieve SQL Data")

question=st.text_input("Input: ",key="input")

submit=st.button("Ask the question")

# if submit is clicked
if submit:
    response=get_gemini_response(question,prompt)
    print(response)
    response=read_sql_query(response,"automotive_management_system")
    st.subheader("The Response is")
    for row in response:
        print(row)
        st.header(row)