using testPQPolygonSDK
using Dates
using DataFrames

# build a user model -
options = Dict{String,Any}()
options["email"] = "yp392@cornell.edu"
options["apikey"] = "abc1234" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["asset_class"] = "stocks"
endpoint_options["data_type"] = "trade"
endpoint_options["id"] = "N/A"
endpoint_options["sip"] = "CTA"
endpoint_options["order"] = "asc"
endpoint_options["limit"] = "10"
endpoint_options["sort"] = "id"

endpoint_model = model(PolygonConditionsEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonConditionsEndpointModel, my_url_string)
