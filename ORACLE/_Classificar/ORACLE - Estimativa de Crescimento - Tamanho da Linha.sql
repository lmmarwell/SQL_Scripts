select table_name,
       sum(data_length) tamanho_linha
  from user_tab_columns
 group by table_name
 order by table_name
