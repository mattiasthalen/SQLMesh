import os
from sqlmesh import macro

@macro()
def export_to_parquet(evaluator, table_name: str, folder: str) -> str | None:
    
    # Early exit if the stage is not 'evaluating'
    if evaluator.runtime_stage != 'evaluating':
        return None
    
    # Construct the full file path using os.path to ensure it works across different OS
    file_path = os.path.join(folder, f"{table_name}.parquet")
    
    this_table = evaluator.locals['this_model']
    
    return f"""
    COPY {this_table}
    TO '{file_path}' WITH (
        FORMAT 'parquet',
        COMPRESSION 'ZSTD'
    )
    """