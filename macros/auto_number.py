import typing as t

from sqlmesh import macro
from sqlglot import exp

@macro()
def auto_number(evaluator, field: exp.Column) -> str:
    return f"ROW_NUMBER() OVER (ORDER BY {field})"