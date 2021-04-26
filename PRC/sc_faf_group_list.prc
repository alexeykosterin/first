create or replace procedure sc_faf_group_list(
  p_subs_id        in  subscribers.subs_id%type,
  p_clnt_id        in  clients.clnt_id%type,
  p_faf_group_list out faf_group_ids_nst
)
is
  --
  ---@ SCC
  --
  -- Copyright (c) CJSC PETER-SERVICE, 2009.
  --
  -- Øàáëîí ïîëüçîâàòåëüñêîé ïğîöåäóğû, â êîòîğîé îïğåäåëÿåòñÿ ñïèñîê FAF-ãğóïï,
  -- äîñòóïíûõ àáîíåíòó.
  --
  -- Èìÿ ïğîöåäóğû óêàçûâàåòñÿ â ïàğàìåòğå 51030276 (PRMT_FAF_GROUP_LIST_PP).
  --
  -- Äëÿ ğàáîòîñïîñîáíîñòè ïğîöåäóğû íåîáõîäèìî, ÷òîáû áûëè ñîçäàíû òèïû:
  -- faf_group_ids_typ, faf_group_ids_nst.
  --
  -- Îáúåêò äëÿ õğàíåíèÿ èäåíòèôèêàòîğîâ FAF-ãğóïïû:
  -- create type faf_group_ids_typ as object(
  --   faft_id number(10), -- èäåíòèôèêàòîğ òèïà FAF-ãğóïïû
  --   fmth_id number(10)  -- èäåíòèôèêàòîğ òèïà ìåòîäà ğàñ÷åòà êîıôôèöèåíòîâ FAF
  -- )
  -- /
  --
  -- Òàáëèöà îáúåêòîâ äëÿ õğàíåíèÿ èäåíòèôèêàòîğîâ FAF-ãğóïï:
  -- create type faf_group_ids_nst as table of faf_group_ids_typ
  -- /
  --
  -- Åñëè äîñòóïíûõ àáîíåíòó FAF-ãğóïï íåò, òî ñïèñîê FAF-ãğóïï ìîæåò íå
  -- çàäàâàòüñÿ èëè èíèöèàëèçèğîâàòüñÿ ïóñòûì íàáîğîì.
  --
  -- Äëÿ êàæäîãî ıëåìåíòà êîëëåêöèè:
  -- èäåíòèôèêàòîğû òèïà FAF è ìåòîäà ğàñ÷åòà (ïîëÿ faft_id, fmth_id) äîëæíû
  -- îáÿçàòåëüíî çàäàâàòüñÿ.
  --
  -- Âõîäíûå ïàğàìåòğû:
  --   p_subs_id        - èäåíòèôèêàòîğ àáîíåíòà;
  --   p_clnt_id        - èäåíòèôèêàòîğ êëèåíòà.
  --
  -- Âûõîäíûå ïàğàìåòğû:
  --   p_faf_group_list - ñïèñîê äîñòóïíûõ FAF-ãğóïï.
begin
  -- Ïîëüçîâàòåëüñêîå îïğåäåëåíèå ñïèñêà äîñòóïíûõ FAF-ãğóïï
  --
  --Ïğèìåğ èíèöèàëèçàöèè êîëëåêöèè ñïèñêà äîñòóïíûõ FAF-ãğóïï
   p_faf_group_list := faf_group_ids_nst(
     --faf_group_ids_typ(faft_id => 1,fmth_id => 1),
faf_group_ids_typ(faft_id => 1,fmth_id => 2)
/*faf_group_ids_typ(faft_id => 2,fmth_id => 1),
faf_group_ids_typ(faft_id => 2,fmth_id => 2),
faf_group_ids_typ(faft_id => 3,fmth_id => 1),
faf_group_ids_typ(faft_id => 3,fmth_id => 2),
faf_group_ids_typ(faft_id => 4,fmth_id => 1),
faf_group_ids_typ(faft_id => 4,fmth_id => 2),
faf_group_ids_typ(faft_id => 5,fmth_id => 1),
faf_group_ids_typ(faft_id => 5,fmth_id => 2),
faf_group_ids_typ(faft_id => 6,fmth_id => 1),
faf_group_ids_typ(faft_id => 6,fmth_id => 2),
faf_group_ids_typ(faft_id => 7,fmth_id => 1),
faf_group_ids_typ(faft_id => 7,fmth_id => 2),
faf_group_ids_typ(faft_id => 8,fmth_id => 1),
faf_group_ids_typ(faft_id => 8,fmth_id => 2),
faf_group_ids_typ(faft_id => 9,fmth_id => 1),*/
  -- faft_id => 9, Ïóíêò ìåíş - ïåğâûé íîìåğ
--faf_group_ids_typ(faft_id => 9,fmth_id => 2),
--faf_group_ids_typ(faft_id => 10,fmth_id => 1),
--faf_group_ids_typ(faft_id => 10,fmth_id => 2)
   );

  -- Ïî óìîë÷àíèş îïğåäåëÿåì 1 ıëåìåíò ñ òèïîì FAF-ãğóïïû ?Ëşáèìûå íîìåğà?
  -- (faft_id = 2) è ìåòîäîì ğàñ÷åòà ?Ïî ñğåäíåìó? (fmth_id = 1)
  --p_faf_group_list := faf_group_ids_nst(
   -- faf_group_ids_typ(
    --  faft_id => 2,
   --   fmth_id => 1
   -- )
  --);
end;
/
