AUDIT (
  name assert_fk_pk_integrity
);

SELECT
  *
FROM @this_model
WHERE
  NOT EXISTS(
    SELECT
      1
    FROM @target_table
    WHERE
      @pk_column = @this_model.@fk_column
  )