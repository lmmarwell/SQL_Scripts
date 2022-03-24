select distinct 
       ObjJectType=
       case Obj.xType
         When 'V'  then 'VIEW'
         When 'P'  then 'PROC'
         When 'D'  then 'INDEX'
         When 'TF' then 'TABLE FUNCTION'
         When 'FN' then 'FUNCTION'
         When 'U'  then 'TABLE'
         When 'F'  then 'FK CONSTRAINT'
         When 'PK' then 'PK CONSTRAINT'
         When 'TR' then 'TRIGGER'
         When 'S'  then 'SYSTEM OBJECT'
       end,
       Obj.name
  from syscomments Com 
       inner join sysobjects Obj on Com.id = Obj.id
 where Com.text like '%BB%' 
order by Obj.name
