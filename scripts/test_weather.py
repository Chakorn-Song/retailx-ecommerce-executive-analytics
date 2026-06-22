# Minimal test script to verify meteostat functionality isolated from database
from datetime import datetime

try:
    from meteostat import Point, Daily
    print("Success: Imported Point and Daily from meteostat.")
    
    # Set a test timeframe
    start = datetime(2018, 1, 1)
    end = datetime(2018, 1, 7)
    
    # Test location for Sao Paulo
    location = Point(-23.55, -46.63)
    
    print("Attempting to fetch data...")
    # Fetch data
    data = Daily(location, start, end)
    data = data.fetch()
    
    if not data.empty:
        print("Success: Weather data fetched correctly!")
        print("-" * 30)
        print(data[['tavg', 'prcp']].head())
    else:
        print("Warning: API returned empty data.")
        
except ImportError as e:
    print(f"Error: {e}")
    print("Action required: Your Python environment does not have the correct meteostat version.")
except Exception as e:
    print(f"An unexpected error occurred: {e}")