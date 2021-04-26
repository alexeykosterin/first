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
  -- ������ ���������������� ���������, � ������� ������������ ������ FAF-�����,
  -- ��������� ��������.
  --
  -- ��� ��������� ����������� � ��������� 51030276 (PRMT_FAF_GROUP_LIST_PP).
  --
  -- ��� ����������������� ��������� ����������, ����� ���� ������� ����:
  -- faf_group_ids_typ, faf_group_ids_nst.
  --
  -- ������ ��� �������� ��������������� FAF-������:
  -- create type faf_group_ids_typ as object(
  --   faft_id number(10), -- ������������� ���� FAF-������
  --   fmth_id number(10)  -- ������������� ���� ������ ������� ������������� FAF
  -- )
  -- /
  --
  -- ������� �������� ��� �������� ��������������� FAF-�����:
  -- create type faf_group_ids_nst as table of faf_group_ids_typ
  -- /
  --
  -- ���� ��������� �������� FAF-����� ���, �� ������ FAF-����� ����� ��
  -- ���������� ��� ������������������ ������ �������.
  --
  -- ��� ������� �������� ���������:
  -- �������������� ���� FAF � ������ ������� (���� faft_id, fmth_id) ������
  -- ����������� ����������.
  --
  -- ������� ���������:
  --   p_subs_id        - ������������� ��������;
  --   p_clnt_id        - ������������� �������.
  --
  -- �������� ���������:
  --   p_faf_group_list - ������ ��������� FAF-�����.
begin
  -- ���������������� ����������� ������ ��������� FAF-�����
  --
  --������ ������������� ��������� ������ ��������� FAF-�����
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
  -- faft_id => 9, ����� ���� - ������ �����
--faf_group_ids_typ(faft_id => 9,fmth_id => 2),
--faf_group_ids_typ(faft_id => 10,fmth_id => 1),
--faf_group_ids_typ(faft_id => 10,fmth_id => 2)
   );

  -- �� ��������� ���������� 1 ������� � ����� FAF-������ ?������� ������?
  -- (faft_id = 2) � ������� ������� ?�� ��������? (fmth_id = 1)
  --p_faf_group_list := faf_group_ids_nst(
   -- faf_group_ids_typ(
    --  faft_id => 2,
   --   fmth_id => 1
   -- )
  --);
end;
/
