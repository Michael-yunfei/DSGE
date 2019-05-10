# Python code for getting and tidying the data series

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os  # the function for chaning working directory path
from datetime import date
import pandas_datareader as pdr

os.getcwd()
os.chdir('/Users/Michael/Documents/ComEco/DSGE')

# get US Quarterly GDP

start = date(1948, 1, 1)
end = date(2010, 12, 31)
usgdp = pdr.get_data_fred('GDPC1', start, end)
# Units: Billions of Chained 2012 Dollars, Seasonally Adjusted Annual Rate
usgdp.head()
usgdp.reset_index()
usgdp.shape
usgdp.columns
usgdp.index
type(usgdp)  # pandas.core.frame.DataFrame
gdpplot = sns.lineplot(x=usgdp.index, y=usgdp['GDPC1'], data=usgdp)

np.std(usgdp)
lngdp = np.log(usgdp['GDPC1'])
np.std(lngdp)
