if error_code = 40014 then
  message('FRM-40014:Memoria insuficiente para carregar o formulario.');
elsif error_code = 40024 then
  message('FRM-40024:Memoria insuficiente.');
elsif error_code = 40100 then
  message('FRM-40100:Primeiro registro processado.');
elsif error_code = 40101 then
  message('FRM-40101:não existe chave primaria para posicionar.');
elsif error_code = 40102 then
  message('FRM-40102:Primeiro informe ou limpe registro.');
elsif error_code = 40103 then
  message('FRM-40103:não existe chave primaria para posicionar.');
elsif error_code = 40104 then
  message('FRM-40104:Bloco inexistente.');
elsif error_code = 40105 then
  message('FRM-40105:Campo inexistente.');
elsif error_code = 40106 then
  message('FRM-40106:não há campo entravel no bloco destino.');
elsif error_code = 40107 then
  message('FRM-40107:Campo destino com display desabilitado.');
elsif error_code = 40200 then
  message('FRM-40200:Campo protegido contra modificacao.');
elsif error_code = 40201 then
  message('FRM-40201:Campo esta cheio não pode mais receber caracteres.');
elsif error_code = 40202 then
  message('FRM-40202:Campo deve ser informado.');
elsif error_code = 40203 then
  message('FRM-40203:Campo deve ser informado completamente.');
elsif error_code = 40204 then
  message('FRM-40204:Cursor já esta posicionado no inicio do campo.');
elsif error_code = 40206 then
  message('FRM-40206:Caracter a ser eliminado esta invisivel.');
elsif error_code = 40207 then
  message(replace(replace(message_text,'Must be in range', 'Deve esta na faixa de.'),' to ',' ate .'));
elsif error_code = 40208 then
  message('FRM-40208:Tela operando em modo de pesquisa não pode ser alterada.');
elsif error_code = 40209 then
  message(replace(message_text,'Field must be of form', 'Campo deve ter a forma:.'));
elsif error_code = 40300 then
  message('FRM-40300:Campo não pertence a tabela que esta sendo pesquisada.');
elsif error_code = 40302 then
  message('FRM-40302:não existe campo para entar pesquisa.');
elsif error_code = 40356 then
  message('FRM:40356:Numero invalido no registro exemplo. Pesquisa não efetuada.');
elsif error_code = 40357 then
  message('FRM-40357:Carac. invalidos no registro exemplo. Pesquisa não efetuada.');
elsif error_code = 40358 then
  message('FRM-40358:Data invalida no registro exemplo. Pesquisa não efetuada.');
elsif error_code = 40359 then
  message('FRM-40359:Data/Hora invalida no registro exemplo. Pesquisa não efetuada.');
elsif error_code = 40401 then
  message('FRM-40401:não existe alteracao para gravar.');
elsif error_code = 40403 then
  message('FRM-40403:Grave os dados antes de executar esta acao.');
elsif error_code = 40405 then
  message('FRM-40405:não existe alteracao para gravar.');
elsif error_code = 40501 then
  message(replace(message_text, 'unable to reserve record for update or delete', 'não foi possivel reservar registro para alteracao/eliminacao.'));
elsif error_code = 40502 then
  message(replace(message_text, 'unable to read list of values', 'não foi possivel executar abrir de valores.'));
elsif error_code = 40504 then
  message(replace(replace(message_text, 'unable to execute a', 'não foi possivel executar gatilho.'),'trigger','.'));
elsif error_code = 40505 then
  message(replace(message_text, 'unable to perform query', 'não foi possivel executar pesquisa.'));
elsif error_code = 40506 then
  message(replace(message_text, 'unable to check for record uniqueness', 'não foi possivel checar chave unica.'));
elsif error_code = 40507 then
  message(replace(message_text, 'unable to fetch next query record', 'não foi possivel capturar registro na pesquisa.'));
elsif error_code = 40508 then
  message(replace(message_text, 'unable to INSERT record', 'não foi possivel INSERIR registro.'));
elsif error_code = 40509 then
  message(replace(message_text, 'unable to UPDATE record', 'não foi possivel ALTERAR registro.'));
elsif error_code = 40510 then
  message(replace(message_text, 'unable to DELETE record', 'não foi possivel ELIMINAR registro.'));
elsif error_code = 40512 then
  message(replace(message_text, 'unable to issue SAVEPOINT', 'não foi possivel gerar SAVEPOINT.'));
elsif error_code = 40600 then
  message('FRM-40600:Registro foi inserido anteriormente, chave duplicada.');
