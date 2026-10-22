I sent a GET request to https://api.mfapi.in/mf/125497 using Postman. The status was 200 OK.
The JSON has meta (fund house, scheme name, code) and data (dates and NAV values).
live_nav_fetch.py downloads the data with Python’s requests library and saves it as a CSV.
Code 125497 is SBI Small Cap Direct. The capstone brief said HDFC Top 100, so I corrected the label.