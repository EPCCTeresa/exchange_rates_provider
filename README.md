# Exchange Rate API

This is a simple Rails API that fetches exchange rates from the Czech National Bank (CNB) and exposes them through a RESTful endpoint.

## **Setup**

### **Prerequisites**

Before you can run this application, ensure that you have the following installed:

- Ruby (preferably 3.2 or above)
- Rails (preferably 7 or above)
- SQLite3 (or your preferred database)
- Git (for version control)

### **Installation**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/exchange_rate_api.git
   cd exchange_rate_api
   
2. **Install dependencies**:
   ```bash
   bundle install

3. **Run the server**:
   ```bash
   rails server


## API Endpoints
### GET /exchange_rates

## Development
If you would like to contribute or run the application locally for development:

Run tests:
```
bin/rails rspec
```

## Next Steps
- Implement logic to fetch exchange rates from the CNB API.
- Develop additional features like rate caching or querying exchange rates by currency code.
- Add error handling for failed CNB API requests.