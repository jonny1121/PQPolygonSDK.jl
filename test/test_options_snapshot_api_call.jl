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