elsif error_code = 40602 then
  message('FRM-40602:Tela apenas para consulta.');
elsif error_code = 40603 then
  message('FRM-40603:Registro não mais reservado para alteracao. Pesquise novamente.');
elsif error_code = 40652 then
  message('FRM-40652:não foi possivel reservar registro para alteracoes.');
elsif error_code = 40654 then
  message('FRM-40654:Registro alterado por outro usuario. Pesquise para ver mudancas.');
elsif error_code = 40655 then
  message('FRM-40655:ROLLBACK forcado. Limpe formulario e tente novamente.');
elsif error_code = 40656 then
  message('FRM-40656:Alteracao não pode ser efetuada. Limpe o registro.');
elsif error_code = 40700 then
  message(replace(message_text, 'No such trigger', 'Não existe gatilho.'));
elsif error_code = 40704 then
  message('FRM-40704:Sentenca SQL ilegal.');
elsif error_code = 40705 then
  message('FRM-40705:Sentenca SQL ilegal.');
elsif error_code = 40714 then
  message('FRM 40714:Funcao ilegal para este contexto.');
elsif error_code = 40722 then
  message('FRM 40722:Nome de funcao ilegal.');
elsif error_code = 40723 then
  message('FRM 40723:Falta argumento para funcao.');
elsif error_code = 40728 then
  message('FRM 40728:Argumentos em excesso funcao.');
elsif error_code = 40735 then
  message(replace(message_text, 'trigger raised unhandled exception', 'Ocorrencia de erro não tratado em:.'));
elsif error_code = 40737 then
  message(replace(replace(message_text, 'Illegal restricted procedure', 'Procedimento restrito.'),' in ',' ilegal no TRIGGER .'));
elsif error_code = 40738 then
  message('FRM 40738:Passagem de argumento nulo não permitido.');
elsif error_code = 40739 then
  message('FRM 40739:CLEAR_FORM com FULL_ROLLBACK não permitido.');
elsif error_code = 40808 then
  message(replace(message_text, 'Can''t execute HOST command. Error code', 'não foi possivel executar comando. Codigo de erro.'));
elsif error_code = 40809 then
  message(replace(message_text, 'HOST command had error code', 'Comando retornou Codigo de erro.'));
elsif error_code = 40811 then
  message(replace(message_text, 'Shell command had error code Error code', 'Comando retornou Codigo de erro.'));
elsif error_code = 40814 then
  message('FRM-40814:Funcao ilegal neste contexto.');
elsif error_code = 41106 then
  message('FRM-41106:Não é possível inserir inforações sem existir um registro pai.');
ELSIF message_code = 41830 then
  message('FRM-41830:Lista de valores está vazia.');
elsif error_code = 40815 then
  message(replace(replace(message_text, 'Variable', 'Variavel.'), 'does not exist', 'não existe.'));
elsif error_code = 40816 then
  message('FRM-41816:não foi possivel alocar memoria para novo simbolo.');
elsif error_code = 40817 then
  message('FRM-41817:não foi possivel alocar memoria para novo valor.');
elsif error_code = 40818 then
  message('FRM-41818:Variavel de sistema não existe.');
elsif error_code = 40820 then
  message('FRM-41820:não foi possivel alocar memoria para avaliar valor.');
elsif error_code = 40831 then
  message(replace(message_text, 'Truncation occurred: Value too long for field', 'Valor muito largo para o campo.'));
elsif error_code = 40903 then
  message('FRM-41903:não foi possivel criar arquivo de saida.');
elsif error_code = 41000 then
  message('FRM-41000:Acionada Tecla de Funcao indefinida.');
elsif error_code = 41003 then
  message('FRM-41003:Tecla de Funcao ignorada neste modo.');
elsif error_code = 41004 then
  message('FRM-41004:Tecla de Funcao não permitida neste modo.');
elsif error_code = 41005 then
  message('FRM-41005:Tecla de Funcao não implementada.');
elsif error_code = 41006 then
  message('FRM-41006:Tecla de Funcao não implementada.');
elsif error_code = 41007 then
  message('FRM-41007:Cursor fora do campo. Tecla de Funcao ignorada.');
elsif error_code = 41008 then
  message('FRM-41008:Tecla de Funcao não definida.');
elsif error_code = 41009 then
  message('FRM-41009:Tecla de Funcao não permitida.');
elsif error_code = 41010 then
  message('FRM-41010:não pode alterar atributo.');
elsif error_code = 41011 then
  message('FRM-41011:Atributo indefinido.');
