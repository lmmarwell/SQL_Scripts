SELECT SYSTEM_USER;

select *
FROM sys.server_principals SSPs
     LEFT JOIN sys.server_role_members SSRM ON SSPs.principal_id  = SSRM.member_principal_id
     LEFT JOIN sys.server_principals SSPs2 ON SSRM.role_principal_id = SSPs2.principal_id
ORDER BY SSPs2.name DESC, SSPs.name

SELECT * FROM TEMPDB.dbo.sysobjects WHERE NAME IN ('##Users')

SELECT su.[name] ,  
--       u.[Login Name]  , 
       sug.name,
       su.hasdbaccess
 FROM [SAC].[dbo].[sysusers] su 
-- LEFT OUTER JOIN ##Users u  ON su.sid = u.sid 
 LEFT OUTER JOIN ([SAC].[dbo].[sysmembers] sm INNER JOIN [SAC].[dbo].[sysusers] sug ON sm.groupuid = sug.uid) ON su.uid = sm.memberuid  
-- WHERE su.hasdbaccess = 1 
--  and upper(su.[name]) like '%L%'
order by 1;


--------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM TEMPDB.dbo.sysobjects WHERE NAME IN ('##Users')) 
BEGIN
 DROP TABLE ##Users
END
GO

IF EXISTS (SELECT * FROM TEMPDB.dbo.sysobjects WHERE NAME IN (N'##ACESSO')) 
BEGIN
 DROP TABLE ##ACESSO
END
GO

CREATE TABLE ##Users (
[sid] varbinary(100) NULL,
[Login Name] varchar(100) NULL
)

CREATE TABLE ##ACESSO ([uSER ID] VARCHAR(MAX), [sERVER LOGIN] VARCHAR(MAX), [DATABASE ROLE] VARCHAR(MAX), [DATABASE] VARCHAR(MAX))

declare @cmd1 nvarchar(500)
declare @cmd2 nvarchar(500)
set @cmd1 = '
INSERT INTO ##Users ([sid],[Login Name]) SELECT sid, loginname FROM master.dbo.syslogins
INSERT INTO ##ACESSO 
SELECT su.[name] ,  
u.[Login Name]  , 
 sug.name   , ''?''
 FROM [?].[dbo].[sysusers] su 
 LEFT OUTER JOIN ##Users u 
 ON su.sid = u.sid 
 LEFT OUTER JOIN ([?].[dbo].[sysmembers] sm  
 INNER JOIN [?].[dbo].[sysusers] sug 
 ON sm.groupuid = sug.uid) 
 ON su.uid = sm.memberuid  
 WHERE su.hasdbaccess = 1 
 AND su.[name] != ''dbo''
'
exec sp_MSforeachdb @command1=@cmd1

SELECT * FROM ##ACESSO 
GROUP BY 
[uSER ID] , [sERVER LOGIN]  , [DATABASE ROLE]  , [DATABASE]  
--------------------------------------------------------------------------------