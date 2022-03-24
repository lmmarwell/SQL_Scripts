REM *****************************************************************
PROMPT CREATE the XDB_UTILTIES PACKAGE Specification.
REM *****************************************************************

/** 
*  Overview of  Package Spec: 
*  
*  This package includes specification for subprograms that are used for getting the content 
*  of an OS file which could have XML. It also includes subprograms to perform some basic 
*  XML DB Foldering and DOM Manipulation operations. 
*
**/
CREATE OR REPLACE PACKAGE xdb_utilities AUTHID CURRENT_USER AS

  /** 
  *  Procedure  : getBFILEContent
  *  Overview   : Subprogram for getting the content of the BFILE passed to this function.
  *               This subprogram can be used when the CLOB object associated with the BFILE
  *               is available for passing to this procedure.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  *   @tempCLOB    - IN OUT -  Temporary CLOB Object. 
  *
  *  Note       : When using the getBFILEContent() subprogram the calling application must 
  *               explicitly free the CLOB that the procedure returns
  **/
  PROCEDURE getBFILEContent(FILE     IN     BFILE,
                            charset  IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
                            tempCLOB IN OUT CLOB);
   
  /** 
  *  Function   : getBFILEContent
  *  Overview   : Subprogram for getting the content of the BFILE passed to this function.
  *               This subprogram can be used when the CLOB object associated with 
  *               the BFILE is not available for passing to this function.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  *
  *  Note       : When using the getBFILEContent() subprogram the calling application must 
  *               explicitly free the CLOB that the function returns
  **/
  FUNCTION getBFILEContent(FILE    IN BFILE,
                           charset IN VARCHAR2 DEFAULT 'WE8MSWIN1252')
    RETURN CLOB ;

  /** 
  *  Procedure  : getFileContent
  *  Overview   : Subprogram for getting the content of the filename passed to this function.
  *               This subprogram can be used when the CLOB object associated with 
  *               the file is available for passing to this procedure.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                              access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  *   @tempCLOB         - IN OUT -  Temporary CLOB Object. 
  *   
  *  Note       : When using the getFileContent()subprogram the calling application must explicitly 
  *               free the CLOB that the procedure returns
  **/
  PROCEDURE getFileContent(filename      IN     VARCHAR2,
                           directoryName IN     VARCHAR2 DEFAULT USER,
                           charset       IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
                           tempCLOB      IN OUT CLOB);
    
  /** 
  *  Function   : getFileContent
  *  Overview   : Subprogram for getting the content from a file that is 
  *               identified by the filename and its directory location.
  *               This subprogram can be used when the CLOB object associated 
  *               with the file is not available for passing to this function.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                             access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  *   
  *  Note       : When using getFileContent() subprogram the application must explicitly 
  *               free the CLOB that the function returns
  **/
  FUNCTION getFileContent(filename      IN VARCHAR2,
                          directoryName IN VARCHAR2 DEFAULT USER,
                          charset       IN VARCHAR2 DEFAULT 'WE8MSWIN1252')		      
    RETURN CLOB ;

  /** 
  *  Function   : getXMLFromFile
  *  Overview   : Subprogram for getting the XML content from a file that is 
  *               identified by the filename and its directory location. This subprogram 
  *               can be used when the CLOB object associated with the file is available 
  *               for passing to this function.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                             access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  *   @tempCLOB         - IN OUT -  Temporary CLOB Object. 
  *
  *  Note       : The temporary CLOB is released in this function.
  **/
  FUNCTION  getXMLFromFile(filename      IN     VARCHAR2,
                           directoryName IN     VARCHAR2 DEFAULT USER,
                           charset       IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
                           tempCLOB      IN OUT CLOB)
    RETURN XMLType;
   
  /** 
  *  Function   : getXMLFromFile
  *  Overview   : Subprogram for getting the XML content from a file that is identified 
  *               by the filename and its directory location. This subprogram can be used 
  *               when the CLOB object associated with the file is not available for 
  *               passing to this function.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                             access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  **/
  FUNCTION getXMLFromFile(filename      IN VARCHAR2,
                          directoryName IN VARCHAR2 DEFAULT USER,
                          charset       IN VARCHAR2 DEFAULT 'WE8MSWIN1252')
    RETURN XMLType ;

  /** 
  *  Function   : getXMLFromBFile
  *  Overview   : Subprogram for getting the XML content from a BFILE. 
  *               This subprogram can be used when the CLOB object associated with the
  *               BFILE is available for passing to this function.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  *   @tempCLOB    - IN OUT -  Temporary CLOB Object. 
  *
  *  Note       : The temporary CLOB is released in this function.
  **/
  FUNCTION getXMLFromBFile(FILE     IN     BFILE,
                           charset  IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
	                     tempCLOB IN OUT CLOB)
    RETURN XMLType ;

  /** 
  *  Function   : getXMLFromBFile
  *  Overview   : Subprogram for getting the XML content from a BFILE. This subprogram can 
  *               be used when the CLOB object associated with the BFILE is NOT 
  *               available for passing to this function.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  **/
  FUNCTION getXMLFromBFile(FILE    IN BFILE,
                           charset IN VARCHAR2 DEFAULT 'WE8MSWIN1252')
    RETURN XMLType ;

  /** 
  *  Function   : ResourceExists
  *  Overview   : Subprogram for checking the existence of a resource in the XML DB repository.
  *  Parameters : 
  *   @path        - IN -  The resource path.
  **/
  FUNCTION ResourceExists(path IN VARCHAR2)
    RETURN NUMBER;

  /** 
  *  Procedure  : createHomeDirectory
  *  Overview   : Subprogram for creating HOME directory for a given user in the 
  *               XML DB repository. It also assigns privileges on the home directory.
  *               Here user refers to the database schema.
  *  Parameters : 
  *   @userName   - IN -  The user name for which the home directory needs to be created.
  **/
  PROCEDURE createHomeDirectory(userName IN VARCHAR2);
  
  /** 
  *  Function   : booleanToRaw
  *  Overview   : Subprogram for converting a Boolean value to a Raw value.
  *  Parameters : 
  *   @input   - IN -  The input value to be converted to RAW.
  **/
  FUNCTION booleanToRaw(input IN VARCHAR2)
    RETURN RAW DETERMINISTIC;

  /** 
  *   Function   : rawToBoolean
  *   Overview   : Subprogram for converting a Raw value to a Boolean value.
  *   Parameters : 
  *   @input   - IN -  The input value to be converted to Boolean.
  **/
  FUNCTION rawToBoolean(input IN RAW)
    RETURN VARCHAR2 DETERMINISTIC;

  /** 
  *  Function   : getChildTextNode
  *  Overview   : Subprogram for getting the value of a text node from the specified child 
  *               of the element passed to this function. 
  *               This function uses PL/SQL DOM API for getting the node value.
  *  Parameters : 
  *   @element   - IN -  The DOM Element for the XML document.
  *   @name      - IN -  The node name.
  **/  
  FUNCTION getChildTextNode(element IN DBMS_XMLDOM.DOMELEMENT,
                            name    IN VARCHAR2) 
    RETURN VARCHAR2 deterministic;

