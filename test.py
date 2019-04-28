# -*- coding: utf-8 -*-
"""
Created on Sat Apr 27 21:17:45 2019

@author: Hugh
"""

# libraries
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
 
# Data
df=pd.DataFrame({'x': range(1,11), 'y1': np.random.randn(10), 'y2': np.random.randn(10)+range(1,11), 'y3': np.random.randn(10)+range(11,21) })
 
# multiple line plot
plt.plot( 'x', 'y1', data=df, marker='o', markerfacecolor='blue', markersize=12, color='skyblue', linewidth=4)
plt.plot( 'x', 'y2', data=df, marker='', color='olive', linewidth=2)
plt.plot( 'x', 'y3', data=df, marker='', color='olive', linewidth=2, linestyle='dashed', label="toto")
plt.legend()












######################################################
#with error bars

import numpy as np
import matplotlib.pyplot as plt

# example data
x = np.arange(0.1, 4, 0.5)
y_1 = np.exp(-x)
y_2 = np.exp(-x) + 2
y_3 = np.exp(-x) + 3

# example error bar values that vary with x-position
error_1 = 0.1 + 0.2 * x
error_2 = 0.1 + 0.2 * x
error_3 = 0.1 + 0.2 * x


fig, (ax0, ax1) = plt.subplots(nrows=2, sharex=True)
ax0.errorbar(x, y_1, yerr=error_1, fmt='-o')
ax0.set_title('variable, symmetric error')

# error bar values w/ different -/+ errors that
# also vary with the x-position
lower_error = 0.4 * error_1
upper_error = error_1
asymmetric_error = [lower_error, upper_error]

ax1.errorbar(x, y_1, xerr=asymmetric_error, fmt='o')
ax1.set_title('variable, asymmetric error')
ax1.set_yscale('log')
plt.show()