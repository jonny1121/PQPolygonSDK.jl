using PQPolygonSDK
using Dates
using DataFrames

# build a user model -
options = Dict{String,Any}()
options["email"] = "jvarner@paliquant.com"
options["apikey"] = "abc123" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)
# endpoint data -
# ticker::String
# apikey::String
# timespan::String
# timestamp::Union{Nothing, Date}
# adjusted::Union{Nothing,Bool}
# window::Union{Nothing,Int}
# series_type::Union{Nothing,String}
# expand_underlying::Union{Nothing,Bool}
# order::Union{Nothing,String}
# limit::Union{Nothing,Int}

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["adjusted"] = true
endpoint_options["limit"] = 200
endpoint_options["order"] = "desc"
endpoint_options["expand_underlying"] = true
endpoint_options["series_type"] = "close"
endpoint_options["window"] = 50
endpoint_options["adjusted"] = true
endpoint_options["timespan"] = "day"
endpoint_options["ticker"] = "AMD"
endpoint_options["timestamp"] = nothing
endpoint_model = model(PolygonTechnicalIndicatorEMAEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, df_ema, df_underlying) = api(PolygonTechnicalIndicatorEMAEndpointModel, my_url_string)