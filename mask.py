import pandas as pd
from sqlalchemy.engine import create_engine
from cryptography.fernet import Fernet
from sqlalchemy.types import String
from sqlalchemy import text
from datetime import datetime
import glob
import sys

pd.set_option('display.width', 1100)
pd.set_option('display.max_columns', 100)
pd.set_option('display.max_rows', 10)

# key = Fernet.generate_key() #this is your "password"
key = b"pass="
cipher_suite = Fernet(key)
# print(key)

env = 'prod'
# env = 'prod'

if env == 'dev':
    DIALECT = 'oracle'
    SQL_DRIVER = 'cx_oracle'
    USERNAME = 'test'
    PASSWORD = '12345'
    HOST = 'DESKTOP.net'
    PORT = 1521
    SERVICE = 'sgi.mshome.net'
    xlpath = '../Input_Dir/'
    MV_DWH_PDN_MASK_TABLE = 'test.mask_table'
    TEMP_TABLE = 'temp_table'
    MRG_TABLE = 'CONTRACTS_MERGED_PRODUCTS_SRC'
    IF_EXISTS = 'append'
    LOG_BEFORE_MASK_PATH = '../LOG/BEFORE'
    LOG_AFTER_MASK_PATH = '../LOG/AFTER'
else:
    DIALECT = 'oracle'
    SQL_DRIVER = 'cx_oracle'
    USERNAME = 'stg_dm'
    PASSWORD = 'qwerty!123'
    HOST = 'prod-dwh-db01.rb-ins.ru'
    PORT = 1521
    SERVICE = 'SGIDWH'
    xlpath = 'C:/DWH_Input_Agreements'
    MV_DWH_PDN_MASK_TABLE = 'STG_DM.mask_table'
    #MV_DWH_PDN_MASK_TABLE = 'installer.tmp_mask_table'
    TEMP_TABLE = 'cntr_mrg_prd_mask_tmp'
    MRG_TABLE = 'src06.CONTRACTS_MERGED_PRODUCTS_MRR'
    IF_EXISTS = 'replace'
    LOG_BEFORE_MASK_PATH = 'C:/DWH_Input_Agreements/MASK/LOG/BEFORE'
    LOG_AFTER_MASK_PATH = 'C:/DWH_Input_Agreements/MASK/LOG/AFTER'

ENGINE_PATH_WIN_AUTH = DIALECT + '+' + SQL_DRIVER + '://' + USERNAME + ':' + PASSWORD + '@' + HOST + ':' + str(
    PORT) + '/?service_name=' + SERVICE
engine = create_engine(ENGINE_PATH_WIN_AUTH)

date_cols = ['Birth date', 'Date of issuing Passport', 'Payment date', 'Vehicle: maintenance start date',
             'Vehicle: manufacturer warranty end date', 'Date of invoice for premium correction1',
             'Premium correction payment date1', 'Date of invoice for premium correction2',
             'Premium correction payment date2', 'Date of policy signing', 'Initial date of coverage start',
             'Initial term date of the policy', 'Actual date of coverage start', 'Actual term date of the policy',
             'Closing date',
             'Refund payment date',
             'Date of last modification',
             'Refund application date',
             'Refund payment posting date',
             'Premium payment posting date',
             'Premium accrual posting date',
             'Premium correction1 accrual posting date',
             'Premium correction1 payment posting date',
             'Premium correction2 accrual posting date',
             'Premium correction2 payment posting date',
             'PYMT_2_DATE',
             'PYMT_3_DATE',
             'PYMT_4_DATE',
             'PYMT_5_DATE',
             'PYMT_6_DATE',
             'PYMT_7_DATE',
             'PYMT_8_DATE',
             'PYMT_9_DATE',
             'PYMT_10_DATE',
             'PYMT_11_DATE',
             'PYMT_12_DATE',
             'SCHEDULE_PYMT_1_DT',
             'SCHEDULE_PYMT_2_DT',
             'SCHEDULE_PYMT_3_DT',
             'SCHEDULE_PYMT_4_DT',
             'SCHEDULE_PYMT_5_DT',
             'SCHEDULE_PYMT_6_DT',
             'SCHEDULE_PYMT_7_DT',
             'SCHEDULE_PYMT_8_DT',
             'SCHEDULE_PYMT_9_DT',
             'SCHEDULE_PYMT_10_DT',
             'SCHEDULE_PYMT_11_DT',
             'SCHEDULE_PYMT_12_DT',
             'PREM_PYMT_2_POSTING_DATE',
             'PREM_PYMT_3_POSTING_DATE',
             'PREM_PYMT_4_POSTING_DATE',
             'PREM_PYMT_5_POSTING_DATE',
             'PREM_PYMT_6_POSTING_DATE',
             'PREM_PYMT_7_POSTING_DATE',
             'PREM_PYMT_8_POSTING_DATE',
             'PREM_PYMT_9_POSTING_DATE',
             'PREM_PYMT_10_POSTING_DATE',
             'PREM_PYMT_11_POSTING_DATE',
             'PREM_PYMT_12_POSTING_DATE']

