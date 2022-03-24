/*
--------------------------------------------------------------------------------
Fonte: http://savepoint.blog.br/monitoramento-basico-de-objetos-no-oracle/

Monitoramento básico de objetos no Oracle

Todo DBA que se prese deve acompanhar o crescimento da base conforme o tempo.
Prever o espaço em disco necessário nos próximos meses, saber qual época ocorre
maior crescimento da base. Acompanhar de perto objetos críticos que ocupam mais
espeço, etc.

É claro que a própria Oracle e outros fornecedores possuem ferramentas bastente
sofisticadas para fazer algumas destas coisas. É bem verdade que boa parte delas
faz em maior ou menor grau algo bem semelhante ao que vou mostrar adiante.
No entanto, eu gosto da minha solução, pois eu consigo entendê-la facilmente e
modificar para necessidades específicas. No mínimo é um bom exercício de aprendizado.

Vejamos alguns requisitos que eu montei:
 - Ser compatível com pelo menos o Oracle 8 em diante;
 - Armazenar todas informações num tablespace separado, para que a coleta de dados não influencie nos demais tablespaces;
 - Utilizar um esquema separado para a criação de todos os objetos envolvidos. O usuário em questão deverá ser bloqueado e ter o mínimo de privilégios necessários;
 - Criar uma tabela para registrar a data de duração no disparo de cada script e outra para os erros que por ventura venham a ocorrer;
 - Coletar as seguintes informações com as respectivas periodicidades:
     * Dados sobre o tamanho dos tablespaces uma vez por mês;
     * Dados sobre a quantidade e tipo de objetos por esquema uma vez por dia, atualizando apenas as mudanças ocorridas;
     * Nome dos objetos inválidos auma vez por dia, atualizando apenas as mudanças ocorridas;
     * Tamanhode objetos que ocupem mais de 64MB ou tenham mais de 50 extents ou mais de um milhão de registros uma vez por semana, atualizando apenas as mudanças ocorridas;
--------------------------------------------------------------------------------
*/

--------------------------------------------------------------------------------
-- Objetos
--------------------------------------------------------------------------------
create tablespace 'dba_log_dados' datafile '/u01/oradata/nome_da_base/dba_log_dados_01.dbf' size 100m logging extent management local segment space management auto;

create user dba_log identified by dba default tablespace dba_log_dados quota unlimited on dba_log_dados account lock;

grant create procedure to dba_log;
grant create table     to dba_log;

-- EXECUTAR COMO SYSDBA
grant select on dba_objects    to dba_log;
grant select on dba_segments   to dba_log;
grant select on dba_data_files to dba_log;
grant select on dba_free_space to dba_log;
grant select on dba_tables     to dba_log;

create sequence dba_log.log_seq;

create table dba_log.log(
  id_log      number(10),
  rotina      varchar2(100),
  usuario     varchar2(30) default user,
  inicio      date default sysdate,
  fim         date,
  constraint  log_pk primary key(id_log)
);

create table dba_log.erros (
  id_log      number(10),
  cod_erro    number(10),
  mensagem     varchar2(64),
  data        timestamp default systimestamp
);

create table dba_log.tablespace (
  nome        varchar2(30),
  maximo      number(8) not null,
  alocado     number(8) not null,
  utilizado   number(8) not null,
  livre       number(8) not null,
  data        date default sysdate,
  constraint tablespaces_pk primary key (nome,data)
);

create or replace procedure dba_log.tablespace_load as
  v_log_seq number(10);
  v_code    number(10);
  v_errm    varchar2(64);
  begin
    select dba_log.log_seq.nextval
      into v_log_seq
      from dual;
    
    insert into dba_log.log(
      id_log,
      rotina
    )
    values(
      v_log_seq,
      'tablespace_load'
    );

    insert into dba_log.tablespace(
      nome,
      maximo,
      alocado,
      utilizado,
      livre
    )
    select u.tablespace_name,
           m.maximo,
           m.alocado,
           u.utilizado,
           l.livre
    from (select tablespace_name,
                 ceil(sum(bytes) / 1048576) utilizado
            from dba_segments
           group by tablespace_name) u,
         (select tablespace_name,
                 ceil(sum(bytes) / 1048576) alocado,
                 ceil(sum(decode(autoextensible, 'NO', bytes, maxbytes)) / 1048576) maximo
            from dba_data_files
           group by tablespace_name) m,
         (select tablespace_name,
                 ceil(sum(bytes) / 1048576) livre
            from dba_free_space
           group by tablespace_name) l
    where l.tablespace_name = u.tablespace_name
      and l.tablespace_name = m.tablespace_name;
    
    update dba_log.log
       set fim = sysdate
     where id_log = v_log_seq;
    
    commit;

  exception
    when others then
      v_code := sqlcode;
      v_errm := substr(sqlerrm, 1 , 64);
      insert into dba_log.erros(id_log, cod_erro, mensagem) values (v_log_seq, v_code, v_errm);