elsif error_code = 41012 then
  message('FRM-41012:Campo ou variavel de referencia indefinido - Inform DBA.');
elsif error_code = 41049 then
  message('FRM-41049:Não é possível excluir este registro.');
elsif error_code = 41050 then
  message('FRM-41050:Não é possível alterar este registro.');
elsif error_code = 41051 then
  message('FRM-41051:Não é possível inserir registros.');
elsif error_code = 41802 then
  message('FRM-41802:Duplicacao de registro so permitida para registros novos.');
elsif error_code = 41803 then
  message('FRM-41803:não existe registro para copiar.');
elsif error_code = 50001 then
  message('FRM-50001:So permite caracteres de a-z, A-Z e espaco.');
elsif error_code = 50002 then
  message('FRM-50002:O mês deve estar entre 1 e 12.');
elsif error_code = 50003 then
  message('FRM-50003:O ano deve ser 00-99 ou 1000-4712.');
elsif error_code = 50004 then
  message('FRM-50004:O dia deve estar entre 1 e ultimo dia do mês.');
elsif error_code = 50006 then
  message('FRM-50006:So e permido caracteres 0-9 + e -.');
elsif error_code = 50007 then
  message('FRM-50007:Foi informado muitas decimais.');
elsif error_code = 50009 then
  message('FRM-50009:Foi informado muitas de um ponto decimal.');
elsif error_code = 50010 then
  message('FRM-50010:O formato e da forma: [+-]9999999.99.');
elsif error_code = 50012 then
  message('FRM-50012:Data invalida.');
elsif error_code = 50013 then
  message('FRM-50013:O sinal de + ou - deve estar na primeira posicao.');
elsif error_code = 50015 then
  message('FRM-50015:Foi informado muitas de um ponto decimal.');
elsif error_code = 50016 then
  message('FRM-50016:So e permido caracteres 0-9 + - e E.');
elsif error_code = 50017 then
  message('FRM-50017:Hora deve estar entre 0 e 23.');
elsif error_code = 50018 then
  message('FRM-50018:Minutos devem estar entre 0 e 59.');
elsif error_code = 50019 then
  message('FRM-50019:Segundos devem estar entre 0 e 59.');
elsif error_code = 50021 then
  message('FRM-50021:Data invalida.');
elsif error_code = 50022 then
  message('FRM-50022:Formato hora e HH:MM[:SS].');
elsif error_code = 50023 then
  message('FRM-50023:Data invalida.');
elsif error_code = 50024 then
  message('FRM-50024:Espacos não permidos nesta posicao.');
elsif error_code = 50025 then
  message('FRM-50025:Data invalida.');
elsif error_code = 50026 then
  message('FRM-50026:Data invalida.');
elsif instr(error_text,'ORA-01031.') > 0 then
  message('ORA-01031:Privilegio insuficiente para executar esta operacao.');
elsif instr(error_text,'DUP-VAL-ON-INDEX.') > 0 then
  message('ORA-00001:Chave duplicada no indice.');
elsif instr(error_text,'CURSOR_ALREADY_OPEN.') > 0 then
  message('ORA--06511:Cursor aberto anteriormente.');
elsif instr(error_text,'INVALID_CURSOR.') > 0 then
  message('ORA-01001:Cursor invalido.');
elsif instr(error_text,'INVALID_NUMBER.') > 0 then
  message('ORA-01722:Numero invalido.');
elsif instr(error_text,'NO_DATA_FOUND.') > 0 then
  message('ORA-01403:Nenhum dado encontrado na tabela.');
elsif instr(error_text,'NOT_LOGGED_ON.') > 0 then
  message('ORA-01012:não esta conectado ao banco de dados.');
elsif instr(error_text,'TIMEOUT_ON_RESOURCE.') > 0 then
  message('ORA-00051:Recurso ocupado.');
elsif instr(error_text,'TOO_MANY_ROWS.') > 0 then
  message('ORA-01422:Varias registros encontrados.');
elsif instr(error_text,'TRANSACTION_BACKED_OUT.') > 0 then
  message('ORA-00061:Forcado ROLLBACK, tente operacao mais tarde.');
elsif instr(error_text,'VALUE_ERROR.') > 0 then
  message('ORA-06502:Erro no valor de uma variavel.');
elsif instr(error_text,'ZERO_DIVIDE.') > 0 then
  message('ORA-01476:Divisao por zero.');
else
  message(error_type || ' - ' || to_char(error_code) || ' - ' || error_text);
end if;