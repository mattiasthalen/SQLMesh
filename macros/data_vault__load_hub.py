from sqlmesh.core.macros import macro, MacroEvaluator
from sqlglot import exp

@macro()
def data_vault__load_hub(
    evaluator: MacroEvaluator,
    sources: exp.Table | exp.Tuple,
    business_key: exp.Column,
    hash_key: exp.Column,
    source_system: exp.Column,
    source_table: exp.Column,
    updated_at: exp.Column
    ) -> str:

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
                MIN({updated_at}) AS {updated_at}

            FROM
                {source}

            GROUP BY
                {hash_key},
                {business_key},
                {source_system},
                {source_table}
        """
        for index, source in enumerate(sources)
    )

    cte__union: str = f"cte__union AS ({cte__union__body})"
    cte__distinct: str = f"cte__distinct AS (SELECT DISTINCT ON ({business_key}) * FROM cte__union ORDER BY {business_key}, source_index)"
    cte: str = f"WITH {cte__union}, {cte__distinct}"

    start = evaluator.locals.get("start_ts")
    end = evaluator.locals.get("end_ts")

    where: str = "WHERE 1 = 1"

    if start and end:
        where = f"WHERE {updated_at} BETWEEN '{start}' AND '{end}'"

    sql: str = f"{cte} SELECT * FROM cte__distinct {where};"

    return sql