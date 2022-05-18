module PQPolygonSDK

# include -
include("Include.jl")

# methods and types that we export -
export model
export url
export api
export ticker

# types -
export AbstractPolygonEndpointModel
export PQPolygonSDKUserModel

# market endpoints -
export PolygonPreviousCloseEndpointModel
export PolygonAggregatesEndpointModel
export PolygonOptionsContractReferenceEndpoint
export PolygonGroupedDailyEndpointModel
export PolygonDailyOpenCloseEndpointModel

# reference endpoints -
export PolygonTickerNewsEndpointModel
export PolygonTickerDetailsEndpointModel

# endpoint models from ycpan1012 
export PolygonMarketHolidaysEndpointModel
export PolygonExchangesEndpointModel
export PolygonStockSplitsEndpointModel
export PolygonMarketStatusEndpointModel
export PolygonDividendsEndpointModel
export PolygonTickersEndpointModel
export PolygonConditionsEndpointModel
export PolygonStockFinancialsEndpointModel
export PolygonTickerTypesEndpointModel 

# contract endpoints -
export AbstractPolygonOptionsContractModel
export PolygonPutOptionContractModel
export PolygonCallOptionContractModel

# options endpoints -
export PolygonOptionsSnapshotEndpointModel
export PolygonOptionsLastTradeEndpointModel


end # module