date_cols = [x.lower() for x in date_cols]


def encrypt_xl(path_in, path_out, column_list):
    excel_cm_df = pd.read_excel(path_in, dtype=str)
    excel_cm_df.columns = excel_cm_df.columns.str.lower()
    for dt in date_cols:
        excel_cm_df[dt] = pd.to_datetime(excel_cm_df[dt], format='mixed')
        excel_cm_df[dt] = excel_cm_df[dt].dt.strftime('%d.%m.%Y')
    sql = f'SELECT DISTINCT AGR_NUM AS "agreement number" FROM {MV_DWH_PDN_MASK_TABLE}'
    ag_need_mask_df = pd.read_sql_query(sql, engine)
    ag_need_mask_df['mask'] = 1
    excel_cm_df = pd.merge(excel_cm_df, ag_need_mask_df, on=['agreement number'], how='left')
    excel_cm_df = excel_cm_df.astype({'passport series': str, 'passport number': str})
    list_to_replace = ['passport series', 'passport number']
    excel_cm_df[list_to_replace] = excel_cm_df[list_to_replace].replace('nan', '')
    for cl in column_list:
        excel_cm_df[cl + '_o'] = excel_cm_df[cl]
        excel_cm_df[cl] = \
            excel_cm_df.apply(
                lambda x: cipher_suite.encrypt(x[cl].encode()).decode()
                if x['mask'] == 1 else x[cl], axis=1
            )
    table_col_list = list(column_list)
    for i in column_list:
        table_col_list.append(i + '_o')
    table_col_list.append('agreement number')
    table_col_list.append('birth date')
    table_col_list.append('gender')
    mask_filter = (excel_cm_df['mask'] == 1)
    excel_filtered_df = excel_cm_df[mask_filter]
    db_table_df = excel_filtered_df[table_col_list]
    if env == 'dev':
        sql = text(f'TRUNCATE TABLE {TEMP_TABLE}')
        with engine.connect() as conn:
            results = conn.execute(sql)
    db_table_df.to_sql(f'{TEMP_TABLE}', engine, if_exists=IF_EXISTS, index=False,
                       dtype={
                           'surname of the borrower': String(300),
                           'surname of the borrower_o': String(300),
                           'name of the borrower': String(300),
                           'name of the borrower_o': String(300),
                           'agreement number': String(50),
                           'patronymic of the borrower': String(300),
                           'patronymic of the borrower_o': String(300),
                           'passport series': String(300),
                           'passport series_o': String(300),
                           'passport number': String(300),
                           'passport number_o': String(300),
                           'birth date': String(100),
                           'gender': String(10)
                       }
                       )
    sql1 = text(f'''
        MERGE INTO {MRG_TABLE} s
        USING {TEMP_TABLE} t
        ON (s.AGREEMENT_NUMBER = t."agreement number")
        WHEN MATCHED THEN UPDATE
        SET s.SURNAME_OF_BORROWER = "surname of the borrower", s.NAME_OF_BORROWER  = t."name of the borrower",
        s.PATRONYMIC_OF_BORROWER = "patronymic of the borrower", s.PASSPORT_SERIES_ = "passport series", 
        s.PASSPORT_NUMBER = "passport number"
    ''')
    sql2 = text(f'''
update stg06.k_pty_fio_birthdt_passport kpfbp
set
    (surname_of_borrower, name_of_borrower, patronymic_of_borrower,
    PASSPORT_SERIES_, passport_number) = (
    select 
        dlt."surname of the borrower", dlt."name of the borrower", dlt."patronymic of the borrower",
        dlt."passport series", dlt."passport number"
    from {TEMP_TABLE} dlt
    where
            '-'||kpfbp.surname_of_borrower  = '-'||trim(dlt."surname of the borrower_o")
      and   '-'||trim(dlt."name of the borrower_o")       = '-'||kpfbp.name_of_borrower
      and   '-'||trim(dlt."patronymic of the borrower_o") = '-'||kpfbp.patronymic_of_borrower
      and   '-'||to_date(dlt."birth date", 'dd.mm.yyyy') = '-'||kpfbp.birth_date
      and   '-'||trim(dlt."passport series_o")       = '-'||kpfbp.PASSPORT_SERIES_
      and   '-'||trim(dlt."passport number_o")        = '-'||kpfbp.passport_number
      and   '-'||trim(dlt."GENDER")                 = '-'||kpfbp.gender        
)
where exists (
    select 1
    from {TEMP_TABLE} dlt
    where
            kpfbp.surname_of_borrower  = dlt."surname of the borrower_o"
      and   '-'||trim(dlt."name of the borrower_o")       = '-'||kpfbp.name_of_borrower
      and   '-'||trim(dlt."patronymic of the borrower_o") = '-'||kpfbp.patronymic_of_borrower
      and   '-'||to_date(dlt."birth date", 'dd.mm.yyyy') = '-'||kpfbp.birth_date
      and   '-'||trim(dlt."passport series_o")       = '-'||kpfbp.PASSPORT_SERIES_
      and   '-'||trim(dlt."passport number_o")        = '-'||kpfbp.passport_number
      and   '-'||trim(dlt."GENDER")                 = '-'||kpfbp.gender            
)
    ''')
    with engine.connect() as conn:
        results = conn.execute(sql1)
        if env == 'prod':
            results = conn.execute(sql2)
        drop_list = list()
        for i in column_list:
            drop_list.append(i + '_o')
        drop_list.append('mask')
        excel_cm_df = excel_cm_df.drop(columns=drop_list)
        excel_cm_df.to_excel(path_out, index=False)
        conn.commit()


