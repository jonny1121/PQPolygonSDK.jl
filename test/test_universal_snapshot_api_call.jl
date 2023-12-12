using PQPolygonSDK
using Dates
using DataFrames

# build a user model -
options = Dict{String,Any}()
options["email"] = "js2879@cornell.edu"
options["apikey"] = "oBajrc4SgnVxnpNQz9FzAM85FH4pvuQB" # js2879 API key (free version)

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["ticker_any_of"] = ["AMD", "SPY"]
endpoint_options["type"] = "stocks"
endpoint_options["order"] = "asc"
endpoint_options["limit"] = 20
endpoint_options["sort"] = "ticker"
endpoint_model = model(PolygonStockUniversalSnapshot, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonStockUniversalSnapshot, my_url_string)