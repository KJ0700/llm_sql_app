import psycopg2
from psycopg2 import OperationalError, sql

def create_connection():
    try:
        # Connect to your PostgreSQL database
        connection = psycopg2.connect(
            host="localhost",        # The host of the database
            dbname="automotive_management_system",   # The name of the database
            user="postgres",    # The database user
            password="2938",    # The user's password
            port="5432"         # The port (default 5432)
        )
        print("Connection successful!")
        return connection

    except OperationalError as e:
        print(f"Error: {e}")
        return None


def table_exists(connection, table_name):
    """Check if a table exists in the database."""
    with connection.cursor() as cursor:
        cursor.execute(
            sql.SQL(
                "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = %s);"
            ),
            [table_name]
        )
        return cursor.fetchone()[0]  # Returns True if table exists, False otherwise


def run_sql_file(connection, file_path):
    """Run the SQL commands in the given file."""
    with open(file_path, 'r') as file:
        sql_commands = file.read()

    with connection.cursor() as cursor:
        cursor.execute(sql_commands)
        connection.commit()
        print(f"Executed SQL file: {file_path}")


conn = create_connection()

if conn:
    try:
        # Check if tables exist
        vehicle_exists = table_exists(conn, 'vehicle')
        customer_exists = table_exists(conn, 'customer')
        appointment_exists = table_exists(conn, 'appointment')

        # If any table does not exist, run the SQL file
        if not (vehicle_exists and customer_exists and appointment_exists):
            print("One or more tables do not exist. Running data.sql...")
            run_sql_file(conn, 'data.sql')
        else:
            print("All tables already exist. No need to run data.sql.")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        print("Closing connection...")
        conn.close()
else:
    print("Failed to establish connection.")