end;
/

CREATE TABLE dba_log.objeto_qt (
    tipo        varchar2(19),
    esquema     varchar2(30),
    status      varchar2(7),
    qt          number(5) NOT NULL,
    data        date DEFAULT SYSDATE,
    CONSTRAINT objeto_qt_pk PRIMARY KEY (tipo, esquema, status, data)
);

CREATE OR REPLACE PROCEDURE dba_log.objeto_qt_load AS
  v_log_seq number(10);
  v_code number(10);
  v_errm varchar2(64);
BEGIN
  SELECT dba_log.log_seq.nextval INTO v_log_seq FROM dual;
  INSERT INTO dba_log.log (id_log, rotina) VALUES (v_log_seq,'objeto_qt_load');

  INSERT INTO dba_log.objeto_qt (tipo, esquema, status, qt)
    SELECT b.tipo, b.esquema, b.status, b.qt
      FROM
        (SELECT object_type tipo, owner esquema, status FROM dba_objects
           MINUS
           SELECT tipo, esquema, status FROM dba_log.objeto_qt) a,
        (SELECT object_type tipo, owner esquema, status, count(*) qt
           FROM dba_objects
           GROUP BY owner, object_type, status) b
      WHERE
        a.tipo = b.tipo AND
        a.esquema = b.esquema AND
        a.status = b.status
      ORDER BY esquema, tipo, status
   ;

  INSERT INTO dba_log.objeto_qt (tipo, esquema, status, qt)
    SELECT o.tipo, o.esquema, o.status, o.qt
      FROM
        dba_log.objeto_qt q,
        (SELECT object_type tipo, owner esquema, status, count(*) qt
           FROM dba_objects
           GROUP BY owner, object_type, status) o,
        (SELECT tipo, esquema, status, max(data) data
           FROM dba_log.objeto_qt
           GROUP BY tipo, esquema, status) d
      WHERE
        o.tipo = q.tipo AND
        o.tipo = d.tipo AND
        o.esquema = q.esquema AND
        o.esquema = d.esquema AND
        o.status = q.status AND
        o.status = d.status AND
        q.data = d.data AND
        o.qt != q.qt
        order by o.esquema, o.tipo, o.status
  ;
  UPDATE dba_log.log SET fim = SYSDATE WHERE id_log = v_log_seq;
  COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      v_code := SQLCODE;
      v_errm := SUBSTR(SQLERRM, 1 , 64);
      INSERT INTO erros (id_log, cod_erro, mensagem) VALUES (v_log_seq, v_code, v_errm);
END;
/

CREATE TABLE dba_log.objeto_invalido (
    tipo        varchar2(19),
    esquema     varchar2(30),
    nome        varchar2(128),
    data        date DEFAULT SYSDATE,
    CONSTRAINT objeto_invalido_pk PRIMARY KEY (tipo, esquema, nome, data)
);

CREATE OR REPLACE PROCEDURE dba_log.objeto_invalido_load AS
  v_log_seq number(10);
  v_code number(10);
  v_errm varchar2(64);

BEGIN
  SELECT dba_log.log_seq.nextval INTO v_log_seq FROM dual;
  INSERT INTO dba_log.log (id_log, rotina) VALUES (v_log_seq,'objeto_invalido_load');
  INSERT INTO dba_log.objeto_invalido (tipo, esquema, nome)
    SELECT object_type tipo, owner esquema, object_name nome
      FROM dba_objects
      WHERE status != 'VALID'
    MINUS
    SELECT tipo, esquema, nome FROM dba_log.objeto_invalido
  ;
  UPDATE dba_log.log SET fim = SYSDATE WHERE id_log = v_log_seq;
  COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      v_code := SQLCODE;
      v_errm := SUBSTR(SQLERRM, 1 , 64);
      INSERT INTO dba_log.erros (id_log, cod_erro, mensagem) VALUES (v_log_seq, v_code, v_errm);
END;
/

CREATE TABLE dba_log.objeto_tamanho (
    tipo        varchar2(19),
    tablespace  varchar2(30),
    esquema     varchar2(30),
    nome_part   varchar2(112),
    tamanho     number(8),
    extents     number(5),
    num_reg     number(10),
    data        date DEFAULT SYSDATE,
    CONSTRAINT objetos_tamanho_pk PRIMARY KEY (tipo, esquema, nome_part, data)
);

