CREATE TRIGGER BI_SUBS_PACKS_CHECK_END_DATE
  BEFORE INSERT ON SUBS_PACKS
  FOR EACH ROW
BEGIN
  IF :NEW.PACK_PACK_ID in (9999 /* ИД пакетов, для которых должна выполняться заявка в случае, если выдано подряд несколько пакетов*/) THEN
    UPDATE SUBS_PACKS SP
       SET SP.END_DATE = SP.END_DATE - 1 / 86400
     where SP.SUBS_SUBS_ID = :NEW.SUBS_SUBS_ID 
           and SP.PACK_PACK_ID = :NEW.PACK_PACK_ID
           and sp.END_DATE = :NEW.START_DATE;
  END IF;
END BI_SUBS_PACKS_CHECK_END_DATE;