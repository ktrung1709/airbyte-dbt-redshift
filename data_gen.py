import pandas as pd
from datetime import datetime

# Define the start and end dates
start_date = pd.to_datetime('2015-01-01')
end_date = pd.to_datetime(datetime.now())
print(end_date)
# Generate a sequence of dates from start_date to end_date
date_range = pd.date_range(start=start_date, end=end_date)

# Create a DataFrame from the date_range
df = pd.DataFrame(date_range, columns=['date'])

# Add a date_id column
df['date_id'] = df.index + 1

# Extract additional date components
df['year'] = df['date'].dt.year
df['quarter'] = df['date'].dt.quarter
df['month_num'] = df['date'].dt.month
df['month_name'] = df['date'].dt.month_name()
df['day_of_month'] = df['date'].dt.day
df['day_of_week'] = df['date'].dt.day_name()

# Print the DataFrame
print(df)
