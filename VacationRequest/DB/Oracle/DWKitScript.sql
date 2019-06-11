/*
Company: OptimaJet
Project: DWKIT Provider for Oracle
Version: 2.6
File: DWKitScript.sql
*/



--Common tables---------------------------------------------------------------------
CREATE TABLE DWAPPSETTINGS (
	NAME NVARCHAR2(50) NOT NULL,
	VALUE NVARCHAR2(1000) NULL,
	GROUPNAME NVARCHAR2(50) NULL,
	PARAMNAME NVARCHAR2(1024) NOT NULL,
	"Order" NUMBER NULL,
	EDITORTYPE NVARCHAR2(50) NULL,
	ISHIDDEN CHAR(1 BYTE) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_DWAPPSETTINGS PRIMARY KEY (NAME) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;
    

INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(DWAPPSETTINGS,PK_DWAPPSETTINGS)*/
    INTO DWAPPSETTINGS(NAME, VALUE, GROUPNAME, PARAMNAME, "Order", EDITORTYPE) VALUES (N'ApplicationDesc', N'', N'Application settings', N'Description', 1, 0);
    
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(DWAPPSETTINGS,PK_DWAPPSETTINGS)*/
    INTO DWAPPSETTINGS(NAME, VALUE, GROUPNAME, PARAMNAME, "Order", EDITORTYPE) VALUES (N'ApplicationName', N'DWKit', N'Application settings', N'Name', 0, 0);
    
INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(DWAPPSETTINGS,PK_DWAPPSETTINGS)*/
    INTO DWAPPSETTINGS(NAME,GROUPNAME,PARAMNAME,VALUE,"Order",EDITORTYPE,ISHIDDEN)VALUES (N'IntegrationApiKey',N'Application settings',N'Api key','',2,0,0 );

    
--UploadedFiles---------------------------------------------------------------
CREATE TABLE DWUPLOADEDFILES(
	ID RAW(16),
	DATA BLOB NOT NULL,
	ATTACHMENTLENGTH NUMBER NOT null,
	USED CHAR(1 BYTE) DEFAULT 0 NOT NULL,
	NAME NVARCHAR2(1000) NOT NULL,
	CONTENTTYPE NVARCHAR2(255) NOT NULL,
	CREATEDBY NVARCHAR2(1024) NULL,
	CREATEDDATE DATE NULL,
	UPDATEDBY NVARCHAR2(1024) NULL,
	UPDATEDDATE DATE NULL,
	PROPERTIES NVARCHAR2(2000) NULL,
    CONSTRAINT PK_DWUPLOADEDFILES PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;
    

--SecurityPermission---------------------------------------------------------------

CREATE TABLE DWSECURITYGROUP(
	ID RAW(16),
	NAME NVARCHAR2(128) NOT NULL,
	"Comment" NVARCHAR2(1000) NULL,
	ISSYNCWITHDOMAINGROUP CHAR(1 BYTE) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_DWSECURITYGROUP PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
 LOGGING;
 
 CREATE TABLE DWSECURITYPERMISSIONGROUP(
	ID RAW(16),
	NAME NVARCHAR2(128) NOT NULL,
	CODE NVARCHAR2(128) NOT NULL,
    CONSTRAINT PK_DWSECURITYPERMISSIONGROUP PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
 LOGGING;
 
 CREATE TABLE DWSECURITYPERMISSION(
	ID RAW(16),
	CODE NVARCHAR2(128) NOT NULL,
	NAME NVARCHAR2(128) NULL,
	GROUPID RAW(16) NOT NULL,
    CONSTRAINT FK_DWSECURITYPERMISSIONGROUP_DWSECURITYPERMISSION FOREIGN KEY (GROUPID) 
        REFERENCES DWSECURITYPERMISSIONGROUP(ID) ON DELETE CASCADE,
    CONSTRAINT PK_DWSECURITYPERMISSION PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

CREATE TABLE DWSECURITYROLE(
	ID RAW(16),
	CODE NVARCHAR2(128) NOT NULL,
	NAME NVARCHAR2(128) NOT NULL,
	"Comment" NVARCHAR2(1000) NULL,
	DOMAINGROUP NVARCHAR2(512) NULL,
    CONSTRAINT PK_DWSECURITYROLE PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

CREATE TABLE DWSECURITYROLETOSECURITYPERMISSION(
	ID RAW(16),
	SECURITYROLEID RAW(16) NOT NULL,
	SECURITYPERMISSIONID RAW(16) NOT NULL,
	ACCESSTYPE NUMBER DEFAULT 0 NOT NULL,
    CONSTRAINT PK_DWSECURITYROLETOSECURITYPERMISSION PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED),
    CONSTRAINT FK_DWSECURITYROLE_DWSECURITYROLETOSECURITYPERMISSION FOREIGN KEY (SECURITYROLEID) 
        REFERENCES DWSECURITYROLE(ID),
    CONSTRAINT FK_DWSECURITYPERMISSION_DWSECURITYROLETOSECURITYPERMISSION FOREIGN KEY (SECURITYPERMISSIONID) 
        REFERENCES DWSECURITYPERMISSION(ID) ON DELETE CASCADE) LOGGING;
        
CREATE TABLE DWSECURITYUSER(
	ID RAW(16),
	NAME NVARCHAR2(256) NOT NULL,
	EMAIL NVARCHAR2(256) NULL,
	ISLOCKED CHAR(1 BYTE) DEFAULT 0 NOT NULL,
	EXTERNALID NVARCHAR2(1024) NULL,
	TIMEZONE NVARCHAR2(256) NULL,
	LOCALIZATION NVARCHAR2(256) NULL,
	DECIMALSEPARATOR NCHAR(1) NULL,
	PAGESIZE NUMBER NULL,
	STARTPAGE NVARCHAR2(256) NULL,
	ISRTL CHAR(1 BYTE) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_DWSECURITYUSER PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

CREATE TABLE DWSECURITYUSERSTATE(
	ID RAW(16),
	SECURITYUSERID RAW(16) NOT NULL,
	KEY NVARCHAR2(256) NOT NULL,
	VALUE NVARCHAR2(2000) NOT NULL,
    CONSTRAINT FK_DWSECURITYUSER_DWSECURITYUSERSTATE FOREIGN KEY (SECURITYUSERID) 
        REFERENCES DWSECURITYUSER(ID) ON DELETE CASCADE,
    CONSTRAINT PK_DWSECURITYUSERSTATE PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;


CREATE TABLE DWSECURITYCREDENTIAL(
	ID RAW(16),
	PASSWORDHASH NVARCHAR2(128) NULL,
	PASSWORDSALT NVARCHAR2(128) NULL,
	SECURITYUSERID RAW(16) NOT NULL,
	LOGIN NVARCHAR2(256) NOT NULL,
	AUTHENTICATIONTYPE NUMBER NOT NULL,
    CONSTRAINT FK_DWSECURITYUSER_DWSECURITYCREDENTIAL FOREIGN KEY (SECURITYUSERID) 
        REFERENCES DWSECURITYUSER(ID) ON DELETE CASCADE,
    CONSTRAINT PK_DWSECURITYCREDENTIAL PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

CREATE TABLE DWSECURITYUSERIMPERSONATION(
	ID RAW(16),
	SECURITYUSERID RAW(16) NOT NULL,
	IMPSECURITYUSERID RAW(16) NOT NULL,
	DATEFROM DATE NOT NULL,
	DATETO DATE NOT NULL,
    CONSTRAINT FK_DWSECURITYUSER_DWSECURITYUSERIMPERSONATION_01 FOREIGN KEY (SECURITYUSERID) 
        REFERENCES DWSECURITYUSER(ID) ON DELETE CASCADE,
    CONSTRAINT FK_DWSECURITYUSER_DWSECURITYUSERIMPERSONATION_02 FOREIGN KEY (IMPSECURITYUSERID) 
        REFERENCES DWSECURITYUSER(ID),
    CONSTRAINT PK_DWSECURITYUSERIMPERSONATION PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

CREATE TABLE DWSECURITYUSERTOSECURITYROLE(
	ID RAW(16),
	SECURITYROLEID RAW(16) NOT NULL,
	SECURITYUSERID RAW(16) NOT NULL,
    CONSTRAINT FK_DWSECURITYROLE_DWSECURITYUSERTOSECURITYROLE FOREIGN KEY (SECURITYROLEID) 
        REFERENCES DWSECURITYROLE(ID),
    CONSTRAINT FK_DWSECURITYUSER_DWSECURITYUSERTOSECURITYROLE FOREIGN KEY (SECURITYUSERID) 
        REFERENCES DWSECURITYUSER(ID),
    CONSTRAINT PK_DWSECURITYUSERTOSECURITYROLE PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

CREATE TABLE DWSECURITYGROUPTOSECURITYROLE(
	ID RAW(16),
	SECURITYROLEID RAW(16) NOT NULL,
	SECURITYGROUPID RAW(16) NOT NULL,
    CONSTRAINT FK_DWSECURITYROLE_DWSECURITYGROUPTOSECURITYROLE FOREIGN KEY (SECURITYROLEID) 
        REFERENCES DWSECURITYROLE(ID),
   CONSTRAINT FK_DWSECURITYGROUP_DWSECURITYGROUPTOSECURITYROLE FOREIGN KEY (SECURITYGROUPID) 
        REFERENCES DWSECURITYGROUP(ID),
    CONSTRAINT PK_DWSECURITYGROUPTOSECURITYROLE PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

CREATE TABLE DWSECURITYGROUPTOSECURITYUSER(
	ID RAW(16),
	SECURITYUSERID RAW(16) NOT NULL,
	SECURITYGROUPID RAW(16) NOT NULL,
    CONSTRAINT FK_DWSECURITYUSER_DWSECURITYGROUPTOSECURITYUSER FOREIGN KEY (SECURITYUSERID) 
        REFERENCES DWSECURITYUSER(ID),
   CONSTRAINT FK_DWSECURITYGROUP_DWSECURITYGROUPTOSECURITYUSER FOREIGN KEY (SECURITYGROUPID) 
        REFERENCES DWSECURITYGROUP(ID),
    CONSTRAINT PK_DWSECURITYGROUPTOSECURITYUSER PRIMARY KEY (ID) USING INDEX STORAGE ( INITIAL 64K NEXT 1M MAXEXTENTS UNLIMITED ))
LOGGING;

declare
  cnt number;
begin
  select count(*) into cnt from DWSECURITYCREDENTIAL;
  if cnt = 0 then
  		INSERT INTO DWSECURITYUSER(ID,NAME,EMAIL,ISLOCKED) VALUES ('540E514C911F4A03AC90C450C28838C5','admin', '', 0);
		INSERT INTO DWSECURITYCREDENTIAL(ID,PASSWORDHASH,PASSWORDSALT,SECURITYUSERID,LOGIN,AUTHENTICATIONTYPE) 
		VALUES('C0819C1DC3BA4EA7ADA1DF2D3D24C62F','VatmT7uZ8YiKAbBNrCcm2J7iW5Q=','/9xAN64KIM7tQ4qdAIgAwA==',	'540E514C911F4A03AC90C450C28838C5',	'admin',	0);
		
		INSERT INTO DWSECURITYPERMISSIONGROUP(ID,NAME,CODE) VALUES ('94B616A162B541ABAA1046856158C55E', 'Common', 'Common');
		INSERT INTO DWSECURITYPERMISSION(ID,CODE,NAME,GROUPID) VALUES ('952DC428693D4E83A809ABB6AFF7CA95', 'AccessToAdminPanel', 'Access to admin panel', '94B616A162B541ABAA1046856158C55E');
		INSERT INTO DWSECURITYROLE(ID,CODE,NAME,"Comment",DOMAINGROUP) VALUES( '1B7F60C8D86045108E715469FC1814D3', 'Admins', 'Admins', '', '');
		INSERT INTO DWSECURITYROLETOSECURITYPERMISSION(ID, SECURITYROLEID,SECURITYPERMISSIONID,ACCESSTYPE) VALUES ( '88B616A162B541ABAA1058851158C440', '1B7F60C8D86045108E715469FC1814D3', '952DC428693D4E83A809ABB6AFF7CA95', 1);
		INSERT INTO DWSECURITYUSERTOSECURITYROLE(ID, SECURITYROLEID,SECURITYUSERID) VALUES ('88B616A162B541ABAA1058851158C4DD', '1B7F60C8D86045108E715469FC1814D3', '540E514C911F4A03AC90C450C28838C5');
  end if;
end;
/

CREATE OR REPLACE VIEW DWV_SECURITY_USERROLE AS
SELECT 
	SECURITYUSERID AS USERID, 
	SECURITYROLEID AS ROLEID 
FROM DWSECURITYUSERTOSECURITYROLE

UNION

SELECT DISTINCT
	DWSECURITYGROUPTOSECURITYUSER.SECURITYUSERID AS USERID, 
	DWSECURITYGROUPTOSECURITYROLE.SECURITYROLEID AS ROLEID 
FROM DWSECURITYGROUPTOSECURITYROLE
INNER JOIN DWSECURITYGROUPTOSECURITYUSER ON DWSECURITYGROUPTOSECURITYUSER.SECURITYGROUPID = DWSECURITYGROUPTOSECURITYROLE.SECURITYGROUPID;

CREATE OR REPLACE VIEW DWV_SECURITY_CHECKPERMISSIONUSER 
	AS
	SELECT DWV_SECURITY_USERROLE.USERID,
		SP.ID AS PERMISSIONID,
	    SPG.CODE AS PERMISSIONGROUPCODE,
	    SPG.NAME AS PERMISSIONGROUPNAME,
	    SP.CODE AS PERMISSIONCODE,
	    SP.NAME AS PERMISSIONNAME,
	    MAX(SRTOSP.ACCESSTYPE) AS ACCESSTYPE
	   FROM DWSECURITYPERMISSION SP
	     JOIN DWSECURITYPERMISSIONGROUP SPG ON SP.GROUPID = SPG.ID
	     JOIN DWSECURITYROLETOSECURITYPERMISSION SRTOSP ON SRTOSP.SECURITYPERMISSIONID = SP.ID
	     JOIN DWV_SECURITY_USERROLE ON DWV_SECURITY_USERROLE.ROLEID = SRTOSP.SECURITYROLEID
	   WHERE SRTOSP.ACCESSTYPE <> 0
	   GROUP BY DWV_SECURITY_USERROLE.USERID, SP.ID,SPG.CODE, SPG.NAME, SP.CODE, SP.NAME;

CREATE OR REPLACE VIEW DWV_SECURITY_CHECKPERMISSIONGROUP
	AS
	SELECT 
	SGTOSR.SECURITYGROUPID AS SECURITYGROUPID,
	SP.ID AS PERMISSIONID,
	SPG.CODE AS PERMISSIONGROUPCODE,
	SPG.NAME AS PERMISSIONGROUPNAME,
	SP.CODE AS PERMISSIONCODE,
	SP.NAME AS PERMISSIONNAME,
    MAX(SRTOSP.ACCESSTYPE) AS ACCESSTYPE
	FROM DWSECURITYPERMISSION SP 
	INNER JOIN DWSECURITYPERMISSIONGROUP SPG ON SP.GROUPID = SPG.ID
	INNER JOIN DWSECURITYROLETOSECURITYPERMISSION SRTOSP ON SRTOSP.SECURITYPERMISSIONID = SP.ID
	INNER JOIN DWSECURITYGROUPTOSECURITYROLE SGTOSR ON SGTOSR.SECURITYROLEID = SRTOSP.SECURITYROLEID
	WHERE SRTOSP.ACCESSTYPE <> 0
	GROUP BY SGTOSR.SECURITYGROUPID, SP.ID,SPG.CODE, SPG.NAME, SP.CODE, SP.NAME;

COMMIT;

CREATE OR REPLACE PACKAGE DWKIT AS 

    FUNCTION UPDATE_JSON_NUMBER(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN NUMBER) RETURN VARCHAR2;
    FUNCTION UPDATE_JSON_NVARCHAR2(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION UPDATE_JSON_CHAR(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN CHAR) RETURN VARCHAR2;
    FUNCTION UPDATE_JSON_BLOB(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN BLOB) RETURN VARCHAR2;
    FUNCTION UPDATE_JSON_RAW(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN RAW) RETURN VARCHAR2;
    FUNCTION UPDATE_JSON_DATE(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN DATE) RETURN VARCHAR2;
    FUNCTION UPDATE_JSON_FLOAT(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN FLOAT) RETURN VARCHAR2;
    
    
END DWKIT;
/

CREATE OR REPLACE PACKAGE BODY DWKIT AS 

    FUNCTION UPDATE_JSON_NUMBER(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN NUMBER)
        RETURN VARCHAR2 AS  
        jo JSON_OBJECT_T; 
    BEGIN
        jo := JSON_OBJECT_T(JSON_DOC);
        jo.put(parameter_name, new_value);
        RETURN jo.to_string();
    END UPDATE_JSON_NUMBER;
    
        FUNCTION UPDATE_JSON_FLOAT(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN FLOAT)
        RETURN VARCHAR2 AS  
        jo JSON_OBJECT_T; 
    BEGIN
        jo := JSON_OBJECT_T(JSON_DOC);
        jo.put(parameter_name, new_value);
        RETURN jo.to_string();
    END UPDATE_JSON_FLOAT;
   
    FUNCTION UPDATE_JSON_NVARCHAR2(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN VARCHAR2)
        RETURN VARCHAR2 AS  
        jo JSON_OBJECT_T; 
    BEGIN
        jo := JSON_OBJECT_T(JSON_DOC);
        jo.put(parameter_name, new_value);
        RETURN jo.to_string();
    END UPDATE_JSON_NVARCHAR2;
    

   FUNCTION UPDATE_JSON_CHAR(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN CHAR)
        RETURN VARCHAR2 AS  
        jo JSON_OBJECT_T; 
    BEGIN
        jo := JSON_OBJECT_T(JSON_DOC);
        jo.put(parameter_name, new_value);
        RETURN jo.to_string();
    END UPDATE_JSON_CHAR;
 
    FUNCTION UPDATE_JSON_DATE(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN DATE)
        RETURN VARCHAR2 AS  
        jo JSON_OBJECT_T; 
    BEGIN
        jo := JSON_OBJECT_T(JSON_DOC);
        jo.put(parameter_name, new_value);
        RETURN jo.to_string();
    END UPDATE_JSON_DATE;
    
    FUNCTION UPDATE_JSON_RAW(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN RAW)
        RETURN VARCHAR2 AS  
        jo JSON_OBJECT_T; 
    BEGIN
        jo := JSON_OBJECT_T(JSON_DOC);
        jo.put(parameter_name, RAWTOHEX(new_value));
        RETURN jo.to_string();
    END UPDATE_JSON_RAW;
    
    FUNCTION UPDATE_JSON_BLOB(JSON_DOC IN VARCHAR2, parameter_name IN VARCHAR2, new_value IN BLOB)
        RETURN VARCHAR2 AS  
        jo JSON_OBJECT_T; 
    BEGIN
        jo := JSON_OBJECT_T(JSON_DOC);
        jo.put(parameter_name, RAWTOHEX(new_value));
        RETURN jo.to_string();
    END UPDATE_JSON_BLOB;
    
END DWKIT;