END XDB_UTILITIES;
/
show errors

REM *****************************************************************
PROMPT CREATE the XDB_UTILITIES PACKAGE BODY.
REM *****************************************************************

/** 
*  Overview of  Package Body : 
*  
*  This package body includes subprograms that are used for getting the content 
*  of an OS file which could have XML. It also includes subprograms to perform some basic 
*  XML DB Foldering and DOM Manipulation operations. 
*
**/

CREATE OR REPLACE PACKAGE BODY xdb_utilities 
AS

  /** 
  *  Procedure  : getBFILEContent
  *  Overview   : Subprogram for getting the content of the BFILE passed to this function.
  *               This subprogram can be used when the CLOB object associated with the BFILE
  *               is available for passing to this procedure.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  *   @tempCLOB    - IN OUT -  Temporary CLOB Object. 
  *
  *  Note       : When using the getBFILEContent() subprogram the calling application must 
  *               explicitly free the CLOB that the procedure returns
  **/
  PROCEDURE getBFILEContent(FILE     IN     BFILE,
                            charset  IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
                            tempCLOB IN OUT CLOB) IS
    
    targetFile      BFILE;
    dest_offset     NUMBER := 1;
    src_offset      NUMBER := 1;
    lang_context    NUMBER := 0;
    conv_warning    NUMBER := 0;

  BEGIN
    targetFile := FILE ;
    IF (tempCLOB IS NULL) THEN
      -- Create a temporary CLOB to hold the BFILE content.
      DBMS_LOB.createTemporary(tempCLOB, TRUE, DBMS_LOB.SESSION);
    ELSE 
      -- Decrease the length of the CLOB to the value specified in the newlen parameter i.e. to 0
      DBMS_LOB.trim(tempCLOB, 0);
    END IF;

    -- Open the BFILE for read-only access.
    DBMS_LOB.fileopen(targetFile, DBMS_LOB.file_readonly);

    -- Load data from the BFILE to an internal CLOB with necessary character 
    -- set conversion and return the new offsets.
    DBMS_LOB.loadClobfromFile
    (
      tempCLOB,
      targetFile,
      DBMS_LOB.getLength(targetFile),
      dest_offset,
      src_offset,
      NLS_CHARSET_ID(charset),
      lang_context,
      conv_warning
    );

    -- Close the BFILE that was opened through the input locator.
    DBMS_LOB.fileclose(targetFile);
    
  END getBFILEContent;

  /** 
  *  Function   : getBFILEContent
  *  Overview   : Subprogram for getting the content of the BFILE passed to this function.
  *               This subprogram can be used when the CLOB object associated with 
  *               the BFILE is not available for passing to this function.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  *
  *  Note       : When using the getBFILEContent() function the calling application must 
  *               explicitly free the CLOB that the function returns
  **/
  FUNCTION getBFILEContent(FILE    IN BFILE,
                           charset IN VARCHAR2 DEFAULT 'WE8MSWIN1252')
    RETURN CLOB IS

    -- Create a NULL valued CLOB object.
    tempCLOB CLOB := NULL;
  BEGIN

    -- Call the overloaded getBFILEContent() subprogram by passing the BFILE 
    -- and NULL valued CLOB object to get the BFILE contents as CLOB.
    getBFILEContent(FILE, charset, tempCLOB);

    RETURN tempCLOB;
  END getBFILEContent;

  /** 
  *  Procedure  : getFileContent
  *  Overview   : Subprogram for getting the content of the filename passed to this function.
  *               This subprogram can be used when the CLOB object associated with 
  *               the file is available for passing to this procedure.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                              access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  *   @tempCLOB         - IN OUT -  Temporary CLOB Object. 
  *   
  *  Note       : When using the getFileContent()subprogram the calling application must explicitly 
  *               free the CLOB that the procedure returns
  **/
  PROCEDURE getFileContent(filename      IN     VARCHAR2,
                           directoryName IN     VARCHAR2 DEFAULT USER,
                           charset       IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
                           tempCLOB      IN OUT CLOB) IS
    
    -- Get the BFILE object for the OS file specified.
    -- BFILENAME function can be used to get the BFILE object.
    FILE  BFILE := BFILENAME(directoryName, filename);
  BEGIN

    -- Call the overloaded getBFILEContent() subprogram by passing the BFILE 
    -- and the tempCLOB specified to get the BFILE contents as CLOB.
    getBFILEContent(FILE, charset, tempCLOB);
    
  END getFileContent;

  /** 
  *  Function   : getFileContent
  *  Overview   : Subprogram for getting the content from a file that is 
  *               identified by the filename and its directory location.
  *               This subprogram can be used when the CLOB object associated 
  *               with the file is not available for passing to this function.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                             access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  *   
  *  Note       : When using getFileContent() subprogram the application must explicitly 
  *               free the CLOB that the function returns
  **/
  FUNCTION getFileContent(filename      IN VARCHAR2,
                          directoryName IN VARCHAR2 DEFAULT USER,
                          charset       IN VARCHAR2 DEFAULT 'WE8MSWIN1252')		      
    RETURN CLOB IS

    -- Create a NULL valued CLOB object.
    tempCLOB CLOB := NULL;
  BEGIN

    -- Call the overloaded getFileContent() subprogram to get the file contents as CLOB.
    getFileContent(filename, directoryName, charset, tempCLOB);

    RETURN tempCLOB;
  END getFileContent;

  /** 
  *  Function   : getXMLFromFile
  *  Overview   : Subprogram for getting the XML content from a file that is 
  *               identified by the filename and its directory location. This subprogram 
  *               can be used when the CLOB object associated with the file is available 
  *               for passing to this function.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                             access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  *   @tempCLOB         - IN OUT -  Temporary CLOB Object. 
  *
  *  Note       : The temporary CLOB is released in this function.
  **/
  FUNCTION  getXMLFromFile(filename      IN     VARCHAR2,
                           directoryName IN     VARCHAR2 DEFAULT USER,
                           charset       IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
                           tempCLOB      IN OUT CLOB)
    RETURN XMLType IS

    xml            XMLType;
    freeCLOBOnExit BOOLEAN;
  BEGIN
    freeCLOBOnExit := tempCLOB IS NULL;

    -- Get the file content.
    getFileContent(filename, directoryName, charset, tempCLOB);

    -- Get the XML content by applying XMLType function to the tempCLOB value.
    xml := XMLType(tempCLOB);

    IF (freeCLOBOnExit) THEN
      -- Free the temporary CLOB
      dbms_lob.freeTemporary(tempCLOB);
    ELSE
      dbms_lob.trim(tempCLOB, 0);
    END IF;

    -- Return the XML content as XMLType.
    RETURN xml;
  END getXMLFromFile;

  /** 
  *  Function   : getXMLFromFile
  *  Overview   : Subprogram for getting the XML content from a file that is identified 
  *               by the filename and its directory location. This subprogram can be used 
  *               when the CLOB object associated with the file is not available for 
  *               passing to this function.
  *  Parameters : 
  *   @filename         - IN -  File whose content needs to be read.
  *   @directoryName    - IN -  Directory object pointing to the location from where to 
  *                             access the file whose content needs to be read.
  *   @charset          - IN -  Character set to be used while reading the file content.
  **/
  FUNCTION getXMLFromFile(filename      IN VARCHAR2,
                          directoryName IN VARCHAR2 DEFAULT USER,
                          charset       IN VARCHAR2 DEFAULT 'WE8MSWIN1252')
    RETURN XMLType IS

    -- Create a NULL valued CLOB object.
    tempCLOB CLOB := NULL;
  BEGIN
    -- Call the overloaded getXMLFromFile function to get the XML content from the file.
    RETURN getXMLFromFile(filename, directoryName, charset, tempCLOB);
  END getXMLFromFile;

  /** 
  *  Function   : getXMLFromBFile
  *  Overview   : Subprogram for getting the XML content from a BFILE. 
  *               This subprogram can be used when the CLOB object associated with the
  *               BFILE is available for passing to this function.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  *   @tempCLOB    - IN OUT -  Temporary CLOB Object. 
  *
  *  Note       : The temporary CLOB is released in this function.
  **/
  FUNCTION getXMLFromBFile(FILE     IN     BFILE,
                           charset  IN     VARCHAR2 DEFAULT 'WE8MSWIN1252',
	                         tempCLOB IN OUT CLOB)
    RETURN XMLType IS

    xml            XMLType;
    freeCLOBOnExit BOOLEAN;
  BEGIN
    freeCLOBOnExit := tempCLOB IS NULL;

    -- Get the XML content from the BFILE.
    getBFileContent(FILE, charset, tempCLOB);

    -- Get the XML content by applying XMLType function to the tempCLOB value.
    xml := XMLType(tempCLOB);

    IF (freeCLOBOnExit) THEN
      -- Free the temporary CLOB.
      dbms_lob.freeTemporary(tempCLOB);
    ELSE
      dbms_lob.trim(tempCLOB, 0);
    END IF;

    -- Return the XML content as XMLType
    RETURN xml;
  END getXMLFromBFile;

  /** 
  *  Function   : getXMLFromBFile
  *  Overview   : Subprogram for getting the XML content from a BFILE. This subprogram can 
  *               be used when the CLOB object associated with the BFILE is NOT 
  *               available for passing to this function.
  *  Parameters : 
  *   @file        - IN -  BFILE handle of the file whose content needs to be read.
  *   @charset     - IN -  Character set to be used while reading the file content.
  **/
  FUNCTION getXMLFromBFile(FILE    IN BFILE,
                           charset IN VARCHAR2 DEFAULT 'WE8MSWIN1252')
    RETURN XMLType IS
  
    -- Create a NULL valued CLOB object.
    tempCLOB CLOB := NULL;
  BEGIN

    -- Call the overloaded getXMLFromBFile function to get the XML content from the BFILE.
    RETURN getXMLFromBFile(FILE, charset, tempCLOB);

  END getXMLFromBFile;

  /** 
  *  Function   : ResourceExists
  *  Overview   : Subprogram for checking the existence of a resource in the XML DB repository.
  *  Parameters : 
  *   @path        - IN -  The resource path.
  **/
  FUNCTION ResourceExists(path IN VARCHAR2)
    RETURN NUMBER AS

    result NUMBER;
  BEGIN 
    -- Checking for the existence of the resource with the specified path.
    SELECT COUNT(*) 
    INTO result 
    FROM resource_view
    WHERE equals_path(res, path) = 1;
    
    -- Return the result
    RETURN result;
  END ResourceExists; 

  /** 
  *  Procedure  : createHomeDirectory
  *  Overview   : Subprogram for creating HOME directory for a given user in the 
  *               XML DB repository. It also assigns privileges on the home directory.
  *               Here user refers to the database schema.
  *  Parameters : 
  *   @userName   - IN -  The user name for which the home directory needs to be created.
  **/
  PROCEDURE createHomeDirectory(userName IN VARCHAR2) AS

    targetResource VARCHAR2(256);
    result         BOOLEAN;
  BEGIN
    targetResource := '/home';

    -- Check for the existence of the HOME directory.
    IF (ResourceExists(targetResource) = 0) THEN

      -- If HOME directory does not exist then create one.
      result := dbms_xdb.createFolder(targetResource);

      -- Set access privileges for the HOME directory.
      dbms_xdb.setAcl(targetResource,'/sys/acls/bootstrap_acl.xml');
    END IF;

    targetResource := '/home/' || userName;

    IF (ResourceExists(targetResource) = 0) THEN
      -- Create the HOME directory folder for the user specified.
      result := dbms_xdb.createFolder(targetResource);
    END IF;
  
    -- Set access privileges for the user's HOME directory.
    dbms_xdb.setAcl(targetResource,'/sys/acls/all_owner_acl.xml');
 
    -- Update the ownership information in the repository.
    UPDATE resource_view
      SET res = updateXml(res,'/Resource/Owner/text()',userName)
      WHERE equals_path(res, targetResource) = 1;
 
  END createHomeDirectory;

  /** 
  *  Function   : booleanToRaw
  *  Overview   : Subprogram for converting a Boolean value to a Raw value.
  *  Parameters : 
  *   @input   - IN -  The input value to be converted to RAW.
  **/
  FUNCTION booleanToRaw(input IN VARCHAR2)
    RETURN RAW DETERMINISTIC IS
  BEGIN
    IF (input = 'true') THEN
      RETURN HEXTORAW('01');
    END IF;
    RETURN HEXTORAW('00');
  END booleanToRaw;

  /** 
  *   Function   : rawToBoolean
  *   Overview   : Subprogram for converting a Raw value to a Boolean value.
  *   Parameters : 
  *   @input   - IN -  The input value to be converted to Boolean.
  **/
  FUNCTION rawToBoolean(input IN RAW)
    RETURN VARCHAR2 DETERMINISTIC IS
  BEGIN
    IF (input = HEXTORAW('01')) THEN
      RETURN 'true';
    END IF;
    RETURN 'false';
  END rawToBoolean;

  /** 
  *  Function   : getChildTextNode
  *  Overview   : Subprogram for getting the value of a text node from the specified child 
  *               of the element passed to this function. 
  *               This function uses PL/SQL DOM API for getting the node value.
  *  Parameters : 
  *   @element   - IN -  The DOM Element for the XML document.
  *   @name      - IN -  The node name.
  **/  
  FUNCTION getChildTextNode(element IN DBMS_XMLDOM.DOMELEMENT,
                            name    IN VARCHAR2)
    RETURN VARCHAR2 deterministic AS

    textNodeValue VARCHAR2(2048) := NULL;
    nodeList      DBMS_XMLDOM.DOMNODELIST;
    child         DBMS_XMLDOM.DOMNODE;
  BEGIN
    -- Access the element. 
    nodeList := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(element, name);

    IF (dbms_xmldom.getlength(nodeList) > 0) THEN
      -- Manipulate the node list to get the node value.
      child := DBMS_XMLDOM.ITEM(nodeList, 0);
      child := DBMS_XMLDOM.GETFIRSTCHILD(child);
      textNodeValue := DBMS_XMLDOM.GETNODEVALUE(child);
    END IF;

    -- Return the node value.
    RETURN textNodeValue;

  END getChildTextNode;

END xdb_utilities;
/