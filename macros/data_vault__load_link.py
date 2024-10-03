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
    updated_at: exp.Column
    ) -> exp.Expression:

    if not isinstance(sources, exp.Tuple):
        sources = exp.Tuple(expressions=[sources])

    if not isinstance(hash_keys, exp.Tuple):
        hash_keys = exp.Tuple(expressions=[hash_keys])
    
    hash_keys__select = ', '.join([str(hash_key) for hash_key in hash_keys.expressions])

    cte__union: str = " UNION ALL ".join(
        f"""
            SELECT
                {index} as source_index,
                {link_key},
                {hash_keys__select},
                {source_system},
                {source_table},
                MIN({updated_at}) AS {updated_at}
            FROM {source}
            GROUP BY
                {link_key},
                {hash_keys__select},
                {source_system},
                {source_table}
        """
        for index, source in enumerate(sources)
    )

    cte__distinct: str = f"""
        SELECT DISTINCT ON ({link_key})
            {link_key},
            {hash_keys__select},
            {source_system},
            {source_table},
            {updated_at}
        FROM cte__union
        ORDER BY {link_key}, source_index
    """

    start = evaluator.locals.get("start_ts")
    end = evaluator.locals.get("end_ts")

    where: str = "WHERE 1 = 1"

    if start and end:
        where = f"WHERE {updated_at} BETWEEN '{start}' AND '{end}'"

    sql: str = f"""
        WITH
            cte__union AS ({cte__union})
        ,   cte__distinct AS ({cte__distinct})
        SELECT * FROM cte__distinct {where};
    """

    return sql