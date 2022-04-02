import pandas as pd
import time

url = "https://www.4sport-live.com/results/home2/?event=3429&lan=H&clean=3&gc=0&page="

new_df = {}
def collect_table (num):
    dfs = []
    dfs = pd.read_html(url + str(num))
    new_df[num] = dfs[0]
    print(num)
    time.sleep(1)
    
pd.Series(range(10,40)).apply(collect_table)

dat = pd.concat(new_df.values(), ignore_index=True)

dat.to_csv('runner.csv',  encoding='utf-8')

print("script complete")

# for i in range (20):
#     print(i)
    