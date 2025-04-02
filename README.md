# Exchange Rate API

This Ruby on Rails application exposes exchange rates for various countries, fetching data from the Czech National Bank (CNB) API and caching the results. It also allows users to request exchange rates for a specific country.


## **Setup**

### **Prerequisites**

Before you can run this application, ensure that you have the following installed:

- Ruby 3.2
- Rails 8.0.2
- Git (for version control)

## Installing Ruby and RVM

To set up the development environment for this project, it's recommended to use **Ruby** version `3.2` or newer and manage it with **RVM** (Ruby Version Manager).

### Step 1: Install RVM (Ruby Version Manager)

RVM allows you to easily install and manage Ruby versions on your system. To install RVM, follow these steps:

1. Install RVM by running the following command:
    ```
    \curl -sSL https://get.rvm.io | bash -s stable
    ```

2. After the installation completes, you need to source the RVM script. You can do this by running:
    ```
    source ~/.rvm/scripts/rvm
    ```

3. Verify the installation:
    ```
    rvm --version
    ```

### Step 2: Install Ruby

Once RVM is installed, use it to install the required Ruby version for the project.

1. Install Ruby version `3.x` (recommended version for this project):
    ```
    rvm install 3.x
    ```

2. Set Ruby 3.x as the default version:
    ```
    rvm use 3.x --default
    ```

3. Verify the Ruby installation:
    ```
    ruby -v
    ```

    You should see an output like:
    ```
    ruby 3.x.x (202x-xx-xx) [x86_64_


## **Installing the project**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/EPCCTeresa/exchange_rate_api.git
   cd exchange_rate_api
   
2. **Install dependencies**:
   ```bash
   bundle install

3. **Run the server**:
   ```bash
   rails server

## Development
- If you would like to run the application locally for development:

   - Run tests:
   ```
   bin/rails rspec
   ```

   - To run specific tests, use:
   ```
   bundle exec rspec spec/controllers/exchange_rates_controller_spec.rb
   ```


## API Usage

### Endpoints

- `GET /exchange_rates`: Returns all available exchange rates for all countries.  
  **Example Response:**
  ```json
  {
    "USA": 23.127,
    "EUR": 24.955,
    "United Kingdom": 29.89
  }
  ```

- `GET /exchange_rates/:country`: Returns the exchange rate for a specific country. Replace :country with the desired 
**Example Request:**
```
GET /exchange_rates/USA
```
**Example Response:**
```
23.127
```

### Handling Country Names
#### Country Name Format
When providing the country name in the URL, the country name should be written with underscores instead of spaces.

**Example:**
For "United Kingdom", use united_kingdom in the URL:
```
/exchange_rates/united_kingdom
```

#### Case-Insensitive Matching
- The API is case-insensitive and will match country names regardless of whether you use lowercase, uppercase, or mixed case.

   **Examples:**
   - The following all match "United Kingdom":
   ```
   /exchange_rates/united_kingdom
   /exchange_rates/UNITED_KINGDOM
   /exchange_rates/UnItEd_KinGdoM
   ```
   - Note: The API normalizes both the input and the available country names, making it flexible for users.

## Error Handling
The application includes robust error handling to ensure that users get meaningful error messages when something goes wrong.

### Country Not Found
- If the country provided by the user is not available in the fetched exchange rates, the API will respond with a 422 Unprocessable Entity status code and an error message.

### Client Errors (CnbExchangeRateError)
- **CnbExchangeRateError:** This custom error is raised in the Clients::CnbExchangeRates class when there’s an issue fetching exchange rates from the CNB API. This could happen due to network failures, API response issues, or other external errors.

   - **Example Error Response (from client):**

   ```
   {
   "error": "Error fetching exchange rates from CNB: <response_message>"
   }
   ```

- Unexpected Client Errors: If there is an unexpected error (e.g., a parsing issue, or a network error), it is caught and raised as a CnbExchangeRateError with a message indicating the type of error.

   - **Example Error Response (unexpected general or client error):**

   ```
   {
   "error": "Unexpected error: <error_message>"
   }
   ```

## Tech Decisions

### Caching Exchange Rates
- **Why Caching?** The exchange rates are fetched from an external API (Czech National Bank's API). To avoid repeated external requests and improve performance, the exchange rates are cached for one hour in Rails' cache. If the cache expires, the exchange rates are refetched from the external API.
  
- **Technical Decision:** The caching mechanism is implemented using Rails' built-in cache, which stores the fetched exchange rates and serves them to the user until they expire. 

### Country Name Normalization
- **Why Normalization?** Country names can come in various formats. For example, "United Kingdom" can be written as "united kingdom", "UNITED KINGDOM", or "United_Kingdom". We normalize the country names to handle case-insensitive and underscore-separated names.
  
- **Technical Decision:** The country names provided by the user are normalized by converting them to lowercase and replacing underscores with spaces. This ensures that the application can match the provided country name with the one available in the exchange rates data.

### Error Handling
- **Why Custom Errors?** A custom error (`CnbExchangeRateServiceError`) is raised when something goes wrong in the service (e.g., a country is not found or there is an issue with fetching the exchange rates). This provides a more meaningful and specific error message for the user.

- **Technical Decision:** In the controller, we catch this error and return a JSON response with the error message and an HTTP status code of `unprocessable_entity` (422). This informs the user about the problem clearly.



