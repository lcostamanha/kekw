SELECT DISTINCT 
    nom_usua_cada_crdl as original, 
    substring(nom_usua_cada_crdl, 1, 4) as agencia, 
    substring(nom_usua_cada_crdl, 5, 5) as conta,
    substring(nom_usua_cada_crdl, 10, 1) as dac 
FROM "db_corp_identificacaoeautenticacaodeclientes_customeriam_sor_01"."tb_fido" 
WHERE 
    anomesdia = 20230914 
    AND length(nom_usua_cada_crdl) > 9
    AND SUBSTRING(txt_objt_chav_pubi.txt_objt_idef_chav.txt_idef_chav, LENGTH(txt_objt_chav_pubi.txt_objt_idef_chav.txt_idef_chav) - 3, 4) != 'AAAA';
