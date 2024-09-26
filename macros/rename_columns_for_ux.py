from sqlglot import exp
from sqlmesh.core.macros import macro
from typing import List
import re

@macro()
def rename_columns_for_ux(evaluator, model_name: str, ignore_suffix: str = '', ignore_prefix: str = '') -> List[exp.Expression]:
    """
    Macro to rename all columns in a table for better UX by replacing underscores 
    and formatting the names in a more readable, user-friendly format.
    
    Args:
        evaluator: The evaluator to get column names from the model.
        model_name (str): The model name (as a string) from which the columns are retrieved.
        ignore_suffix (str, optional): A suffix to ignore for renaming. Defaults to ''.
        ignore_prefix (str, optional): A prefix to ignore for renaming. Defaults to ''.
    
    Returns:
        List[exp.Expression]: A list of renamed column projections.
    """
    renamed_projections: List[exp.Expression] = []

    # Loop through the columns of the model
    for name in evaluator.columns_to_types(model_name):
        
        # Skip the iteration if the column should be ignored based on prefix or suffix
        if name.endswith(ignore_suffix) or name.startswith(ignore_prefix):
            renamed_projections.append(exp.column(name))
            continue

        # Replace "__" with " - " and "_" with a space, then convert to Title Case
        new_name: str = re.sub(r'__', ' - ', name)
        new_name = re.sub(r'_', ' ', new_name)
        new_name = new_name.title()

        # Add the renamed column to the projections
        renamed_projections.append(exp.column(name).as_(new_name))

    return renamed_projections