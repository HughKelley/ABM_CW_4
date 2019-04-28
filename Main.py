# -*- coding: utf-8 -*-
"""
Created on Mon Apr 15 14:14:14 2019

@author: Hugh
"""

# script for working with netlogo output data

import pandas as pd

# relevant files are 
basic_1_most = "data/5_most_basic_1.csv"
basic_1_prox = "data/5_prox_basic_1.csv"
basic_1_perc = "data/5_perc_basic_1.csv"

basic_2_most = "data/5_most_basic_2.csv"
basic_2_prox = "data/5_prox_basic_2.csv"
basic_2_perc = "data/5_perc_basic_2.csv"

basic_1_most_data = pd.read_csv(basic_1_most, header = 6)
basic_1_prox_data = pd.read_csv(basic_1_prox, header = 6)
basic_1_perc_data = pd.read_csv(basic_1_perc, header = 6)

basic_2_most_data = pd.read_csv(basic_2_most, header = 6)
basic_2_prox_data = pd.read_csv(basic_2_prox, header = 6)
basic_2_perc_data = pd.read_csv(basic_2_perc, header = 6)


list(basic_1_most_data)

list_of_dfs = [basic_1_most_data, basic_1_prox_data, basic_1_perc_data, basic_2_most_data, basic_2_perc_data, basic_2_prox_data]

for df in list_of_dfs :
    
    df.columns = ['run_number','step_size','spaces','students','places','work-mean','step','time','total_occupants','total_spaces','work_finished','total_work']
    df['percentage_work_completed'] = df['work_finished'] / df['total_work'] * 100
    df['occupancy_rate'] = df['total_occupants'] / df['spaces'] * 100
    
    
# add different fucntion data to same dataframe
# for basic 1 trials    
    
# add function type
basic_1_most_data['type'] = "most"
basic_1_prox_data['type'] = "prox"
basic_1_perc_data['type'] = "perc"

all_data_1 = basic_1_most_data.set_index(['type', 'step_size','spaces','students','places','work-mean','time','total_occupants','total_spaces','work_finished','total_work']).groupby('run_number')['step'].nlargest(1).reset_index()
holder2 = basic_1_prox_data.set_index(['type', 'step_size','spaces','students','places','work-mean','time','total_occupants','total_spaces','work_finished','total_work']).groupby('run_number')['step'].nlargest(1).reset_index()
holder3 = basic_1_perc_data.set_index(['type', 'step_size','spaces','students','places','work-mean','time','total_occupants','total_spaces','work_finished','total_work']).groupby('run_number')['step'].nlargest(1).reset_index()

# append
all_data_1 = all_data_1.append([holder2, holder3])



# add different fucntion data to same dataframe
# for basic 2 trials    
    
# add function type

basic_2_most_data['type'] = "most"
basic_2_prox_data['type'] = "prox"
basic_2_perc_data['type'] = "perc"

all_data_2 = basic_2_most_data.set_index(['type', 'step_size','spaces','students','places','work-mean','time','total_occupants','total_spaces','work_finished','total_work']).groupby('run_number')['step'].nlargest(1).reset_index()
holder4 = basic_2_prox_data.set_index(['type', 'step_size','spaces','students','places','work-mean','time','total_occupants','total_spaces','work_finished','total_work']).groupby('run_number')['step'].nlargest(1).reset_index()
holder5 = basic_2_perc_data.set_index(['type', 'step_size','spaces','students','places','work-mean','time','total_occupants','total_spaces','work_finished','total_work']).groupby('run_number')['step'].nlargest(1).reset_index()

# append
all_data_2 = all_data_2.append([holder4, holder5])


#For both datafarmes get mean and std for ticks

basic_1_means = all_data_1.groupby(['type']).mean()
basic_2_means = all_data_2.groupby(['type']).mean()
basic_1_stds = all_data_1.groupby(['type']).std()
basic_2_stds = all_data_2.groupby(['type']).std()


basic_1_data = basic_1_means[['step', 'time', 'students', 'work_finished']]
basic_1_data['efficiency'] = basic_1_data['work_finished'] / (basic_1_data['students'] * basic_1_data['step'])



basic_1_stds['sqrt_n'] = (5.0)**0.5
basic_1_stds['crit_val'] = 1.533
basic_1_stds['ME'] = basic_1_stds['crit_val'] * basic_1_stds['step'] / basic_1_stds['sqrt_n']
    
