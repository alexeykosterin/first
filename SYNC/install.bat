SQLPLUS "bis/employer@ALPHA" @create_work_table.sql
C:\oracle\Kosterin\product\12.1.0\client_1\BIN\sqlldr.exe userid=BIS/employer@ALPHA ERRORS=0 control=loader_mth_tarif_histories.ctl
SQLPLUS "bis/employer@ALPHA" @merge_mth_tarif_histories.sql