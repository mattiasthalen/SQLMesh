from sqlmesh.core.macros import macro
from sqlglot import exp
from typing import List, Union

@macro()
def data_vault__load_link(
    evaluator,
    sources: exp.Table | exp.Tuple,
    link_key: exp.Column,
    hash_keys: exp.Column | exp.Tuple,
    source_system: exp.Column,
    source_table: exp.Column,
    load_date: exp.Column,
    load_end_date: exp.Column,
    ) -> exp.Expression:

    if not isinstance(sources, exp.Tuple):
        sources = exp.Tuple(expressions=[sources])

    if not isinstance(hash_keys, exp.Tuple):
        hash_keys = exp.Tuple(expressions=[hash_keys])

    cte__union__body: str = " UNION ALL ".join(
        f"""
            SELECT
                {index} as source_index,
                {link_key},
                {', '.join(hash_keys)},
                {source_system},
                {source_table},
                MIN({load_date}) AS {load_date},
                MAX({load_end_date}) AS {load_end_date}
            FROM {source}
            GROUP BY
                {link_key},
                {', '.join(hash_keys)},
                {source_system},
                {source_table}
        """
        for index, source in enumerate(sources)
    )

    cte__union: str = f"WITH cte__union_all AS ({cte__union__body})"

    cte__reduce: str = f"""
    ,   cte__reduce AS (
            SELECT DISTINCT ON ({link_key})
                {link_key},
                {', '.join(hash_keys)},
                {source_system},
                {source_table},
                {load_date}
            FROM cte__union_all
            ORDER BY {link_key}, source_index
        )
    """

    sql: str = f"{cte__union}{cte__reduce} SELECT * FROM cte__reduce;"

    return sql