CREATE OR REPLACE PROCEDURE dba_log.objeto_tamanho_load AS
  v_log_seq number(10);
  v_code number(10);
  v_errm varchar2(64);

BEGIN

  SELECT dba_log.log_seq.nextval INTO v_log_seq FROM dual;
  INSERT INTO dba_log.log (id_log, rotina) VALUES (v_log_seq,'objeto_tamanho_load');

  INSERT INTO dba_log.objeto_tamanho 
    (tipo, tablespace, esquema, nome_part, tamanho, extents, num_reg)
    SELECT b.tipo, b.tablespace, b.esquema, b.nome_part, b.tamanho, b.extents, b.num_reg
    FROM
      (SELECT
         segment_type tipo,
         owner esquema,
         NVL2(partition_name, segment_name || '/' || partition_name, segment_name) nome_part
         FROM dba_segments
      MINUS
      SELECT tipo, esquema, nome_part FROM dba_log.objeto_tamanho) a,
      (SELECT
        s.segment_type tipo,
        s.tablespace_name tablespace,
        s.owner esquema,
        NVL2(s.partition_name, s.segment_name || '/' || s.partition_name, s.segment_name) nome_part,
        CEIL(s.bytes/1048576) tamanho,
        s.extents,
        t.num_rows num_reg
        FROM
          dba_segments s,
          dba_tables t
       WHERE
         (s.bytes > 67108864 OR s.extents > 50 OR t.num_rows > 1000000) AND
          s.owner = t.owner (+)AND
          s.segment_name = t.table_name (+)) b
    WHERE
      a.tipo = b.tipo AND
      a.esquema = b.esquema AND
      a.nome_part = b.nome_part
  ;    

  INSERT INTO dba_log.objeto_tamanho 
    (tipo, tablespace, esquema, nome_part, tamanho, extents, num_reg)
    SELECT o.tipo, o.tablespace, o.esquema, o.nome_part, o.tamanho, o.extents, o.num_reg
      FROM
        dba_log.objeto_tamanho l,
        (SELECT tipo, esquema, nome_part, max(data) data
          FROM dba_log.objeto_tamanho
          GROUP BY tipo, esquema, nome_part) d,
        (SELECT
          s.segment_type tipo,
          s.tablespace_name tablespace,
          s.owner esquema,
          NVL2(s.partition_name, s.segment_name || '/' || s.partition_name, s.segment_name) nome_part,
          CEIL(s.bytes/1048576) tamanho,
          s.extents,
          t.num_rows num_reg
          FROM
            dba_segments s,
            dba_tables t
          WHERE
            (s.bytes > 67108864 OR s.extents > 50 OR t.num_rows > 1000000) AND
            s.owner = t.owner (+)AND
            s.segment_name = t.table_name (+)) o
      WHERE
        l.tipo = d.tipo AND
        l.tipo = o.tipo AND
        l.esquema = d.esquema AND
        l.esquema = o.esquema AND
        l.nome_part = d.nome_part AND
        l.nome_part = o.nome_part AND
        l.data = d.data AND
        (o.tamanho != CEIL(l.tamanho) OR l.extents != o.extents OR l.num_reg != o.num_reg)
      ORDER BY o.esquema, o.tablespace, o.tipo desc
  ;
  UPDATE dba_log.log SET fim = SYSDATE WHERE id_log = v_log_seq;
  COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      v_code := SQLCODE;
      v_errm := SUBSTR(SQLERRM, 1 , 64);
      INSERT INTO dba_log.erros (id_log, cod_erro, mensagem) VALUES (v_log_seq, v_code, v_errm);
END;
/
--------------------------------------------------------------------------------
--Agendamento - Se você estiver utilizando o Oracle 10g ou superior, deve preferir usar o SCHEDULER:
--------------------------------------------------------------------------------

