from sqlmesh.core.macros import macro
from sqlglot import exp
from typing import List, Union

@macro()
def data_vault__load_satellite(
    evaluator,
    source: exp.Table,
    hash_key: exp.Column,
    pit_key: exp.Column,
    payload: exp.Column | exp.Tuple,
    source_system: exp.Column,
    source_table: exp.Column,
    load_date: exp.Column,
    load_end_date: exp.Column,
    ) -> exp.Expression:

    if not isinstance(payload, exp.Tuple):
        payload = exp.Tuple(expressions=[payload])
    
    payload__select = ', '.join([str(column) for column in payload.expressions])

    sql: str = f"""
            SELECT
                {hash_key},
                {pit_key},
                {payload__select},
                {source_system},
                {source_table},
                {load_date},
                {load_end_date}
            FROM {source}
        """

    return sql