
:: ���� � �������
Set file=C:\Users\A.Kosterin\Desktop\SPOOL\temp.txt

For /F "usebackq tokens=* delims=" %%q In ("%file%") Do Set var=%%q

:: ������ ���������� � ���� ��� ��������
echo %var% > C:\Users\A.Kosterin\Desktop\SPOOL\test.txt
