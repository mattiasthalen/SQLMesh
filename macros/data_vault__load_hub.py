from sqlmesh.core.macros import macro
from sqlglot import exp
from typing import List, Union

@macro()
def data_vault__load_hub(
    evaluator,
    sources: exp.Table | exp.Tuple,
    business_key: exp.Column,
    hash_key: exp.Column,
    source_system: exp.Column,
    source_table: exp.Column,
    valid_from: exp.Column
    ) -> exp.Expression:

    if not isinstance(sources, exp.Tuple):
        sources = exp.Tuple(expressions=[sources])

    cte__union__body: str = " UNION ALL ".join(
        f"""
            SELECT
                {index} as source_index,
                {hash_key},
                {business_key},
                {source_system},
                {source_table},
                MIN({valid_from}) AS {valid_from}
            FROM {source}
            GROUP BY
                {hash_key},
                {business_key},
                {source_system},
                {source_table}
        """
        for index, source in enumerate(sources)
    )

    cte__union: str = f"WITH cte__union_all AS ({cte__union__body})"

    cte__reduce: str = f"""
    ,   cte__reduce AS (
            SELECT DISTINCT ON ({business_key})
                {hash_key},
                {business_key},
                {source_system},
                {source_table},
                {valid_from}
            FROM cte__union_all
            ORDER BY {business_key}, source_index
        )
    """

    sql: str = f"{cte__union}{cte__reduce} SELECT * FROM cte__reduce;"

    return sql