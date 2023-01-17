mutable struct PQPolygonSDKUserModel

    # data about the user -
    email::String
    apikey::String

    PQPolygonSDKUserModel() = new()
end

# what is the base type for all endpoint calls?
abstract type AbstractPolygonEndpointModel end
abstract type AbstractPolygonOptionsContractModel end

mutable struct PolygonGroupedDailyEndpointModel <: AbstractPolygonEndpointModel

    # data -
    date::Date
    adjusted::Bool
    apikey::String
    
    # constructor -
    PolygonGroupedDailyEndpointModel() = new()
end

mutable struct PolygonDailyOpenCloseEndpointModel <: AbstractPolygonEndpointModel

    # data -
    ticker::String
    adjusted::Bool
    date::Date
    apikey::String

    # constructor -
    PolygonDailyOpenCloseEndpointModel() = new()
end

mutable struct PolygonPreviousCloseEndpointModel <: AbstractPolygonEndpointModel

    # data -
    ticker::String
    adjusted::Bool
    apikey::String

    # constructor -
    PolygonPreviousCloseEndpointModel() = new()
end

mutable struct PolygonAggregatesEndpointModel <: AbstractPolygonEndpointModel

    # data -
    adjusted::Bool
    limit::Int64
    sortdirection::String
    ticker::String
    to::Date
    from::Date
    multiplier::Int64
    timespan::String
    apikey::String

    # constructor -
    PolygonAggregatesEndpointModel() = new()
end

mutable struct PolygonTickerNewsEndpointModel <: AbstractPolygonEndpointModel

    # data -
    ticker::String
    published_utc::Union{Date, Nothing}
    order::String
    limit::Int64
    sort::Union{String, Nothing}
    apikey::String

    # constructor -
    PolygonTickerNewsEndpointModel() = new()
end

mutable struct PolygonTickerDetailsEndpointModel <: AbstractPolygonEndpointModel

    # data -
    apikey::String
    ticker::String
    date::Date

    # constructor -
    PolygonTickerDetailsEndpointModel() = new()
end

# endpoints from ycpan1012
mutable struct PolygonMarketHolidaysEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String    

    # constructor -
    PolygonMarketHolidaysEndpointModel() = new()
end

mutable struct PolygonExchangesEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    asset_class::String
    locale::String
    
    # constructor -
    PolygonExchangesEndpointModel() = new()
end

mutable struct PolygonStockSplitsEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    ticker::String
    execution_date::String
    reverse_split::String
    order::String
    limit::String
    sort::String
    
    # constructor -
    PolygonStockSplitsEndpointModel() = new()
end

mutable struct PolygonMarketStatusEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data - 
    apikey::String    

    # constructor -
    PolygonMarketStatusEndpointModel() = new()
end

mutable struct PolygonDividendsEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    ticker::String
    ex_dividend_date::String
    record_date::String
    declaration_date::String
    pay_date::String
    frequency::String
    cash_amount::String
    dividend_type::String
    order::String
    limit::String
    sort::String
    
    # constructor -
    PolygonDividendsEndpointModel() = new()
end

mutable struct PolygonTickersEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    ticker::String
    type::String
    market::String
    exchange::String
    cusip::String
    cik::String
    date::String
    search::String
    active::Bool
    sort::String
    order::String
    limit::String
        
    
    # constructor -
    PolygonTickersEndpointModel() = new()
end

mutable struct PolygonConditionsEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    asset_class::String
    data_type::String
    id::String
    sip::String
    order::String
    limit::String
    sort::String
        
    
    # constructor -
    PolygonConditionsEndpointModel() = new()
end

mutable struct PolygonStockFinancialsEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    ticker::String
    cik::String
    company_name::String
    sic::String
    filing_date::String
    period_of_report_date::String
    timeframe::String
    include_sources::String
    order::String
    limit::String
    sort::String
    
    # constructor -
    PolygonStockFinancialsEndpointModel() = new()
end

mutable struct PolygonTickerTypesEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    asset_class::String
    locale::String

    # constructor -
    PolygonTickerTypesEndpointModel() = new()
end

# options contract models -
mutable struct PolygonCallOptionContractModel <: AbstractPolygonOptionsContractModel
    
    # data -
    underlying::String
    expiration::Date
    strike::Float64
    
    # constructor -
    PolygonCallOptionContractModel() = new()
end

mutable struct PolygonPutOptionContractModel <: AbstractPolygonOptionsContractModel
    
    # data -
    underlying::String
    expiration::Date
    strike::Float64

    # constructor -
    PolygonPutOptionContractModel() = new()
end

# === OPTIONS CONTRACT ENDPOINTS BELOW HERE ========================================================== #
# options endpoints -
mutable struct PolygonOptionsSnapshotEndpointModel <: AbstractPolygonEndpointModel

    # data -
    underlying::String
    ticker::String
    apikey::String

    # constructor -
    PolygonOptionsSnapshotEndpointModel() = new()
end

mutable struct PolygonOptionsLastTradeEndpointModel <: AbstractPolygonEndpointModel

    # data -
    ticker::String
    apikey::String

    # constructor -
    PolygonOptionsLastTradeEndpointModel() = new()
end

mutable struct PolygonOptionsContractReferenceEndpoint <: AbstractPolygonEndpointModel

    # data -
    ticker::Union{Nothing,String}
    underlying_ticker::Union{Nothing, String}
    contract_type::String
    expiration_date::Date
    limit::Int64
    order::String
    sort::String
    apikey::String

    # constructor -
    PolygonOptionsContractReferenceEndpoint() = new()
end

mutable struct PolygonOptionsQuotesEndpointModel <: AbstractPolygonEndpointModel

    # required -
    ticker::String
    timestamp::Date
    apikey::String

    # additional -
    order::Union{Nothing,String}
    limit::Union{Nothing,Int}
    sort::Union{Nothing,String}
    
    # constructor -
    PolygonOptionsQuotesEndpointModel() = new()
end

mutable struct PolygonOptionsTradesEndpointModel <: AbstractPolygonEndpointModel

    # required -
    ticker::String
    timestamp::Union{Nothing, Date}
    apikey::String

    # additional -
    order::Union{Nothing,String}
    limit::Union{Nothing,Int}
    sort::Union{Nothing,String}

    # constructor -
    PolygonOptionsTradesEndpointModel() = new()
end
# === OPTIONS CONTRACT ENDPOINTS ABOVE HERE ========================================================== #

# === STOCK ENDPOINTS BELOW HERE ===================================================================== #
mutable struct PolygonStockTradesEndpointModel <: AbstractPolygonEndpointModel

    # required -
    ticker::String
    timestamp::Date
    apikey::String

    # additional -
    order::Union{Nothing,String}
    limit::Union{Nothing,Int}
    sort::Union{Nothing,String}

    # constructor -
    PolygonStockTradesEndpointModel() = new()
end
# === STOCK ENDPOINTS ABOVE HERE ===================================================================== #

# === TECHNICAL INDICATOR ENDPOINTS BELOW HERE ======================================================= #
mutable struct PolygonTechnicalIndicatorSMAEndpointModel <: AbstractPolygonEndpointModel

    # data
    ticker::String
    apikey::String
    timespan::String
    timestamp::Union{Nothing, Date}
    adjusted::Union{Nothing,Bool}
    window::Union{Nothing,Int}
    series_type::Union{Nothing,String}
    expand_underlying::Union{Nothing,Bool}
    order::Union{Nothing,String}
    limit::Union{Nothing,Int}

    # constructor -
    PolygonTechnicalIndicatorSMAEndpointModel() = new()
end

mutable struct PolygonTechnicalIndicatorEMAEndpointModel <: AbstractPolygonEndpointModel
end

mutable struct PolygonTechnicalIndicatorMACDEndpointModel <: AbstractPolygonEndpointModel
end

mutable struct PolygonTechnicalIndicatorRSIEndpointModel <: AbstractPolygonEndpointModel
end
# === TECHNICAL INDICATOR ENDPOINTS ABOVE HERE ======================================================= #