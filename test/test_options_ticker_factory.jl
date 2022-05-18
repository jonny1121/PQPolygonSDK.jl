using PQPolygonSDK
using Dates

# First build an options contract model -
contract_model_options = Dict{String,Any}()
contract_model_options["underlying"] = "MU"
contract_model_options["expiration"] = Date(2022, 09, 16)
contract_model_options["strike"] = 55.0
put_contract_model = model(PolygonPutOptionContractModel, contract_model_options)

# what is the ticker symbol for this option?
options_ticker = ticker(put_contract_model)

# ok, now that we have the options ticker, let's do a hit to see some data -
# build a user model -
options = Dict{String,Any}()
options["email"] = "jvarner@paliquant.com"
options["apikey"] = "abc123" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["adjusted"] = true
endpoint_options["sortdirection"] = "asc"
endpoint_options["limit"] = 5000
endpoint_options["to"] = Date(2022, 05, 18)
endpoint_options["from"] = Date(2022, 05, 18)
endpoint_options["multiplier"] = 5
endpoint_options["timespan"] = "minute"
endpoint_options["ticker"] = options_ticker
endpoint_model = model(PolygonAggregatesEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonAggregatesEndpointModel, my_url_string)
