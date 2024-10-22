import duckdb
import os

# Connect to the DuckDB database
conn = duckdb.connect('./warehouse.duckdb')

# Define the schemas to export
schemas = ['bronze', 'silver', 'gold', 'platinum']

# Iterate through the schemas
for schema in schemas:
    # Get all tables in the schema
    tables = conn.execute(f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{schema}'").fetchall()

    # Create a directory for the schema
    schema_dir = os.path.join('exports', schema)
    os.makedirs(schema_dir, exist_ok=True)

    # Export each table as parquet with zstd compression
    for table in tables:
        table_name = table[0]
        output_path = os.path.join(schema_dir, f"{schema}.{table_name}.parquet")
        
        print(f"Exporting {schema}.{table_name} to {output_path}...")
        conn.execute(f"COPY (SELECT * FROM {schema}.{table_name}) TO '{output_path}' (FORMAT 'parquet', COMPRESSION 'zstd')")

print("Export completed successfully.")

# Close the connection
conn.close()