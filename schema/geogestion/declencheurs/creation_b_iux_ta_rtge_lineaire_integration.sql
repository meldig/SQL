-------------------------------------------------
-- CREATION_B_IUX_TA_RTGE_LINEAIRE_INTEGRATION --
-------------------------------------------------

-- 1. Création du trigger B_IUX_TA_RTGE_LINEAIRE_INTEGRATION

CREATE OR REPLACE TRIGGER G_GESTIONGEO.B_IUX_TA_RTGE_LINEAIRE_INTEGRATION
BEFORE INSERT OR UPDATE ON TA_RTGE_LINEAIRE_INTEGRATION FOR EACH ROW
DECLARE
USERNAME VARCHAR(30);
USERNUMBER NUMBER(38,0);
VMESSAGE VARCHAR2(32000);
REQ VARCHAR2(255);

BEGIN
SELECT SYS_CONTEXT('USERENV','OS_USER') INTO USERNAME FROM DUAL;
SELECT OBJECTID INTO USERNUMBER FROM G_GESTIONGEO.TA_GG_AGENT WHERE PNOM = USERNAME;

    IF INSERTING THEN

        IF USERNAME = 'www-data' THEN
            :new.DATE_CREATION:=sysdate;        
            :new.FID_PNOM_MODIFICATION:='';
            :new.DATE_MODIFICATION:='';
        ELSE
            IF USERNAME <> 'www-data' THEN
                :new.FID_PNOM_CREATION:=usernumber;
                :new.DATE_CREATION:=sysdate;        
                :new.FID_PNOM_MODIFICATION:='';
                :new.DATE_MODIFICATION:='';
            END IF;
        END IF;
    END IF;

    IF UPDATING then
        :new.FID_PNOM_MODIFICATION:=usernumber;
        :new.DATE_MODIFICATION:=sysdate;
    END IF;

   EXCEPTION

  WHEN OTHERS THEN 
    VMESSAGE := VMESSAGE||' '||SQLERRM||' '|| chr(10) || 'Le trigger B_IUX_TA_RTGE_LINEAIRE_INTEGRATION rencontre des problèmes par '||username;
    mail.sendmail('rjault@lillemetropole.fr',VMESSAGE,'Souci Le trigger B_IUX_TA_RTGE_LINEAIRE_INTEGRATION ','rjault@lillemetropole.fr') ;
END;



/
