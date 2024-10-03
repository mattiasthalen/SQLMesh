AUDIT (
  name assert_fk_pk_integrity
);

SELECT
  tm.@fk_column
FROM @this_model AS tm
WHERE
  NOT EXISTS(
    SELECT
      1
    FROM @target_table AS tt
    WHERE
      tt.@pk_column = tm.@fk_column
  )