import pandas as pd
import psycopg2
from datetime import datetime as dt
import seaborn as sns

def log_on():
    dsn = ""
    pyConn = psycopg2.connect(dsn)
    return pyConn
	
sql = 'select * from dev_amit.lga_crime_avg_with_poi'
pyConn = log_on()
cur = pyConn.cursor()
cur.execute(sql)

assault = pd.DataFrame(cur.fetchall(),columns = [x[0] for x in cur.description])
pyConn.close()

assault.crime_rate = assault.crime_rate.astype('float')
corr=assault.groupby('POITYPE')[['number_of_poi','crime_rate']].corr()
corr = corr.reset_index()[corr.reset_index().level_1 == 'crime_rate'][['POITYPE','number_of_poi']].set_index('POITYPE')
# plot the heatmap
corr.plot.bar(figsize = (20,10))

sns.lmplot(x='number_of_poi',y='crime_rate',data=assault[assault.POITYPE == 'Racecourse'],fit_reg=True) 

sql = 'select * from dev_amit.drug_offenses_lga_with_poi'
pyConn = log_on()
cur = pyConn.cursor()
cur.execute(sql)

offense = pd.DataFrame(cur.fetchall(),columns = [x[0] for x in cur.description])
pyConn.close()


offense.drug_offense_rate = offense.drug_offense_rate.astype('float')
corr=offense.groupby('POITYPE')[['number_of_poi','drug_offense_rate']].corr()
corr = corr.reset_index()[corr.reset_index().level_1 == 'drug_offense_rate'][['POITYPE','number_of_poi']].set_index('POITYPE')
# plot the heatmap
corr.plot.bar(figsize = (20,10))

sns.lmplot(x='number_of_poi',y='drug_offense_rate',data=offense[offense.POITYPE == 'Training Track'],fit_reg=True) 