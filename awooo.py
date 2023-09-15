SELECT 
  element.description
FROM 
  "db_corp_identificacaoeautenticacaodeclientes_customeriam_sor_01"."tb_fido",
  UNNEST(txt_objt_chav_pubi.nom_idef_mtdo.device_properties) AS t(element)
WHERE 
  anomesdia = 20230914 
  AND length(nom_usua_cada_crdl) > 9;
