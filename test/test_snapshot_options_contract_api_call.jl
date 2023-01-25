using PQPolygonSDK
using Dates

# build a user model -
options = Dict{String,Any}()
options["email"] = "jvarner@paliquant.com"
options["apikey"] = "t9aBscv_R5BGecynbrcTi7vnD5rSxt1I" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# First build an options contract model -
contract_model_options = Dict{String,Any}()
contract_model_options["underlying"] = "AMD"
contract_model_options["expiration"] = Date(2023, 06, 16)
contract_model_options["strike"] = 85.0
call_contract_model = model(PolygonCallOptionContractModel, contract_model_options)

# what is the ticker symbol for this option?
call_options_ticker = ticker(call_contract_model)

# setup snapshot call -
endpoint_options = Dict{String, Any}()
endpoint_options["underlyingAsset"] = contract_model_options["underlying"];
endpoint_options["ticker"] = call_options_ticker
endpoint_model = model(PolygonOptionsContractSnapshotEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonOptionsContractSnapshotEndpointModel, my_url_string)