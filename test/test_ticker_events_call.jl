using PQPolygonSDK # js2879
using Dates
using DataFrames

# build a user model -
options = Dict{String,Any}()
options["email"] = "js2879@cornell.edu"
options["apikey"] = "abc1234" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["id"] = "META"
endpoint_options["types"] = ["ticker_change"]

endpoint_model = model(PolygonTickerEvents, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonTickerEvents, my_url_string)
