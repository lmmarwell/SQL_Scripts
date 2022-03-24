begin
  for x in (select ao.owner,
                   ao.object_name,
                   ao.object_type,
                   ao.owner || '.' || ao.object_name  objeto
              from sys.all_objects ao
             where ao.object_type in ('FUNCTION', 'INDEX', 'INDEXTYPE', 'LOB', 'MATERIALIZED VIEW',
                                      'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'PROGRAM', 'SEQUENCE',
                                      'SYNONYM', 'TABLE', 'TRIGGER', 'TYPE', 'TYPE BODY', 'VIEW')
               and ao.owner       in ('COAT', 'COAT_APLICACAO', 'CONFIG_AMB', 'COTA_TELA', 'CTG', 'CTRL_EXIB', 'EXIBICAO',
                                      'MOMUR', 'MOMUR_APLICACAO', 'PESQUISA', 'SABF', 'SABF_APLICACAO', 'SACS',
                                      'SACS_APLICACAO', 'SAD', 'SADIS_SAVI', 'SADIS_SAVI_R', 'SAD_AEE_APLICACAO',
                                      'SAD_AEE_REVALIDACAO', 'SAD_APLICACAO', 'SAD_REVALIDACAO', 'SAD_SANFOM',
                                      'SANFOM', 'SANFOM_APLICACAO', 'SCB', 'SCBCERT', 'SCBCERT_APLICACAO',
                                      'SCB_APLICACAO', 'SGAD', 'SGAD_APLICACAO', 'SIA', 'SIF', 'SITI', 'SRPTV',
                                      'SRPTV_APLICACAO', 'STR', 'STR_APLICACAO', 'SUAT', 'SUAT_APLICACAO', 'USER_REPORT',
                                      'WS_OBRAS_APLICACAO', 'WS_SAD_CORE_APLICACAO', 'WS_SANFOM')) loop
    sys.dbms_output.put_line('grant all on ' || x.objeto || ' to "AD_FRANCINE";');
    -- execute immediate 'grant all on ' || x.object_name || ' to "AD_FRANCINE"'; 
  end loop;
end;

