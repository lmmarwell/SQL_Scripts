create or replace and compile java source named "MyJavaDbProcedure" as
  public class MyJavaDbProcedure {
    public static String upcase(String text) {
      return text.toUpperCase();
    }
  };
/



create or replace function upcase (s in varchar2) return varchar2 as language java
  name 'MyJavaDbProcedure.upcase(java.lang.String) return java.lang.String';
/

select upcase('hello') from dual;