BEGIN

  DBMS_SCHEDULER.CREATE_WINDOW(
    window_name=>'SYS.MONTH_START_WINDOW',
    resource_plan=>'SYSTEM_PLAN',
    start_date=>SYSTIMESTAMP,
    duration=>numtodsinterval(240, 'minute'),
    repeat_interval=>'FREQ=MONTHLY;BYMONTHDAY=1;BYHOUR=3',
    end_date=>null,
    window_priority=>'LOW',
    comments=>'Start of the month window for maintenance task'
  );

  DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'DBA_LOG.TABLESPACE_LOAD_MENSAL',
    job_type => 'STORED_PROCEDURE',
    job_action => 'DBA_LOG.TABLESPACE_LOAD',
    schedule_name => 'SYS.MONTH_START_WINDOW',
    enabled => TRUE
  );

  DBMS_SCHEDULER.SET_ATTRIBUTE(
    name => '"DBA_LOG"."TABLESPACE_LOAD_MENSAL"',
    attribute => 'job_priority',
    value => 4
  );

  DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'DBA_LOG.OBJETO_TAMANHO_LOAD_SEMANAL',
    job_type => 'STORED_PROCEDURE',
    job_action => 'DBA_LOG.OBJETO_TAMANHO_LOAD',
    schedule_name => 'SYS.WEEKEND_WINDOW',
    enabled => TRUE
  );

  DBMS_SCHEDULER.SET_ATTRIBUTE(
    name => 'DBA_LOG.OBJETO_TAMANHO_LOAD_SEMANAL',
    attribute => 'job_priority',
    value => 4
  );

  DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'DBA_LOG.OBJETO_INVALIDO_LOAD_DIARIO',
    job_type => 'STORED_PROCEDURE',
    job_action => 'DBA_LOG.OBJETO_INVALIDO_LOAD',
    schedule_name => 'SYS.WEEKNIGHT_WINDOW',
    enabled => TRUE
  );

  DBMS_SCHEDULER.SET_ATTRIBUTE(
    name => 'DBA_LOG.OBJETO_INVALIDO_LOAD_DIARIO',
    attribute => 'job_priority',
    value => 4
  );

  DBMS_SCHEDULER.CREATE_JOB(
    job_name => 'DBA_LOG.OBJETO_QT_LOAD_DIARIO',
    job_type => 'STORED_PROCEDURE',
    job_action => 'DBA_LOG.OBJETO_QT_LOAD',
    schedule_name => 'SYS.WEEKNIGHT_WINDOW',
    enabled => TRUE
  );

  DBMS_SCHEDULER.SET_ATTRIBUTE(
    name => 'DBA_LOG.OBJETO_QT_LOAD_DIARIO',
    attribute => 'job_priority',
    value => 4
  );

END;
/

--------------------------------------------------------------------------------
--Agendamento - Se estiver utilizando o Oracle 9i ou inferiro, terá que utilizar os JOBs para agendar a coleta de dados:
--------------------------------------------------------------------------------
VARIABLE jobno NUMBER;
BEGIN
  DBMS_JOB.SUBMIT(:jobno, 'BEGIN DBA_LOG.OBJETO_QT_LOAD; END;',
    TRUNC(SYSDATE) + 1/24, 'TRUNC(SYSDATE) + 1/24 + 30');
  COMMIT;
END;
/

VARIABLE jobno NUMBER;
BEGIN
  DBMS_JOB.SUBMIT(:jobno, 'BEGIN DBA_LOG.TABLESPACE_LOAD; END;',
    TRUNC(SYSDATE) + 1/24, 'TRUNC(SYSDATE + 30,''MONTH'') + 1/24');
  COMMIT;
END;
/

VARIABLE jobno NUMBER;
BEGIN
  DBMS_JOB.SUBMIT(:jobno, 'BEGIN DBA_LOG.OBJETO_TAMANHO_LOAD; END;',
    TRUNC(SYSDATE) + 1/24, 'NEXT_DAY(TRUNC(SYSDATE), ''SATURDAY'') + 1/24');
  COMMIT;
END;
/

VARIABLE jobno NUMBER;
BEGIN
  DBMS_JOB.SUBMIT(:jobno, 'BEGIN DBA_LOG.OBJETO_INVALIDO_LOAD; END;',
    TRUNC(SYSDATE) + 1/24, 'TRUNC(SYSDATE) + 25/24');
  COMMIT;
END;
/

VARIABLE jobno NUMBER;
BEGIN
  DBMS_JOB.SUBMIT(:jobno, 'BEGIN DBA_LOG.OBJETO_QT_LOAD; END;',
    TRUNC(SYSDATE) + 1/24, 'TRUNC(SYSDATE) + 25/24');
  COMMIT;
END;
/
--------------------------------------------------------------------------------
/*
Conclusão

Com os dados coletados nas tabelas, você só precisa agora exercitar um pouco do
seu conhecimento de SQL para fazer consultas criativas e gerar relatórios dos mais
diversos e entregar para o seu chefe no final do ano. Não, adianta nada criar os
objetos agora e tentar fazer mágica. Após um anos, você poderá observar com alguma
precisão a sazonalidade das aplicações e fazer boas projeções. Que tal começar o
ano com um mínimo de coleta de dados na sua base? Quando a turma do ITIL bater na
sua porta, algumas coisas já estarão encaminhadas para o seu lado.
*/
--------------------------------------------------------------------------------
