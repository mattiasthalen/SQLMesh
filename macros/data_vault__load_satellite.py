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
    valid_from: exp.Column,
    valid_to: exp.Column
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
                {valid_from},
                {valid_to}
            FROM {source}
        """

    return sql