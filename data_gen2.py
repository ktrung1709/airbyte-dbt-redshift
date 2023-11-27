import pandas as pd

# Define the time slots
time_slots = []
for hour in range(1, 13):
    for minute in range(0, 60):
        time_slots.append({'time_id': len(time_slots) + 1,
                           'hour': hour,
                           'minute': minute,
                           'time_am_or_pm': 'AM' if hour < 12 else 'PM'})

# Create the DataFrame
df = pd.DataFrame(time_slots)

# Display the DataFrame
print(df)