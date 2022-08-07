using PQPolygonSDK
using Dates
using DataFrames

# build a user model -
options = Dict{String,Any}()
options["email"] = "jvarner@paliquant.com"
options["apikey"] = "abc1234" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["adjusted"] = true
endpoint_options["sortdirection"] = "asc"
endpoint_options["limit"] = 5000
endpoint_options["to"] = Date(2022, 08, 05)
endpoint_options["from"] = Date(2022, 05, 07)
endpoint_options["multiplier"] = 1
endpoint_options["timespan"] = "day"
endpoint_options["ticker"] = "AMD"
endpoint_model = model(PolygonAggregatesEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonAggregatesEndpointModel, my_url_string)