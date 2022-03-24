/*
Fonte: http://egobet.blogspot.com.br/2013/03/oracle-removendo-caracteres-especiais.html
*/

select 'Inserir formataçao' acao,
       regexp_replace('12345678',       '([0-9]{2})([0-9]{3})([0-9]{3})',                        '\1.\2-\3')         cep,
       regexp_replace('12345',          '([0-9]{2})([0-9]{3})',                                  '\1.\2')            caixa_postal,
       regexp_replace('12345678901234', '([0-9]{2})([0-9]{3})([0-9]{3})([0-9]{4})([0-9]{2})',    '\1.\2.\3/\4-\5')   cnpj,
       regexp_replace('12345678901',    '([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{2})',              '\1.\2.\3-\4')      cpf,
       regexp_replace('+123456789012',  '([+, 0-9]{3})([0-9]{2})([0-9]{4})([0-9]{4})',           '(\1)(\2)\3-\4')    ddi_ddd_telefone,
       regexp_replace('+1234567890123', '([+, 0-9]{3})([0-9]{2})([0-9]{1})([0-9]{4})([0-9]{4})', '(\1)(\2)\3-\4-\5') ddi_ddd_celular
from dual
union all
select 'Remover formataçao' acao,
       regexp_replace('12.345-678',           '[[:punct:]]','') cep,
       regexp_replace('12.345',               '[[:punct:]]','') caixa_postal,
       regexp_replace('12.345.678/9012-34',   '[[:punct:]]','') cnpj,
       regexp_replace('123.456.789-01',       '[[:punct:]]','') cpf,
       regexp_replace('(+12)(34)5678-9012',   '[[:punct:]]','') ddi_ddd_telefone,
       regexp_replace('(+12)(34)5-6789-0123', '[[:punct:]]','') ddi_ddd_celular
from dual;
