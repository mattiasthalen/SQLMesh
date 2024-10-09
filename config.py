import os

from sqlmesh.core.config import (
    Config,
    ModelDefaultsConfig,
    GatewayConfig,
    DuckDBConnectionConfig,
    NameInferenceConfig,
    AutoCategorizationMode,
    CategorizerConfig,
    PlanConfig
)

config = Config(
    project="jaffle_shop",
    default_target_environment=os.getenv('DEFAULT_ENVIRONMENT', 'dev'),
    gateways={
        "local": GatewayConfig(
            connection=DuckDBConnectionConfig(
                database="warehouse.duckdb"
            )
        )
    },
    default_gateway="local",
    model_defaults=ModelDefaultsConfig(
        dialect="duckdb",
        start="2018-01-01"
    ),
    model_naming=NameInferenceConfig(
        infer_names=True
    ),
    plan=PlanConfig(
        auto_categorize_changes=CategorizerConfig(
            external=AutoCategorizationMode.FULL,
            python=AutoCategorizationMode.FULL,
            sql=AutoCategorizationMode.FULL,
            seed=AutoCategorizationMode.FULL,
        )
    )
)