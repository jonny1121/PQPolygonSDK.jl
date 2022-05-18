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
options["apikey"] = "t9aBscv_R5BGecynbrcTi7vnD5rSxt1I" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# build the endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["underlying"] = "MU"
endpoint_options["ticker"] = options_ticker
endpoint_model = model(PolygonOptionsSnapshotEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonOptionsSnapshotEndpointModel, my_url_string)