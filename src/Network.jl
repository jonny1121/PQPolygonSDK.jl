function _http_get_call_with_url(url::String)::Some

    try

        # should we check if this string is formatted as a URL?
        if (occursin("https://", url) == false)
            throw(ArgumentError("url $(url) is not properly formatted"))
        end

        # ok, so we are going to make a HTTP GET call with the URL that was passed in -
        # we want to handle the errors on our own, so do NOT have HTTP.j throw an excpetion -
        response = HTTP.request("GET", url; status_exception = false)

        # return the body -
        return Some(String(response.body))
    catch error

        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # Package the error -
        return Some(vl_error_obj)
    end
end

function _process_polygon_response(model::Type{T}, 
    response::String)::Tuple where T<:AbstractPolygonEndpointModel

    # setup type handler map -> could we put this in a config file to register new handlers?
    type_handler_dict = Dict{Any,Function}()
    type_handler_dict[PolygonAggregatesEndpointModel] = _process_aggregates_polygon_call_response
    type_handler_dict[PolygonOptionsContractReferenceEndpoint] = _process_options_reference_call_response
    type_handler_dict[PolygonPreviousCloseEndpointModel] = _process_previous_close_polygon_call_response
    type_handler_dict[PolygonGroupedDailyEndpointModel] = _process_aggregates_polygon_call_response
    type_handler_dict[PolygonDailyOpenCloseEndpointModel] = _process_daily_open_close_call_response
    type_handler_dict[PolygonTickerNewsEndpointModel] = _process_ticker_news_call_response
    type_handler_dict[PolygonTickerDetailsEndpointModel] = _process_ticker_details_call_response
    type_handler_dict[PolygonStockTradesEndpointModel] = _process_stock_trades_call_response
    
    # options -
    type_handler_dict[PolygonOptionsLastTradeEndpointModel] = _process_options_last_trade_call_response
    type_handler_dict[PolygonOptionsQuotesEndpointModel] = _process_options_quotes_call_response
    type_handler_dict[PolygonOptionsContractSnapshotEndpointModel] = _process_snapshot_option_contract_response
    type_handler_dict[PolygonOptionsTradesEndpointModel] = _process_options_trade_call_response
    type_handler_dict[PolygonOptionsChainSnapshotEndpointModel] = _process_options_chain_snapshot_call_response 

    # technical indicators -
    type_handler_dict[PolygonTechnicalIndicatorSMAEndpointModel] = _process_ti_sma_call_response 
    type_handler_dict[PolygonTechnicalIndicatorEMAEndpointModel] = _process_ti_ema_call_response 
    type_handler_dict[PolygonTechnicalIndicatorMACDEndpointModel] = _process_ti_macd_call_response
    type_handler_dict[PolygonTechnicalIndicatorRSIEndpointModel] = _process_ti_rsi_call_response 

    # handlers from ycpan1012 -
    type_handler_dict[PolygonMarketHolidaysEndpointModel] = _process_market_holidays_call_response #ycpan
    type_handler_dict[PolygonExchangesEndpointModel] = _process_exchanges_call_response #ycpan
    type_handler_dict[PolygonStockSplitsEndpointModel] = _process_stock_splits_call_response #ycpan
    type_handler_dict[PolygonMarketStatusEndpointModel] = _process_market_status_call_response #ycpan
    type_handler_dict[PolygonDividendsEndpointModel] = _process_dividends_call_response #ycpan
    type_handler_dict[PolygonTickersEndpointModel] = _process_tickers_call_response #ycpan
    type_handler_dict[PolygonConditionsEndpointModel] = _process_conditions_call_response #ycpan
    type_handler_dict[PolygonStockFinancialsEndpointModel] = _process_stock_financials_call_response #ycpan
    type_handler_dict[PolygonTickerTypesEndpointModel] = _process_ticker_types_call_response #ycpan

    # handlers from js2879
    type_handler[PolygonStockLastTrade] = _process_stock_last_trade
    type_handler[PolygonStockLastQuote] = _process_stock_last_quote
    type_handler[PolygonStockSnapshotAllTickers] = _process_snapshots_all_tickers
    type_handler[PolygonStockGainersLosers] = _process_snapshots_gainers_losers
    type_handler[PolygonStockTicker] = _process_snapshots_ticker
    type_handler[PolygonStockUniversalSnapshot] = _process_snapshots_universal_snapshot
    type_handler[PolygonTickerEvents] = _process_ticker_events
    type_handler[PolygonTickerNews] = _process_ticker_news
    
   
    # lookup the type -
    if (haskey(type_handler_dict, model) == true)
        handler_function = type_handler_dict[model]
        return handler_function(response);
    end

    # default -
    return nothing
end

function api(model::Type{T}, complete_url_string::String;
    handler::Function = _process_polygon_response)::Tuple where T<:AbstractPolygonEndpointModel

    # execute -
    result_string = _http_get_call_with_url(complete_url_string) |> check

    # process and return -
    return handler(model, result_string)
end