# for basic 2


basic_2_data = basic_2_means[['step', 'time', 'students', 'work_finished']]
basic_2_data['efficiency'] = basic_2_data['work_finished'] / (basic_2_data['students'] * basic_2_data['step'])

basic_2_stds['sqrt_n'] = (5.0)**0.5
basic_2_stds['crit_val'] = 1.533
basic_2_stds['ME'] = basic_2_stds['crit_val'] * basic_2_stds['step'] / basic_2_stds['sqrt_n']
 





#import pandas as pd
#
## Create the pandas DataFrame 
#data_1 = [[1, 'tom', 10], [2, 'nick', 15], [3, 'juli', 14]] 
#data_2 = [[1, 'tom', 10], [2, 'nick', 15], [3, 'juli', 14]]  
#data_3 = [[1, 'tom', 10], [2, 'nick', 15], [3, 'juli', 14]]  
#  
#df_1 = pd.DataFrame(data_1, columns = ['number', 'Name', 'Age']) 
#df_2 = pd.DataFrame(data_2, columns = ['number', 'Name', 'Age']) 
#df_3 = pd.DataFrame(data_3, columns = ['number', 'Name', 'Age']) 
#
#df_1.set_index('number', inplace = True)
#df_2.set_index('number', inplace = True)
#df_3.set_index('number', inplace = True)
#
#df_list = [df_1, df_2, df_3]
#
#for df in df_list :
#    df.columns = ['New_name', 'New_Age']


















list(data)

data.columns = ['run_number', 'initial_people','num_infect','immune_chance','recovery_chance','step','infected_turtles','immune_turtles','total_turtles','sum_sicktime']
data['perc_infected'] = data['infected_turtles'] / data['total_turtles'] * 100
data['sicktime_per_turtle'] = data['sum_sicktime'] / (data['total_turtles'] - data['immune_turtles'])
data2 = data

values_50 = data.loc[data['step'] == 50]
values_50['sicktime_per_turtle_per_tick'] = values_50['sicktime_per_turtle'] / 100
values_50['perc_infected'].mean()
values_50['perc_infected'].std()

values_50['sicktime_per_turtle_per_tick'].mean()
values_50['sicktime_per_turtle_per_tick'].std()

values_100 = data.loc[data['step'] == 100]
values_250 = data.loc[data['step'] == 250]
values_150 = data.loc[data['step'] == 150]
values_500 = data.loc[data['step'] == 500]
values_400 = data.loc[data['step'] == 400]


ending_values = values_50
ending_mean = ending_values['perc_infected'].mean()
ending_std = ending_values['perc_infected'].std()

time_mean = ending_values['sicktime_per_turtle'].mean()
time_std = ending_values['sicktime_per_turtle'].std()


# calc margin of error

z = 1.96
t = 2.093 
n = 100
perc_s_e = ending_std/(n**0.5)
perc_margin_of_error = perc_s_e * z

time_s_e = time_std/(n**0.5)
time_margin_of_error = time_s_e * z

#grouped_data = data.groupby(['run_number'], as_index = False).mean()
data.set_index('step', inplace = True)

plot1 = data.groupby('run_number')['perc_infected'].plot()

# use plt.close() to clear plot
#baseline_plot_perc = grouped_data.groupby(['initial_people','num_infect'])['perc_infected'].plot(x ='ticks', y ='percent', title = 'Baseline Scenario % Infected', use_index = False)
#baseline_plot_time = grouped_data.groupby(['initial_people','num_infect'])['sum_sicktime'].plot(x ='ticks', y ='percent', title = 'Baseline Scenario Total Sick Time', use_index = False)


# now calculate confidence interval for mean of pop




# plot
#for key, group in grouped_baseline.groupby(['initial_people', 'num_infect']):
#    ax = group.plot(ax=ax, kind='line',x='step', y = 'perc_infected', c=key, label=key)

#plt.plot( 'x', 'y1', data=df, marker='o', markerfacecolor='blue', markersize=12, color='skyblue', linewidth=4)
#plt.plot( 'x', 'y2', data=df, marker='', color='olive', linewidth=2)
#plt.plot( 'x', 'y3', data=df, marker='', color='olive', linewidth=2, linestyle='dashed', label="toto")
#plt.legend()

#fig = plot.get_figure()
#fig.savefig("baseline_steady_state.png")





