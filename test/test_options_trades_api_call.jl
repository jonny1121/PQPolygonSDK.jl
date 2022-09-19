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
# First build an options contract model -
contract_model_options = Dict{String,Any}()
contract_model_options["underlying"] = "AMD"
contract_model_options["expiration"] = Date(2022, 10, 28)
contract_model_options["strike"] = 70.0
put_contract_model = model(PolygonPutOptionContractModel, contract_model_options)

# what is the ticker symbol for this option?
options_ticker = ticker(put_contract_model)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["ticker"] = options_ticker
endpoint_options["order"] = nothing
endpoint_options["timestamp"] = Date(2022, 09, 15)
endpoint_options["sort"] = nothing
endpoint_options["limit"] = 10000
endpoint_model = model(PolygonOptionsTradesEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonOptionsTradesEndpointModel, my_url_string);

# show -
nothing;