def decrypt_xl(path_in, path_out, column_list):
    excel_cm_enc_df = pd.read_excel(path_in)
    excel_cm_enc_df = excel_cm_enc_df.astype({'passport series': str, 'passport number': str})
    for cl in column_list:
        excel_cm_enc_df[cl] = \
            excel_cm_enc_df[cl].apply(
                lambda x: cipher_suite.decrypt(x.encode()).decode()
                if x[:6] == 'gAAAAA' else x  # decrypt only encrypted content
            )
    excel_cm_enc_df.to_excel(path_out, index=False)


def gen_log_before_mask():
    sql = f'SELECT * FROM {MV_DWH_PDN_MASK_TABLE} where rownum <= 100'
    log_before_df = pd.read_sql_query(sql, engine)
    log_path = f'{LOG_BEFORE_MASK_PATH}/log_before_mask_{datetime.today().strftime("%Y.%m.%d")}.xlsx'
    log_before_df.to_excel(log_path, index=False)
    print(f'Before log saved to {log_path}')


def gen_log_after_mask():
    sql = f'''
        select mv.* 
        from {MV_DWH_PDN_MASK_TABLE} mv
        inner join {TEMP_TABLE} src on src."agreement number" = mv.AGR_NUM
        where rownum <= 100
    '''
    log_after_df = pd.read_sql_query(sql, engine)
    log_path = f'{LOG_AFTER_MASK_PATH}/log_after_mask_{datetime.today().strftime("%Y.%m.%d")}.xlsx'
    print(log_path)
    log_after_df.to_excel(log_path, index=False)
    print(f'After log saved to {log_path}')


if __name__ == "__main__":
    gen_log_before_mask()

    column_list = ['surname of the borrower', 'name of the borrower', 'patronymic of the borrower', 'passport series',
                   'passport number']
    if env == 'dev':
        file_pattern = 'Contracts_Merged_Products_26092023.xlsx'
    else:
        file_pattern = 'Contracts_Merged_Products_*.xlsx'
    for fname in glob.glob(f'{xlpath}/{file_pattern}'):
        print(f'processing {fname}...')
        path_out = fname if env == 'prod' else fname + '.encrypted.xlsx'
        encrypt_xl(fname, path_out, column_list)
        # decrypt_xl(fname, fname+'.decrypted.xlsx', column_list)
        print(f'{fname} processed!')

    gen_log_after_mask()


