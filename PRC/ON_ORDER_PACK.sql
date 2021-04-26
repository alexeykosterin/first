create procedure on_order_pack(PSUBS_ID   IN NUMBER,
                               PPACK_ID   IN NUMBER,
                               ORDER_DATE IN DATE) is
  P_END_DATE      date;
  P_OLD_END_DATE  date;
  P_START_DATE    date;
  P_SUBS_ID       NUMBER;
  P_PACK_ID       NUMBER;
  DATE_CORRECTION NUMBER(10, 8) := 0;
  BAD_END_DATE    number := 0;
  DATE_ERR        number := 0;
  DATE_ERR_EXCEPTION EXCEPTION;
  PRAGMA EXCEPTION_INIT(DATE_ERR_EXCEPTION, -20222);
begin
  P_SUBS_ID    := PSUBS_ID;
  P_PACK_ID    := PPACK_ID;
  P_START_DATE := ORDER_DATE;

  select END_DATE
    into P_END_DATE
    from SUBS_PACKS
   where SUBS_SUBS_ID = P_SUBS_ID
     and PACK_PACK_ID = P_PACK_ID
     and START_DATE = P_START_DATE;
  P_OLD_END_DATE := P_END_DATE;

  /* здесь выполняем код, который, возможно переопределяет P_START_DATE и P_END_DATE */


  IF (P_OLD_END_DATE = P_END_DATE) and (ORDER_DATE = P_START_DATE) then
  -- если даты действия пакета не переопределились - выходим
   return;
  end if;

  IF P_PACK_ID in (9999 /* ИД пакетов, для которых должна выполняться заявка в случае, если выдано подряд несколько пакетов*/)
     then
    DATE_CORRECTION := 1 / 86400;
  end if;

  SELECT COUNT(1)
    INTO BAD_END_DATE
    FROM SUBS_PACKS
   where SUBS_SUBS_ID = P_SUBS_ID
     and PACK_PACK_ID = P_PACK_ID
     and START_DATE <> ORDER_DATE
     and START_DATE > P_START_DATE
     and START_DATE <= P_END_DATE;


  if BAD_END_DATE > 0 then
  -- если есть пакет, у которого время начала действия попадает в период действия
  --  обрабатываемого пакета, корректируем окончание действия пакета
    select MIN(START_DATE) - DATE_CORRECTION
      INTO P_END_DATE
      FROM SUBS_PACKS
     where SUBS_SUBS_ID = P_SUBS_ID
       and PACK_PACK_ID = P_PACK_ID
       and START_DATE <> ORDER_DATE
       and START_DATE > P_START_DATE
       and START_DATE <= P_END_DATE;
  end if;


  -- проверяем, нет ли пакета, у которог время действия полностью перекрывает период P_START_DATE - P_END_DATE
  -- если есть - генерируем exption

  SELECT COUNT(1)
    INTO DATE_ERR
    FROM SUBS_PACKS
   where SUBS_SUBS_ID = P_SUBS_ID
     and PACK_PACK_ID = P_PACK_ID
     and START_DATE <> ORDER_DATE
     and START_DATE <= P_START_DATE
     and END_DATE >= P_END_DATE;

  if DATE_ERR > 0 then
    RAISE DATE_ERR_EXCEPTION;
  end if;




  -- если есть пакет, у которого время окончания действия попадает в период действия
  --  обрабатываемого пакета, корректируем окончание действия пакета

  update SUBS_PACKS
     set END_DATE = P_START_DATE  - DATE_CORRECTION
   where SUBS_SUBS_ID = P_SUBS_ID
     and PACK_PACK_ID = P_PACK_ID
     and START_DATE <> ORDER_DATE
     and END_DATE >= P_START_DATE
     and END_DATE < P_END_DATE;


  /* сохраняем изменеия */

  update SUBS_PACKS
     set START_DATE = P_START_DATE, END_DATE = P_END_DATE
   where SUBS_SUBS_ID = P_SUBS_ID
     and PACK_PACK_ID = P_PACK_ID
     and START_DATE = ORDER_DATE;

  /* здесь обрарбатываем exception*/

END;
