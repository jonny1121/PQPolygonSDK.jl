using PQPolygonSDK
using Dates
using DataFrames

# build a user model -
options = Dict{String,Any}()
options["email"] = "jvarner@paliquant.com"
options["apikey"] = "abc123" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["ticker"] = "AMD"
endpoint_options["order"] = nothing
endpoint_options["timestamp"] = Date(2022, 08, 04)
endpoint_options["sort"] = nothing
endpoint_options["limit"] = 100
endpoint_model = model(PolygonStockTradesEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonStockTradesEndpointModel, my_url_string);

# show -
nothing;
