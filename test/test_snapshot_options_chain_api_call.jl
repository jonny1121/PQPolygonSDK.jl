using PQPolygonSDK
using Dates

# build a user model -
options = Dict{String,Any}()
options["email"] = "jvarner@paliquant.com"
options["apikey"] = "abc123" # do _not_ check in a real API key 

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
# underlyingAsset::String
# contract_type::Union{Nothing, String}
# expiration_date::Union{Nothing, Date}
# strike_price::Union{Nothing, Float64}
# order::Union{Nothing, String}
# limit::Union{Nothing, Int}
# sort::Union{Nothing, String}
endpoint_options = Dict{String, Any}()
endpoint_options["underlyingAsset"] = contract_model_options["underlying"];
endpoint_options["contract_type"] = nothing
endpoint_options["expiration_date"] = nothing
endpoint_options["strike_price"] = nothing
endpoint_options["order"] = "desc"
endpoint_options["limit"] = 200
endpoint_options["sort"] = nothing
endpoint_model = model(PolygonOptionsChainSnapshotEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonOptionsChainSnapshotEndpointModel, my_url_string)