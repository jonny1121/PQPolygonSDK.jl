using testPQPolygonSDK #test package -ycpan
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
endpoint_options["ticker"] = "AAPL"
endpoint_options["execution_date"] = "N/A"
endpoint_options["reverse_split"] = "N/A"
endpoint_options["order"] = "desc"
endpoint_options["limit"] = "N/A"
endpoint_options["sort"] = "N/A"
endpoint_model = model(PolygonStockSplitsEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonStockSplitsEndpointModel, my_url_string)
