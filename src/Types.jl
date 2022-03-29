mutable struct PQPolygonSDKUserModel

    # data about the user -
    email::String
    apikey::String

    PQPolygonSDKUserModel() = new()
end

# what is the base type for all endpoint calls?
abstract type AbstractPolygonEndpointModel end

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